import 'package:flutter/material.dart';
import 'package:magicards/shared/shared.dart';

class AdditionalButton extends StatelessWidget {
  const AdditionalButton({
    Key key,
    @required this.title,
    @required this.action,
  }) : super(key: key);

  final String title;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          style: mySecondaryButtonStyle,
          child: Center(
              child: Text(
            title,
            style: mySecondaryButtonTextStyle,
          )),
          onPressed: action,
        ),
      ),
    );
  }
}
