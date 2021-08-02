import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magicards/services/models.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import 'package:provider/provider.dart';
import '../services/globals.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardsList extends StatefulWidget {
  const CardsList({
    Key key,
    @required this.cards,
  }) : super(key: key);

  final List<Magicard> cards;

  @override
  _CardsListState createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: convertWidthFrom360(context, 16)),
      child: ColumnBuilder(
          itemCount: widget.cards.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildCardsListItem(context, index);
          }),
    );
  }

  Widget _buildCardsListItem(BuildContext context, int index) {
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
        var learningState = Provider.of<LearningState>(context, listen: false);
        learningState.card = widget.cards[index];

        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 16,
              insetPadding: EdgeInsets.all(0.0),
              child: CardDetails(),
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
                      Text(widget.cards[index].title, style: myCardTitleStyle),
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

class CardDetails extends StatefulWidget {
  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  Magicard card;

  @override
  void initState() {
    super.initState();

    var learningState = Provider.of<LearningState>(context, listen: false);
    card = learningState.card;

    Globals.playPronounciation("http://magicards.ru/cards_sounds/" +
            card.subtopic.toString() +
            "/" +
            card.title +
            ".mp3" ??
        "");

  }

  @override
  Widget build(BuildContext context) {
    if (card != null) {
      int bigPhotoWidth = 1640;
      final mediaQuery = MediaQuery.of(context);

      if (mediaQuery.devicePixelRatio <= 2) {
        bigPhotoWidth = 820;
      }

      if (mediaQuery.devicePixelRatio > 2) {
        bigPhotoWidth = 1230;
      }

      if (mediaQuery.devicePixelRatio > 3) {
        bigPhotoWidth = 1640;
      }

      String pathPhoto = "http://magicards.ru/cards_photos/" +
          card.subtopic.toString() +
          "/" +
          bigPhotoWidth.toString() +
          "/" +
          card.number.toString() +
          ".jpg";

      return Container(
        width: convertWidthFrom360(context, 312),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title,
                    style: myH1Card,
                  ),
                  SizedBox(height: 10),
                  Text(
                    card.partOfSpeech,
                    style: myTranscription,
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Globals.playPronounciation(
                          "http://magicards.ru/cards_sounds/" +
                                  card.subtopic.toString() +
                                  "/" +
                                  card.title +
                                  ".mp3" ??
                              "");
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          '[' + card.transcriptionBr + ']',
                          style: myTranscription,
                        ),
                        SizedBox(width: 10),
                        ClipOval(
                          child: Container(
                            height: 30,
                            width: 30,
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SvgPicture.asset('assets/icons/sound.svg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  if (card.syn1 != '' || card.syn2 != '')
                    RichText(
                      text: TextSpan(
                        text: "also ",
                        style: myTranscription,
                        children: <TextSpan>[
                          TextSpan(
                              text: card.syn1,
                              style: TextStyle(color: Colors.black)),
                          if (card.syn1 != '' && card.syn2 != '')
                            TextSpan(
                                text: ", ",
                                style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: card.syn2,
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          height: convertHeightFrom360(context, 360, 190),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  convertHeightFrom360(context, 360, 16)),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: NetworkImage(pathPhoto),
                            ),
                            color: Colors.grey[200],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          card.titleRus,
                          style: myTitleRus,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  ButtonLearned(),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text("Слово не найдено"),
      );
    }
  }
}
