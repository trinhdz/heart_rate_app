import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:heart_rate_app/widgets/heart_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DayHeartDetailSheet extends StatelessWidget {
  final DateTime date;
  final HeartFirestoreService firestore = HeartFirestoreService();

  DayHeartDetailSheet({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: firestore.streamDay(date),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Text(
                "Chưa có dữ liệu",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final data = snapshot.data!.data()!;
        final avgBpm =
            data['avgBpm'] != null ? (data['avgBpm'] as num).toDouble().toStringAsFixed(1) : "--";
        final risk = data['avgRisk'] != null
            ? ((data['avgRisk'] as num) > 0.5 ? "CAO" : "THẤP")
            : "--";
        final chunkCount = data['chunkCount']?.toString() ?? "--";

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "📅 ${DateFormat('dd/MM/yyyy').format(date)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _infoRow("Avg BPM", avgBpm),
              _infoRow("Nguy cơ", risk),
              _infoRow("Số chunk", chunkCount),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Đóng",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
