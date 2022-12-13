import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _sliderValue = 0.0;
  static const double minVal = 0.0, max = 100.0;
  final double thumbWidth = 20.0;
  final int divider = 5;

  // This method is called when the slider changes
  void onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 20;
    final thumbPosition = (_sliderValue / max) * (screenWidth - thumbWidth);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_sliderValue.toStringAsFixed(0)),
            const SizedBox(height: 36),
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _sliderValue += details.delta.dx / screenWidth * max;
                  if (_sliderValue < minVal) {
                    _sliderValue = minVal;
                  } else if (_sliderValue > max) {
                    _sliderValue = max;
                  }

                  // Snap to nearest value
                  _sliderValue = (_sliderValue / (max / 4)) * (max / 4).round();
                });
              },
              child: SizedBox(
                height: 50,
                width: screenWidth,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      height: 10,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                            divider,
                            (index) => CustomPaint(
                                  painter: CirclePainter(),
                                  size: const Size(20, 20),
                                ))),
                    Positioned(
                      left: thumbPosition,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color? mainColor;
  final Color? secondColor;
  CirclePainter({this.mainColor, this.secondColor});
  @override
  void paint(Canvas canvas, Size size) {
    //inner circle
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(10, 10), 10, paint);

    //outer circle
    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(const Offset(10, 10), 10, paint);

    //inner circle
    paint
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(const Offset(10, 10), 8, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
