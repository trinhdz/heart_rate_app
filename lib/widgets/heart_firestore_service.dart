import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HeartFirestoreService {
  final _db = FirebaseFirestore.instance;

  String _dayId(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  Future<void> saveDayResult({
    required DateTime date,
    required double avgBpm,
    required double avgRisk,
    required int chunkCount,
  }) async {
    final id = _dayId(date);

    await _db.collection('heart_results').doc(id).set({
      'avgBpm': avgBpm,
      'avgRisk': avgRisk,
      'chunkCount': chunkCount,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDay(DateTime date) {
    final id = _dayId(date);
    return _db.collection('heart_results').doc(id).snapshots();
  }
}
