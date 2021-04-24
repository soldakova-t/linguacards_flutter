import 'package:flutter/material.dart';
import 'package:magicards/shared/shared.dart';

class SelectionListItem extends StatelessWidget {
  const SelectionListItem({
    Key key,
    @required this.title,
    @required this.action,
    this.progress,
    @required this.checked,
  }) : super(key: key);

  final String title;
  final Function action;
  final double progress;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[100],
            width: 1.0,
          ),
        ),
      ),
      width: double.infinity,
      height: 62,
      child: Row(
        children: <Widget>[
          checked == true ? Icon(Icons.check) : SizedBox(width: 24),
          SizedBox(width: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          if (progress != null)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 110,
                    child: AnimatedProgress(
                      height: 5,
                      value: progress,
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: Text(
                      (progress * 100).toInt().toString() + '%',
                      style: TextStyle(
                        fontSize: 12,
                        color: MyColors.subtitleColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
