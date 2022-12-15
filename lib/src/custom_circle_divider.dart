import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final Color? mainColor;
  final Color? secondColor;
  CirclePainter({this.mainColor, this.secondColor});
  @override
  void paint(Canvas canvas, Size size) {
    //inner circle
    var paint = Paint()
      ..color = mainColor ?? Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(10, 10), 10, paint);

    //outer circle
    paint
      ..color = mainColor ?? Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(const Offset(10, 10), 10, paint);

    //inner circle
    paint
      ..color = secondColor ?? Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(const Offset(10, 10), 8, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
