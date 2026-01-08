import 'package:heart_rate_app/screens/advance/heart_predict_page.dart';
import 'package:heart_rate_app/screens/advance/heart_rate.dart';
import 'package:heart_rate_app/screens/advance/personInfo.dart';
import 'package:heart_rate_app/screens/advance/schedule.dart';
import 'package:heart_rate_app/widgets/backgroundwrapper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HeartRate(),
    HeartPredictScreen(),
    Schedule(),
    PersonInfo(),
  ];

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: SafeArea(bottom: false, child: _screens[_currentIndex]),

        // BOTTOM NAVIGATION (CUSTOM)
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            height: 60,
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xff191453).withOpacity(0.52),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (index) {
                final bool isSelected = _currentIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    transform: isSelected
                        ? Matrix4.translationValues(0, -8, 0)
                        : Matrix4.identity(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: isSelected ? 48 : 0,
                          height: isSelected ? 48 : 0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.5),
                              width: 3,
                            ),
                          ),
                        ),
                        Icon(
                          [
                            Icons.home,
                            Icons.bar_chart,
                            Icons.calendar_month_outlined,
                            Icons.person,
                          ][index],
                          color: isSelected ? Colors.blue : Colors.grey,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
