import 'package:flutter/material.dart';
import 'package:magicards/screens/screens.dart';
import 'package:magicards/services/models.dart';
import 'package:magicards/shared/shared.dart';
import '../services/globals.dart';

class TitleAndShowAll extends StatelessWidget {
  const TitleAndShowAll({
    Key key,
    @required this.title,
    this.showButtonAll,
    this.ref, this.passedTopics, this.passedTitle,
  }) : super(key: key);

  final String title;
  final bool showButtonAll;
  final String ref;
  final List<Topic> passedTopics;
  final String passedTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: convertWidthFrom360(context, 16)),
      height: 25,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: convertWidthFrom360(context, 240),
                child: Text(title, style: myHeaderStyle),
              ),
            ),
          ),
          if (showButtonAll == true)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).push(createRouteScreen(ref, topics: passedTopics, title: passedTitle));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: convertWidthFrom360(context, 16),
                      vertical: convertHeightFrom360(context, 360, 4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Показать все",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: MyColors.mainBrightColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
