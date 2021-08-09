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

    String cardCategory = widget.cards[index].subtopic.split(" ")[0];
    String cardSuptopicName = widget.cards[index].subtopic.split(" ")[1];
    String cardPhotoPath = "http://lingvicards.ru/cards_photos/" +
        cardCategory +
        "/" +
        cardSuptopicName +
        "/" +
        smallPhotoWidth.toString() +
        "/" +
        widget.cards[index].number +
        ".jpg";

    return GestureDetector(
      onTap: () {
        var learningState = Provider.of<LearningState>(context, listen: false);
        learningState.card = widget.cards[index];

        showDialog(
          context: context,
          builder: (context) {
            return NetworkSensitive(
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 16,
                insetPadding: EdgeInsets.all(0.0),
                child: CardDetails(),
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
                        image: NetworkImage(cardPhotoPath),
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
                // Level
                /*Container(
                  width: convertWidthFrom360(context, 100),
                  alignment: Alignment.centerRight,
                  child:
                      Text(widget.cards[index].level, style: mySubtitleStyle),
                )*/
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

    String cardCategory = card.subtopic.split(" ")[0];
    String cardSuptopicName = card.subtopic.split(" ")[1];
    String cardSoundPath = "http://lingvicards.ru/cards_sounds/" +
        cardCategory +
        "/" +
        cardSuptopicName +
        "/" +
        card.title +
        ".mp3";

    Globals.playPronounciation(cardSoundPath ?? "");
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

      String cardCategory = card.subtopic.split(" ")[0];
      String cardSuptopicName = card.subtopic.split(" ")[1];
      String cardPhotoPath = "http://lingvicards.ru/cards_photos/" +
          cardCategory +
          "/" +
          cardSuptopicName +
          "/" +
          bigPhotoWidth.toString() +
          "/" +
          card.number +
          ".jpg";

      String cardSoundPath = "http://lingvicards.ru/cards_sounds/" +
          cardCategory +
          "/" +
          cardSuptopicName +
          "/" +
          card.title +
          ".mp3";

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
                  _buildCloseButton(context),
                  Text(
                    card.title,
                    style: myH1Card,
                  ),
                  SizedBox(height: 10),
                  Text(
                    Strings.getPartOfSpeech(card.partOfSpeech),
                    style: myPartOfSpeech,
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Globals.playPronounciation(cardSoundPath ?? "");
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
                    child: Container(
                      height: convertHeightFrom360(context, 360, 190),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                              convertHeightFrom360(context, 360, 16)),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: NetworkImage(cardPhotoPath),
                        ),
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Text("Перевод", style: myTranscription),
                  SizedBox(height: 3),
                  Text(capitalize(card.titleRus), style: myTitleRus),
                  card.example1 != ''
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 18),
                            Text("Пример", style: myTranscription),
                            SizedBox(height: 3),
                            Text(card.example1, style: myTitleRus),
                          ],
                        )
                      : Container(),
                  /*RichText(
                    text: TextSpan(
                      text: "Перевод ",
                      style: myTranscription,
                      children: <TextSpan>[
                        TextSpan(
                          text: card.titleRus,
                          style: myTitleRus,
                        ),
                      ],
                    ),
                  ),
                  card.example1 != '' ? RichText(
                    text: TextSpan(
                      text: "Пример: ",
                      style: myTitleRus,
                      children: <TextSpan>[
                        TextSpan(
                          text: card.example1,
                          style: myTitleRus,
                        ),
                      ],
                    ),
                  ) : Container(),*/
                  SizedBox(height: 45),
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

  Widget _buildCloseButton(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(Icons.close),
        ),
      ),
    );
  }
}
