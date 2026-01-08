import 'package:animated_background/animated_background.dart';
import 'package:heart_rate_app/screens/loginpage.dart';
import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  const Background({super.key});

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> with TickerProviderStateMixin {
  double dragX = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x003b3a55),
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            spawnMaxRadius: 60,
            spawnMinSpeed: 15,
            spawnMaxSpeed: 40,
            particleCount: 80,
            baseColor: Colors.blue,
          ),
        ),
        child: Align(
          alignment: const FractionalOffset(0.5, 0.9),
          child: Stack(
            children: [
              // Nền
              Container(
                width: 150,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),

              // Nút kéo
              Positioned(
                left: dragX,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      dragX += details.delta.dx;

                      if (dragX < 0) dragX = 0;
                      if (dragX > 90) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Loginpage(),
                          ),
                        ).then((_) {
                          setState(() {
                            dragX = 0;
                          });
                        });
                      }
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    setState(() {
                      if (dragX < 90) {
                        dragX = 0;
                      }
                    });
                  },

                  child: Container(
                    width: 150,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
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
    );
  }
}
