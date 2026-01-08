import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heart_rate_app/firebase/heart_ml_service.dart';

class HeartPredictProvider extends ChangeNotifier {
  final _rtdb = FirebaseDatabase.instance.ref('BPM');
  StreamSubscription? _sub;
  final _ml = HeartMLService();

  List<double> bpmBuffer = [];
  List<double> chunkResults = [];
  double lastPredict = 0;

  double get finalPercent {
    if (chunkResults.isEmpty) return 0;

    return (chunkResults.reduce((a, b) => a + b) / chunkResults.length) * 100;
  }

  Future<void> start() async {
    await _ml.load();
    _sub?.cancel();
    _sub = _rtdb.onValue.listen((event) {
      final v = event.snapshot.value;
      final bpm = double.tryParse(v.toString());
      if (bpm != null) _addBPM(bpm);
    });
  }

  void _addBPM(double bpm) {
    bpmBuffer.add(bpm);

    if (bpmBuffer.length == 5) {
      final chunk = List<double>.from(bpmBuffer);
      bpmBuffer.clear();
      _predictChunk(chunk);
    }

    notifyListeners();
  }

  Future<void> _predictChunk(List<double> chunk) async {
    final input = await _buildInput(chunk);
    final result = _ml.predict(input);

    lastPredict = result;
    chunkResults.add(result);

    notifyListeners();
  }

  Future<List<double>> _buildInput(List<double> chunk) async {
    // MAX HR
    final maxHr = chunk.reduce((a, b) => a > b ? a : b);

    final doc = await FirebaseFirestore.instance
        .collection('user_info')
        .doc('profile')
        .get();

    final data = doc.data() ?? {};

    double numVal(String k, double def) =>
        (data[k] is num) ? (data[k] as num).toDouble() : def;

    double sexVal() {
      final s = data['sex'];
      if (s == 'male') return 1;
      if (s == 'female') return 0;
      return 1;
    }

    const means = {
      "age": 53.720168,
      "sex": 0.763866,
      "chest": 3.232773,
      "bp": 132.153782,
      "chol": 210.363866,
      "sugar": 0.213445,
      "ecg": 0.698319,
      "angina": 0.922773,
      "oldpeak": 1.62437,
      "slope": 1.62437,
      "hr": 139.732773,
    };

    const stds = {
      "age": 9.358203,
      "sex": 0.424884,
      "chest": 0.935480,
      "bp": 18.368823,
      "chol": 101.420489,
      "sugar": 0.409912,
      "ecg": 0.870359,
      "angina": 1.086337,
      "oldpeak": 1.086337,
      "slope": 0.610459,
      "hr": 25.517636,
    };

    double scale(String key, double val) => (val - means[key]!) / stds[key]!;

    return [
      scale('age', numVal('age', 50)),
      scale('sex', sexVal()),
      scale('chest', numVal('chest', 0)),
      scale('bp', numVal('bp', 120)),
      scale('chol', numVal('chol', 200)),
      scale('sugar', numVal('sugar', 0)),
      scale('ecg', numVal('ecg', 0)),
      scale('angina', numVal('angina', 0)),
      scale('hr', maxHr), // ✅ MAX HR
      scale('oldpeak', numVal('oldpeak', 0.0)),
      scale('slope', numVal('slope', 1)),
    ];
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
