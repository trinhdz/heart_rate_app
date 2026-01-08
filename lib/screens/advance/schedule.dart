import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:heart_rate_app/screens/advance/day_heart_detail_sheet.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime currentDate = DateTime.now();

  List<DateTime> _daysInMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return List.generate(
      lastDay.day,
      (index) => DateTime(date.year, date.month, index + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = _daysInMonth(currentDate);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      currentDate = DateTime(
                        currentDate.year,
                        currentDate.month - 1,
                      );
                    });
                  },
                ),
                Text(
                  DateFormat("MMMM yyyy").format(currentDate),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      currentDate = DateTime(
                        currentDate.year,
                        currentDate.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("T2", style: TextStyle(color: Colors.white)),
                Text("T3", style: TextStyle(color: Colors.white)),
                Text("T4", style: TextStyle(color: Colors.white)),
                Text("T5", style: TextStyle(color: Colors.white)),
                Text("T6", style: TextStyle(color: Colors.white)),
                Text("T7", style: TextStyle(color: Colors.white)),
                Text("CN", style: TextStyle(color: Colors.red)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 330,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isToday =
                      day.day == DateTime.now().day &&
                      day.month == DateTime.now().month &&
                      day.year == DateTime.now().year;
                  final isSunday = day.weekday == DateTime.sunday;

                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => DayHeartDetailSheet(date: day),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isToday ? Colors.blue.withOpacity(0.3) : null,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isToday
                              ? Colors.blue
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${day.day}",
                        style: TextStyle(
                          color: isSunday ? Colors.red : Colors.white,
                          fontWeight: isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
