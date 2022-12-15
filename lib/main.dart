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
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        height: 10,
        onValueChanged: (p0) {},
        sliderColor: Colors.orangeAccent,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Color sliderColor;
  final double height;
  final double? thumbSize;
  final Function(double) onValueChanged;
  const MyHomePage({
    super.key,
    required this.title,
    required this.onValueChanged,
    required this.height,
    this.thumbSize,
    required this.sliderColor,
  });

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double sliderWidth = MediaQuery.of(context).size.width - 100;
    final double thumbSize = widget.thumbSize ?? widget.height * 2;
    final double thumbPosition = (_sliderValue / max) * sliderWidth;
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
                  _sliderValue += details.delta.dx / sliderWidth * max;
                  if (_sliderValue < minVal) {
                    _sliderValue = minVal;
                  } else if (_sliderValue > max) {
                    _sliderValue = max;
                  }

                  // Snap to nearest value
                  _sliderValue = (_sliderValue / (max / 4)) * (max / 4);

                  // Update the value
                  widget.onValueChanged(_sliderValue.roundToDouble());
                });
              },
              child: SizedBox(
                height: widget.height * 2,
                width: sliderWidth + thumbWidth,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.loose,
                  children: [
                    Container(
                      height: widget.height,
                      width: sliderWidth,
                      decoration: BoxDecoration(
                        color: widget.sliderColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: widget.height,
                          width: thumbPosition,
                          child: ColoredBox(color: widget.sliderColor),
                        )),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(divider, (index) {
                        final indexPositionInRow = (sliderWidth / divider) * index + thumbWidth / 2;
                        final bool isActive = (indexPositionInRow) < thumbPosition;

                        //calculate index position

                        return CustomPaint(
                          painter: CirclePainter(
                            mainColor: isActive ? Colors.blue : Colors.white,
                            secondColor: Colors.blue,
                          ),
                          size: Size(thumbSize, thumbSize),
                        );
                      }),
                    ),
                    Positioned(
                      left: thumbPosition,
                      child: SizedBox.square(
                        dimension: thumbSize,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            shape: BoxShape.circle,
                          ),
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
