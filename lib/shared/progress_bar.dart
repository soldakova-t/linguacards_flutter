import 'package:flutter/material.dart';
import 'package:magicards/shared/shared.dart';
import 'dart:async';

class AnimatedProgressBar extends StatefulWidget {
  final double value;
  final double height;

  AnimatedProgressBar({Key key, @required this.value, this.height = 12})
      : super(key: key);

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> {
  double _currentValue = 0.0;

  _AnimatedProgressBarState() {
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _currentValue = widget.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return Container(
          width: box.maxWidth,
          child: Stack(
            children: [
              Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: hexToColor('#E2E1E1'),
                  borderRadius: BorderRadius.all(
                    Radius.circular(widget.height),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                height: widget.height,
                width: box.maxWidth * _floor(_currentValue),
                decoration: BoxDecoration(
                  color: MyColors.greenBrightColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(widget.height),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Always round negative or NaNs to min value
  _floor(double value, [min = 0.0]) {
    return value.sign <= min ? min : value;
  }
}
