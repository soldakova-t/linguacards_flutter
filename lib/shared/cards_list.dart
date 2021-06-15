import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magicards/services/models.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import 'package:provider/provider.dart';
import '../services/globals.dart';

class CardsList extends StatefulWidget {
  const CardsList({
    Key key,
    @required this.cards,
    this.learned = false,
  }) : super(key: key);

  final List<Magicard> cards;
  final bool learned;

  @override
  _CardsListState createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: convertWidthFrom360(context, 16)),
      child: ColumnBuilder(
          itemCount: widget.cards.length,
          itemBuilder: (BuildContext context, int index) {
            if (user != null) {
              return _buildCardsListItem(context, index, widget.learned);
            } else {
              return _buildCardsListItem(context, index, widget.learned);
            }
          }),
    );
  }

  Widget _buildCardsListItem(BuildContext context, int index, bool learned) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(createRouteScreen("/"));
      },
      child: SizedBox(
        width: double.infinity,
        height: convertHeightFrom360(context, 360, 59),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(right: convertWidthFrom360(context, 16)),
                  child: Container(
                    width: convertWidthFrom360(context, 70),
                    height: convertHeightFrom360(context, 360, 46),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(convertHeightFrom360(context, 360, 16)),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage("http://magicards.ru/photo/2020/10/352/" + widget.cards[index].number.toString() + ".jpg"),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      learned == false
                          ? Text(widget.cards[index].title,
                              style: myCardTitleStyle)
                          : Text(widget.cards[index].title,
                              style: myCardTitleStyle),
                      SizedBox(height: convertHeightFrom360(context, 360, 3)),
                      Text(widget.cards[index].titleRus,
                          style: mySubtitleStyle),
                    ],
                  ),
                ),
                Container(
                  width: convertWidthFrom360(context, 100),
                  alignment: Alignment.centerRight,
                  child:
                      Text(widget.cards[index].level, style: mySubtitleStyle),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: convertWidthFrom360(context, 76)),
              child: Container(
                height: 1,
                color: hexToColor("#E8EAEB"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
