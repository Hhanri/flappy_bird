import 'dart:async';

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

  double time = 0;
  static double birdY = 0;
  double initialPosition = birdY;
  bool hasStarted = false;

  static final List<double> barrierX = [2, 2+1.5];
  static const double barrierY = 0.5;

  List<List<double>> barrierHeight = [
    //[topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  void start() {
    hasStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final height = gravity * time * time + velocity * time;
      setState(() {
        birdY = initialPosition - height;
      });

      if (isBirdDead()) {
        timer.cancel();
        _showDialog();
      }

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
    return false;
  }

  void resetGame() {
    Navigator.of(context).pop();
    setState(() {
      time = 0;
      birdY = 0;
      initialPosition = 0;
      hasStarted = false;
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
                    children: [
                      Bird(birdY: birdY, width: 0.1, height: 0.1,),
                      if (!hasStarted) Container(
                        alignment: const Alignment(0, -0.5),
                        child: const Text(
                          "TAP TO PLAY",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
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
