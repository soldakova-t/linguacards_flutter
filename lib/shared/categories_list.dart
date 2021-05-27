import 'package:flutter/material.dart';
import 'package:magicards/services/models.dart';
import 'package:magicards/shared/shared.dart';
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
      double categoryHeight = convertHeightFrom360(context, 140, 198);
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
      return Padding(
        padding: EdgeInsets.all(convertWidthFrom360(context, 16)),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.5), // Sets category height
            ),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              double rightPadding = 0;
              if (index.isEven) rightPadding = convertWidthFrom360(context, 16);
              return Padding(
                padding: EdgeInsets.only(
                    right: rightPadding,
                    bottom: convertHeightFrom360(context, 360, 16)),
                child: _buildCategoriesListItem(
                    context, categories[index], index),
              );
            }),
      );
    }
  }

  Widget _buildCategoriesListItem(
      BuildContext context, Category category, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(createRouteScreen("/topics", topics: category.subtopics, title: category.title));
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
                  padding: EdgeInsets.all(convertWidthFrom360(context, 20)),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: convertWidthFrom360(context, 16),
            bottom: 0,
            child: Container(
              width: convertWidthFrom360(context, 76),
              height: convertHeightFrom360(context, 76, 104),
              alignment: Alignment.bottomRight,
              child: Image.network(category.imgPrev),
            ),
          ),
        ],
      ),
    );
  }
}
