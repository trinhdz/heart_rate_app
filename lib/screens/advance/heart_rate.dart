import 'package:flutter/material.dart';
import 'package:heart_rate_app/firebase/heart_rate_provider.dart';
import 'package:provider/provider.dart';

class HeartRate extends StatefulWidget {
  const HeartRate({super.key});

  @override
  State<HeartRate> createState() => _HeartRateState();
}

class _HeartRateState extends State<HeartRate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heart = context.watch<HeartRateProvider>();

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Heart Rate",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.28,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/heart_rate.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                bottom: 20,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  buildItem("Max", heart.maxBPM),
                                  SizedBox(width: 20),
                                  buildItem("Min", heart.minBPM),
                                  SizedBox(width: 20),
                                  buildItem("Avg", heart.avgBPM),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: GestureDetector(
                                onTap: () async {
                                  await context
                                      .read<HeartRateProvider>()
                                      .startNewSession();
                                },
                                child: Container(
                                  width: 90,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.red,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "New",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Data",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var chunk in heart.chunks) heartRect(chunk),
                    if (heart.buffer.isNotEmpty) heartRect(heart.buffer),
                  ],
                ),
              ),
            ),
          ],
        ),

        if (heart.isSessionCompleted)
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.6),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 32),
              ),
            ),
          ),
      ],
    );
  }

  Widget heartRect(List<double> bpmList) {
    double maxBPM = bpmList.reduce((a, b) => a > b ? a : b);
    double minBPM = bpmList.reduce((a, b) => a < b ? a : b);
    double avgBPM = bpmList.reduce((a, b) => a + b) / bpmList.length;

    return Container(
      width: 380,
      height: 70,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xff271045),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monitor_heart_outlined, size: 50, color: Colors.blue),
              Text(
                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} "
                "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Heart Rate",
                style: TextStyle(color: Colors.blue, fontSize: 24),
              ),
              Row(
                children: [
                  Text(
                    "Max: ${maxBPM.toStringAsFixed(0)}",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Min: ${minBPM.toStringAsFixed(0)}",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Avg: ${avgBPM.toStringAsFixed(0)}",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.more, color: const Color.fromARGB(255, 236, 126, 62)),
        ],
      ),
    );
  }

  Widget buildItem(String title, double value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: TextStyle(fontSize: 20, color: Colors.white)),
        Text(
          value.toStringAsFixed(0),
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }
}
