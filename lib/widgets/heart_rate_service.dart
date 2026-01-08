import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class HeartRateListenerService {
  final DatabaseReference _rtDb = FirebaseDatabase.instance.ref('BPM');
  StreamSubscription<DatabaseEvent>? _sub;


  void startListening(void Function(num bpm) onBPM) {
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

  void stopListening() {
    _sub?.cancel();
    _sub = null;
  }

  void dispose() {
    stopListening();
  }
}
