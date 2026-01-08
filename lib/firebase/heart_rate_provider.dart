import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:heart_rate_app/firebase/heart_ml_service.dart';
import 'package:heart_rate_app/widgets/heart_firestore_service.dart';
import 'package:heart_rate_app/widgets/userinfo_provider.dart';

///  RTDB

class HeartRateService {
  final _rtDb = FirebaseDatabase.instance.ref('BPM');
  StreamSubscription<DatabaseEvent>? _sub;

  void listenBPM(void Function(num bpm) onBPM) {
    _sub?.cancel();
    _sub = _rtDb.onValue.listen((event) {
      final val = event.snapshot.value;
      if (val == null) return;

      if (val is num) {
        onBPM(val);
      } else {
        final bpm = num.tryParse(val.toString());
        if (bpm != null) onBPM(bpm);
      }
    });
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}

class HeartRateProvider extends ChangeNotifier {
  final HeartRateService _service = HeartRateService();
  final HeartFirestoreService _firestoreService = HeartFirestoreService();
  final PersonProvider personProvider;

  HeartRateProvider({required this.personProvider});

  bool isSessionCompleted = false;

  List<double> chunkPredictions = [];

  double? get avgBpm10Chunks {
    if (chunks.length < 3) return null;
    final all = chunks.take(3).expand((e) => e).toList();
    if (all.isEmpty) return null;
    return all.reduce((a, b) => a + b) / all.length;
  }

  double get finalRiskPercent {
    if (chunkPredictions.length < 3) return 0;
    final avg = chunkPredictions.take(3).reduce((a, b) => a + b) / 3;
    return avg * 100;
  }

  List<double> buffer = [];

  List<List<double>> chunks = [];

  String? sessionId;
  int _chunkCounter = 0;

  double maxBPM = 0;
  double minBPM = 0;
  double avgBPM = 0;

  ValueNotifier<bool> showFinalDialog = ValueNotifier(false);

  Future<void> startNewSession() async {
    final doc = FirebaseFirestore.instance.collection('heart_sessions').doc();
    sessionId = doc.id;

    await doc.set({'createdAt': FieldValue.serverTimestamp()});

    buffer.clear();
    chunks.clear();
    chunkPredictions.clear();

    _chunkCounter = 0;
    maxBPM = 0;
    minBPM = 0;
    avgBPM = 0;
    isSessionCompleted = false;
    finalLog = null;

    notifyListeners();

    _service.listenBPM((bpm) {
      _addBPM(bpm.toDouble());
    });
  }

  void _addBPM(double bpm) {
    if (isSessionCompleted) return;

    buffer.add(bpm);

    if (buffer.length == 5) {
      final chunk = List<double>.from(buffer);
      chunks.add(chunk);
      buffer.clear();
      _saveChunkToFirestore(chunk);
    }

    _recalculateStats();
    notifyListeners();
  }

  void _recalculateStats() {
    final all = [...chunks.expand((e) => e), ...buffer];
    if (all.isEmpty) return;

    maxBPM = all.reduce((a, b) => a > b ? a : b);
    minBPM = all.reduce((a, b) => a < b ? a : b);
    avgBPM = all.reduce((a, b) => a + b) / all.length;
  }

  String? finalLog;

  Future<void> _saveChunkToFirestore(List<double> chunk) async {
    if (sessionId == null) return;

    _chunkCounter++;
    final ref = FirebaseFirestore.instance
        .collection('heart_sessions')
        .doc(sessionId)
        .collection('chunks');

    await ref.doc('chunk_$_chunkCounter').set({
      'values': chunk,
      'index': _chunkCounter,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _autoPredictChunk(chunk);

    if (_chunkCounter >= 3) {
      isSessionCompleted = true;
      _service.dispose();

      finalLog = finalRiskPercent > 50
          ? "Nguy cơ bệnh tim cao"
          : "Nguy cơ bệnh tim thấp";

      await _firestoreService.saveDayResult(
        date: DateTime.now(),
        avgBpm: avgBPM,
        avgRisk: finalRiskPercent / 100,
        chunkCount: 3,
      );

      showFinalDialog.value = true;
      notifyListeners();
    }
  }

  Future<void> _autoPredictChunk(List<double> chunk) async {
    final avgBpm = chunk.reduce((a, b) => a + b) / chunk.length;

    double scale(String key, double val) {
      const means = {
        "age": 53.72,
        "chest": 3.23,
        "bp": 132.15,
        "chol": 210.36,
        "sugar": 0.21,
        "ecg": 0.69,
        "angina": 0.387,
        "oldpeak": 0.922,
        "slope": 1.624,
        "maxHeartRate": 118.0,
      };
      const stds = {
        "age": 9.36,
        "chest": 0.93,
        "bp": 18.36,
        "chol": 101.42,
        "sugar": 0.41,
        "ecg": 0.87,
        "angina": 1.08,
        "oldpeak": 1.08,
        "slope": 0.61,
        "maxHeartRate": 10.0,
      };
      return (val - means[key]!) / stds[key]!;
    }

    final input = [
      scale("age", personProvider.age ?? 53.72),
      (personProvider.sex.toLowerCase() == "male") ? 1.0 : 0.0,
      scale("chest", personProvider.chest ?? 3.23),
      scale("bp", personProvider.bp ?? 132.15),
      scale("chol", personProvider.chol ?? 210.36),
      scale("sugar", personProvider.sugar ?? 0.213),
      scale("ecg", personProvider.ecg ?? 0.698),
      scale("maxHeartRate", avgBpm),
      scale("angina", personProvider.angina ?? 0.387),
      scale("oldpeak", personProvider.oldpeak ?? 0.922),
      scale("slope", personProvider.slope ?? 1.624),
    ];

    final ml = HeartMLService();
    await ml.load();
    final result = ml.predict(input);

    chunkPredictions.add(result);
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
