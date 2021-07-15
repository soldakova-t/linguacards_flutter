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
    User user = Provider.of<User>(context);

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
    int smallPhotoWidth = 352;
    final mediaQuery = MediaQuery.of(context);

    if (mediaQuery.devicePixelRatio <= 2) {
      smallPhotoWidth = 176;
    }

    if (mediaQuery.devicePixelRatio > 2) {
      smallPhotoWidth = 264;
    }

    if (mediaQuery.devicePixelRatio > 3) {
      smallPhotoWidth = 352;
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              elevation: 16,
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(height: 20),
                    CardDetails(card: widget.cards[index]),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
      behavior: HitTestBehavior.opaque,
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
                        image: NetworkImage(
                            "http://magicards.ru/cards_photos/" +
                                widget.cards[index].subtopic.toString() +
                                "/" +
                                smallPhotoWidth.toString() +
                                "/" +
                                widget.cards[index].number.toString() +
                                ".jpg"),
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
                      SizedBox(height: convertHeightFrom360(context, 360, 6)),
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

class CardDetails extends StatelessWidget {
  const CardDetails({Key key, this.card}) : super(key: key);
  final Magicard card;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.green[100],
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(card.title),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
