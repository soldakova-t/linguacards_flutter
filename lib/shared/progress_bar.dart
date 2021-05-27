import 'package:flutter/material.dart';
import 'package:magicards/shared/shared.dart';

class AnimatedProgress extends StatelessWidget {
  final double value;
  final double height;

  AnimatedProgress({Key key, @required this.value, this.height = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressLayoutBuilder(value: value, height: height);
  }
}


class ProgressLayoutBuilder extends StatelessWidget {
  final double value;
  final double height;

  const ProgressLayoutBuilder(
      {Key key, @required this.value, this.height = 12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return Container(
          width: box.maxWidth,
          child: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: (value == 0) ? hexToColor("#F6F6F6") : hexToColor("#EEEEEE"),
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                height: height,
                width: box.maxWidth * _floor(value),
                decoration: BoxDecoration(
                  color: MyColors.mainBrightColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Always round negative or NaNs to min value
_floor(double value, [min = 0.0]) {
  return value.sign <= min ? min : value;
}


// USE VERY CARAFULLY. DOESN'T WORK WITH STREAMBUILDER
/*class AnimatedProgressWithDelay extends StatefulWidget {
  final double value;
  final double height;

  AnimatedProgressWithDelay({Key key, this.value, this.height = 8})
      : super(key: key);

  @override
  _AnimatedProgressWithDelayState createState() =>
      _AnimatedProgressWithDelayState();
}

class _AnimatedProgressWithDelayState<T>
    extends State<AnimatedProgressWithDelay> {
  double _currentValue = 0.0;

  _AnimatedProgressWithDelayState() {
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        print("setState" + widget.value.toString());
        _currentValue = widget.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressLayoutBuilder(
        value: _currentValue, height: widget.height);
  }
}
*/