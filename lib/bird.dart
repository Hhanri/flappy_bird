import 'package:flutter/material.dart';

class Bird extends StatelessWidget {
  final double birdY;
  final double width;
  final double height;
  const Bird({Key? key, required this.birdY, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, birdY),
      child: Image.asset('assets/images/bird.png',
        width: MediaQuery.of(context).size.height * width / 2,
        height: MediaQuery.of(context).size.height * 3/4 * height / 2,
      ),
    );
  }
}
