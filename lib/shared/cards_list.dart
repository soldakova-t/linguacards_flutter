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
    this.learned = false,
    this.listLearnedCardsIDs,
    this.topicId,
    this.mapSubtopicsProgress,
    this.numberOfCardsInSubtopic,
  }) : super(key: key);

  final List<Magicard> cards;
  final bool learned;
  final List<String>
      listLearnedCardsIDs; // For updating when more cards are learned.
  final String topicId; // For updating when more cards are learned.
  final Map<String, String>
      mapSubtopicsProgress; // For updating when more cards are learned.
  final int
      numberOfCardsInSubtopic; // For updating when more cards are learned.

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
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 16,
              insetPadding: EdgeInsets.all(0.0),
              child: CardDetails(
                card: widget.cards[index],
                listLearnedCardsIDs: widget.listLearnedCardsIDs,
                topicId: widget.topicId,
                mapSubtopicsProgress: widget.mapSubtopicsProgress,
                numberOfCardsInSubtopic: widget.numberOfCardsInSubtopic,
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

class CardDetails extends StatefulWidget {
  const CardDetails(
      {Key key,
      this.card,
      this.listLearnedCardsIDs,
      this.topicId,
      this.mapSubtopicsProgress,
      this.numberOfCardsInSubtopic})
      : super(key: key);

  final Magicard card;
  final List<String>
      listLearnedCardsIDs; // For updating when more cards are learned.
  final String topicId; // For updating when more cards are learned.
  final Map<String, String>
      mapSubtopicsProgress; // For updating when more cards are learned.
  final int
      numberOfCardsInSubtopic; // For updating when more cards are learned.

  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  @override
  Widget build(BuildContext context) {
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
        widget.card.subtopic.toString() +
        "/" +
        bigPhotoWidth.toString() +
        "/" +
        widget.card.number.toString() +
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
                  widget.card.title,
                  style: myH1Card,
                ),
                SizedBox(height: 10),
                Text(
                  widget.card.partOfSpeech,
                  style: myTranscription,
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Globals.playPronounciation(
                        "http://magicards.ru/cards_sounds/" +
                                widget.card.subtopic.toString() +
                                "/" +
                                widget.card.title +
                                ".mp3" ??
                            "");
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        '[' + widget.card.transcriptionBr + ']',
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
                if (widget.card.syn1 != '' || widget.card.syn2 != '')
                  RichText(
                    text: TextSpan(
                      text: "also ",
                      style: myTranscription,
                      children: <TextSpan>[
                        TextSpan(
                            text: widget.card.syn1,
                            style: TextStyle(color: Colors.black)),
                        if (widget.card.syn1 != '' && widget.card.syn2 != '')
                          TextSpan(
                              text: ", ",
                              style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: widget.card.syn2,
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
                        widget.card.titleRus,
                        style: myTitleRus,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ButtonLearned(
                  context: context,
                  heroTag: widget.card.title,
                  cardId: widget.card.id,
                  listLearnedCardsIDs: widget.listLearnedCardsIDs,
                  topicId: widget.topicId,
                  learned: widget.listLearnedCardsIDs.contains(widget.card.id),
                  mapSubtopicsProgress: widget.mapSubtopicsProgress,
                  numberOfCardsInSubtopic: widget.numberOfCardsInSubtopic,
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
