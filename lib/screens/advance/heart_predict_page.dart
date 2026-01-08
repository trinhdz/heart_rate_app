import 'package:flutter/material.dart';
import 'package:heart_rate_app/widgets/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:heart_rate_app/firebase/heart_rate_provider.dart';

class HeartPredictScreen extends StatefulWidget {
  const HeartPredictScreen({super.key});

  @override
  State<HeartPredictScreen> createState() => _HeartPredictScreenState();
}

class _HeartPredictScreenState extends State<HeartPredictScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _heartScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HeartRateProvider>(
      builder: (context, hr, _) {
        final lastChunk = hr.chunks.isNotEmpty ? hr.chunks.last : null;
        final avgBpm = hr.avgBpm10Chunks;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          if (hr.showFinalDialog.value) {
            hr.showFinalDialog.value = false;

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Kết quả dự đoán"),
                content: Text(
                  hr.finalLog ?? "--",
                  style: TextStyle(
                    color: hr.finalRiskPercent > 50 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );

            if (hr.avgBpm10Chunks != null) {
              NotificationService.showPredictionResult(
                risk: hr.finalRiskPercent,
                bpm: hr.avgBpm10Chunks!,
              );
            }
          }
        });

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(14, 13, 16, 1),
                  ),
                  child: const Center(
                    child: Text(
                      "Dự đoán",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  hr.isSessionCompleted
                      ? "✅ Đã thu thập đủ BPM"
                      : "⏳ Đang thu thập BPM...",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),

                const SizedBox(height: 10),

                Text(
                  lastChunk != null
                      ? "Giá trị BPM:\n${lastChunk.map((e) => e.toStringAsFixed(0)).join(', ')}"
                      : "Chưa có giá trị để dự đoán",
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Kết quả từng dự đoán",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  hr.chunkPredictions.isEmpty
                      ? "Chưa có"
                      : "${hr.chunkPredictions.map((e) => e.toStringAsFixed(2)).join(", ")}  | Trung bình: ${(hr.chunkPredictions.reduce((a, b) => a + b) / hr.chunkPredictions.length * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(color: Colors.red),
                ),

                const SizedBox(height: 10),

                if (hr.chunkPredictions.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: getHeartColor(
                        hr.finalRiskPercent,
                      ).withOpacity(0.15),
                      border: Border.all(
                        color: getHeartColor(hr.finalRiskPercent),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          hr.finalRiskPercent > 50
                              ? Icons.warning_amber_rounded
                              : hr.finalRiskPercent <= 20
                              ? Icons.favorite
                              : Icons.monitor_heart,
                          color: getHeartColor(hr.finalRiskPercent),
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            hr.finalRiskPercent > 50
                                ? "Nguy cơ tim mạch CAO – nên kiểm tra y tế sớm"
                                : hr.finalRiskPercent <= 20
                                ? "Nguy cơ tim mạch THẤP – tim mạch ổn định"
                                : "Nguy cơ tim mạch TRUNG BÌNH – cần theo dõi thêm",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: getHeartColor(hr.finalRiskPercent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 120),

                Center(
                  child: ScaleTransition(
                    scale: _heartScale,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            getHeartColor(
                              hr.finalRiskPercent,
                            ).withOpacity(0.45),
                            const Color.fromRGBO(12, 12, 20, 1),
                          ],
                          radius: 0.85,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: getHeartColor(
                              hr.finalRiskPercent,
                            ).withOpacity(0.7),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.favorite_rounded,
                            size: 180,
                            color: getHeartColor(hr.finalRiskPercent),
                          ),

                          Positioned(
                            bottom: 50,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: Text(
                                    avgBpm != null
                                        ? "${avgBpm.toStringAsFixed(0)} BPM"
                                        : "-- BPM",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "nhịp tim trung bình",
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color getHeartColor(double? riskPercent) {
    if (riskPercent == null) return Colors.yellow;
    if (riskPercent > 50) return Colors.red;
    if (riskPercent <= 20) return Colors.green;
    return Colors.yellow;
  }
}
