import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final double width;
  final double height;
  final double barrierX;
  final bool isBottom;
  const Barrier({Key? key, required this.width, required this.height, required this.barrierX, required this.isBottom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2*barrierX + width) / 2 - width, isBottom ? 1 : -1),
      color: Colors.green,
      width: MediaQuery.of(context).size.width * width / 2,
      height: MediaQuery.of(context).size.height * height / 2,
    );
  }
}
