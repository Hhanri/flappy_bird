import 'dart:async';

import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final double gravity = -4.9;
  final double velocity = 3.5;
  final double birdWidth = 0.1;
  final double birdHeight = 0.1;

  double time = 0;
  static double birdY = 0;
  double initialPosition = birdY;
  bool hasStarted = false;

  static List<double> barrierX = [2, 2 + 1.5];
  static const double barrierWidth = 0.5;

  List<List<double>> barrierHeight = [
    //[topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  void start() {
    hasStarted = true;
    Timer.periodic(const Duration(milliseconds: 40), (timer) {
      final height = gravity * time * time + velocity * time;
      setState(() {
        birdY = initialPosition - height;
      });

      if (isBirdDead()) {
        timer.cancel();
        _showDialog();
      }

      moveMap();
      
      time += 0.01;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPosition = birdY;
    });
  }

  bool isBirdDead() {
    if (birdY > 1 || birdY < -1) return true;

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] - barrierWidth <= birdWidth*2
        && barrierX[i] + birdWidth >= -birdWidth*2
        && (birdY - 24/9 * birdHeight <= -1 + barrierHeight[i][0] || birdY >= 1 - barrierHeight[i][1] - 1.5 * birdHeight)
      ) return true;
    }

    return false;
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.006;
      });
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void resetGame() {
    Navigator.of(context).pop();
    setState(() {
      time = 0;
      birdY = 0;
      initialPosition = 0;
      hasStarted = false;
      barrierX = [2, 2 + 1.5];
    });
  }

  void _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: const Center(
            child: Text(
              "G A M E  O V E R",
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                    child: const Text("PLAY AGAIN", style: TextStyle(color: Colors.brown),),
                ),
              ),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: hasStarted ? jump : start,
              child: Container(
                color: Colors.lightBlue,
                child: Center(
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Bird(birdY: birdY, width: birdWidth, height: birdHeight,),
                      if (!hasStarted) Container(
                        alignment: const Alignment(0, -0.5),
                        child: const Text(
                          "TAP TO PLAY",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      
                      Barrier(
                        width: barrierWidth,
                        height: barrierHeight[0][0],
                        barrierX: barrierX[0],
                        isBottom: false
                      ),

                      Barrier(
                        width: barrierWidth,
                        height: barrierHeight[0][1],
                        barrierX: barrierX[0],
                        isBottom: true
                      ),

                      Barrier(
                        width: barrierWidth,
                        height: barrierHeight[1][0],
                        barrierX: barrierX[1],
                        isBottom: false
                      ),

                      Barrier(
                        width: barrierWidth,
                        height: barrierHeight[1][1],
                        barrierX: barrierX[1],
                        isBottom: true
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.brown,
            ),
          )
        ],
      ),
    );
  }
}
