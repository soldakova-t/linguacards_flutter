import 'package:flutter/material.dart';
import 'package:magicards/shared/shared.dart';

class MainButton extends StatelessWidget {
  const MainButton({
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
        width: double.infinity,
        height: 56,
        child: RaisedButton(
          onPressed: action,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: MyColors.mainBrightColor,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
