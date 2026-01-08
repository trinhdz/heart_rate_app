import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class HeartRateService {
  final DatabaseReference _rtDb = FirebaseDatabase.instance.ref('BPM');

  StreamSubscription<DatabaseEvent>? _sub;

  void listenBPM(void Function(double bpm) onBpm) {
    _sub?.cancel();

    _sub = _rtDb.onValue.listen((event) {
      final val = event.snapshot.value;
      if (val == null) return;

      double? bpm;

      if (val is num) {
        bpm = val.toDouble();
      } else if (val is String) {
        bpm = double.tryParse(val);
      } else if (val is Map) {
        final bpmVal = val['value'] ?? val['bpm'];
        if (bpmVal != null) {
          bpm = (bpmVal is num)
              ? bpmVal.toDouble()
              : double.tryParse(bpmVal.toString());
        }
      }

      if (bpm != null) {
        onBpm(bpm); // BPM mới
      }
    });
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
  }

  void dispose() {
    stop();
  }
}
