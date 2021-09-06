import 'package:flutter/material.dart';
import 'package:magicards/enums/connectivity_status.dart';
import 'package:magicards/enums/entitlement.dart';
import 'package:magicards/services/models.dart';
import 'package:magicards/services/revenuecat.dart';
import 'package:magicards/shared/shared.dart';
import 'package:provider/provider.dart';
import '../services/globals.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    Key key,
    @required this.categories,
    this.orientation,
  }) : super(key: key);

  final List<Category> categories;
  final String orientation;

  @override
  Widget build(BuildContext context) {
    if (orientation == "horizontal") {
      double categoryHeight = convertHeightFrom360(context, 140, 208);
      return Container(
        height: categoryHeight,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              double leftPadding = 0;
              if (orientation == "horizontal" && index == 0)
                leftPadding = convertWidthFrom360(context, 16);
              return Padding(
                padding: EdgeInsets.only(
                    left: leftPadding, right: convertWidthFrom360(context, 16)),
                child: Container(
                  width: convertWidthFrom360(context, 140),
                  child: _buildCategoriesListItem(
                      context, categories[index], index),
                ),
              );
            }),
      );
    } else {
      double categoryHeight = MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height / 1.5);

      return Container(
        child: Padding(
          padding: EdgeInsets.all(convertWidthFrom360(context, 16)),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: categoryHeight,
              ),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                double rightPadding = 0;
                if (index.isEven)
                  rightPadding = convertWidthFrom360(context, 16);
                return Padding(
                  padding: EdgeInsets.only(
                      right: rightPadding,
                      bottom: convertHeightFrom360(context, 360, 16)),
                  child: _buildCategoriesListItem(
                      context, categories[index], index),
                );
              }),
        ),
      );
    }
  }

  Widget _buildCategoriesListItem(
      BuildContext context, Category category, int index) {
    final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(createRouteScreen("/topics",
            topics: category.subtopics,
            title: category.title,
            premium: category.premium));
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(convertWidthFrom360(context, 16)),
              color: hexToColor(category.bgColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: convertWidthFrom360(context, 30),
                    left: convertWidthFrom360(context, 20),
                    right: convertWidthFrom360(context, 20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        category.title,
                        style: myTitleStyle,
                      ),
                      SizedBox(height: convertHeightFrom360(context, 360, 5)),
                      Text(
                        category.titleRus,
                        style: mySubtitleStyle,
                      ),
                      SizedBox(height: convertHeightFrom360(context, 360, 16)),
                      Text(
                        category.subtopics.length.toString() +
                            " " +
                            Strings.getWordTopics(category.subtopics.length),
                        style: mySubtitleStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          category.premium && (entitlement == Entitlement.free)
              ? Positioned(
                  top: 0,
                  right: 16,
                  child: Container(
                    height: convertHeightFrom360(context, 360, 17),
                    width: convertWidthFrom360(context, 51),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF656565)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(convertWidthFrom360(context, 6)),
                      ),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Text("плюс", style: myPremiumLabelStyle),
                    ),
                  ),
                )
              : Container(),
          Positioned(
            right: convertWidthFrom360(context, category.photoRightPadding),
            bottom: convertWidthFrom360(context, category.photoBottomPadding),
            child: Container(
              height: convertHeightFrom360(context, 76, category.photoHeight),
              alignment: Alignment.bottomRight,
              child: Image.network("http://lingvicards.ru/categories_photo/" +
                  category.number.toString() +
                  ".png"),
            ),
          ),
        ],
      ),
    );
  }
}
