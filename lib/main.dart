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

  // This method is called when the slider changes
  void onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 20;
    const minVal = 0.0;
    const max = 100.0;
    const thumbWidth = 20.0;
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
