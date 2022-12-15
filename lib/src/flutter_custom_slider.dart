import 'package:flutter/material.dart';
import 'custom_circle_divider.dart';

class FlutterCustomSlider extends StatefulWidget {
  ///slider properties
  final Color backgroundColor;

  ///slider foreground color
  final Color? foreGroundColor;

  ///slider height
  final double height;

  ///slider thumb size
  final double? thumbSize;

  ///slider value changed callback
  final Function(double) onValueChanged;

  ///slider divider
  final int? divider, minVal, max;
  const FlutterCustomSlider({
    super.key,
    required this.onValueChanged,
    required this.height,
    this.thumbSize,
    required this.backgroundColor,
    this.divider,
    this.minVal,
    this.max,
    this.foreGroundColor,
  });

  @override
  State<FlutterCustomSlider> createState() => _FlutterCustomSliderState();
}

class _FlutterCustomSliderState extends State<FlutterCustomSlider> {
  double _sliderValue = 0.0;

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
    //calculate slider width
    final double sliderWidth = MediaQuery.of(context).size.width - 20;

    //calculate max and min value
    final double maxVal = widget.max?.toDouble() ?? 100;
    final double minVal = widget.minVal?.toDouble() ?? 0;

    //calculate thumb size
    final double thumbSize = widget.thumbSize ?? widget.height * 2;

    //calculate thumb position
    final double thumbPosition = (_sliderValue / maxVal) * sliderWidth;

    //calculate divider
    final int divider = widget.divider ?? 0;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_sliderValue.toStringAsFixed(0)),
            const SizedBox(height: 36),
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  // Calculate the new slider value
                  _sliderValue += details.delta.dx / sliderWidth * maxVal;

                  // Check if the value is in range
                  if (_sliderValue < minVal) {
                    _sliderValue = minVal;
                  } else if (_sliderValue > maxVal) {
                    _sliderValue = maxVal;
                  }

                  // Round the value to the nearest 25 for snapping
                  _sliderValue = _sliderValue.roundToDouble() % 25 == 0 ? _sliderValue.roundToDouble() : _sliderValue;

                  // Update the value
                  widget.onValueChanged(_sliderValue.roundToDouble());
                });
              },
              //slider container
              child: SizedBox(
                height: widget.height * 2,
                width: sliderWidth + thumbSize,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.loose,
                  children: [
                    //slider background
                    Container(
                      height: widget.height,
                      width: sliderWidth,
                      decoration: BoxDecoration(
                        color: widget.foreGroundColor ?? widget.backgroundColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    //slider foreground
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: widget.height,
                          width: thumbPosition,
                          child: ColoredBox(color: widget.backgroundColor),
                        )),

                    //Dividers
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(divider, (index) {
                        //calculate index position in row
                        final double position = ((sliderWidth + (thumbSize * 3)) / divider) * index;
                        final bool isActive = position <= thumbPosition;

                        return CustomPaint(
                          painter: CirclePainter(
                            mainColor: isActive ? Colors.blue : Colors.white,
                            secondColor: Colors.blue,
                          ),
                          size: Size(thumbSize, thumbSize),
                        );
                      }),
                    ),

                    //slider thumb
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
