import 'package:flutter/material.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class TrainingFlashcards extends StatelessWidget {
  TrainingFlashcards({
    Key key,
    this.listOfCards,
    this.listOfLearnedCards,
    this.subtopicId,
    this.trainingVariant,
  }) : super(key: key);

  final List<Magicard> listOfCards;
  final List<String> listOfLearnedCards;
  final String subtopicId;
  final int trainingVariant;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var state =
            Provider.of<TrainingFlashcardsState>(context, listen: false);
        state.progress = (1 / listOfCards.length);

        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.grey[100],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 25.0,
                  top: 29.0 + MediaQuery.of(context).padding.top - 12.0,
                  right: 10.0,
                  bottom: 29.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      right: 12,
                    ),
                    width: MediaQuery.of(context).size.width - 83.0,
                    child: Consumer<TrainingFlashcardsState>(
                      builder: (context, state, child) => AnimatedProgress(
                        value: state.progress,
                        height: 5.0,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      var state = Provider.of<TrainingFlashcardsState>(context,
                          listen: false);
                      state.progress = (1 / listOfCards.length);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 60.0 + MediaQuery.of(context).padding.top, bottom: 20.0),
              child: _buildCarousel(context, trainingVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, int trainingVariant) {
    var state = Provider.of<TrainingFlashcardsState>(context);

    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: state.controller,
      onPageChanged: (int idx) {
        state.progress = ((idx + 1) / listOfCards.length);
      },
      itemBuilder: (BuildContext context, int itemIndex) {
        if (trainingVariant == 0) {
          return CarouselItemWordOpened(
            listOfCards: listOfCards,
            listOfLearnedCards: listOfLearnedCards,
            context: context,
            itemIndex: itemIndex,
            subtopicId: subtopicId,
          );
        } else {
          return CarouselItemPhotoOpened(
            listOfCards: listOfCards,
            listOfLearnedCards: listOfLearnedCards,
            context: context,
            itemIndex: itemIndex,
            subtopicId: subtopicId,
          );
        }
      },
      itemCount: listOfCards.length,
    );
  }
}

// Two layouts for different types of training.

class CarouselItemWordOpened extends StatelessWidget {
  const CarouselItemWordOpened({
    Key key,
    @required this.listOfCards,
    @required this.context,
    @required this.itemIndex,
    this.listOfLearnedCards,
    this.subtopicId,
  }) : super(key: key);

  final List<Magicard> listOfCards;
  final List<String> listOfLearnedCards;
  final String subtopicId;
  final BuildContext context;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    var trainingState = Provider.of<TrainingFlashcardsState>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return Padding(
      padding: EdgeInsets.only(left: 4.0, top: 10.0, right: 4.0, bottom: 10.0),
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx < 0) {
            trainingState.nextPage();
          }
          if (details.delta.dx > 0) {
            trainingState.prevPage();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Stack(children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 30),
                        child: Text(
                          listOfCards[itemIndex].title,
                          style: myH1Card,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '[' + listOfCards[itemIndex].transcription + ']',
                              style: myTranscriptionCard,
                            ),
                            SizedBox(width: 10),
                            ClipOval(
                              child: Container(
                                height: 30,
                                width: 30,
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: SvgPicture.asset(
                                      'assets/icons/sound.svg'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          listOfCards[itemIndex].titleRus,
                          style: myLabelTextStyleCard,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            child: Container(
                                width: double.infinity,
                                child: Image.network(
                                  listOfCards[itemIndex].photo,
                                  fit: listOfCards[itemIndex].whiteBg == '1'
                                      ? BoxFit.contain
                                      : BoxFit.cover,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 110),
                    ],
                  ),
                  user != null
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: ButtonLearned(
                            context: context,
                            heroTag: listOfCards[itemIndex].title,
                            cardId: listOfCards[itemIndex].id,
                            listOfLearnedCards: listOfLearnedCards,
                            subtopicId: subtopicId,
                          ),
                        )
                      : Container(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: ContainerShowMeaning(
                    trainingVariant: 0, notifyParent: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarouselItemPhotoOpened extends StatefulWidget {
  const CarouselItemPhotoOpened({
    Key key,
    @required this.listOfCards,
    @required this.context,
    @required this.itemIndex,
    this.listOfLearnedCards,
    this.subtopicId,
  }) : super(key: key);

  final List<Magicard> listOfCards;
  final List<String> listOfLearnedCards;
  final String subtopicId;
  final BuildContext context;
  final int itemIndex;

  @override
  _CarouselItemPhotoOpenedState createState() =>
      _CarouselItemPhotoOpenedState();
}

class _CarouselItemPhotoOpenedState extends State<CarouselItemPhotoOpened> {
  Color _titleRusBg = Colors.grey[100];

  changeTitleRusBg() {
    setState(() {
      _titleRusBg = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    var trainingState = Provider.of<TrainingFlashcardsState>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return Padding(
      padding: EdgeInsets.only(left: 4.0, top: 10.0, right: 4.0, bottom: 10.0),
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx < 0) {
            trainingState.nextPage();
          }
          if (details.delta.dx > 0) {
            trainingState.prevPage();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 0.0,
                    top: widget.listOfCards[widget.itemIndex].whiteBg == '1'
                        ? 20.0
                        : 0.0,
                    right: 0.0,
                    bottom: 20.0),
                child: Stack(children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height:
                            widget.listOfCards[widget.itemIndex].whiteBg == '1'
                                ? 260
                                : 280,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35.0),
                                  topRight: Radius.circular(35.0)),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Image.network(
                                  widget.listOfCards[widget.itemIndex].photo,
                                  height: widget.listOfCards[widget.itemIndex]
                                              .whiteBg ==
                                          '1'
                                      ? 210
                                      : 280,
                                  width: double.infinity,
                                  fit: widget.listOfCards[widget.itemIndex]
                                              .whiteBg ==
                                          '1'
                                      ? BoxFit.contain
                                      : BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _titleRusBg,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0,
                                      top: 6.0,
                                      right: 50.0,
                                      bottom: 6.0),
                                  child: Text(
                                    widget
                                        .listOfCards[widget.itemIndex].titleRus,
                                    style: myLabelTextStyleCard,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 13),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.listOfCards[widget.itemIndex].title,
                                style: myH1Card,
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '[' +
                                        widget.listOfCards[widget.itemIndex]
                                            .transcription +
                                        ']',
                                    style: myTranscriptionCard,
                                  ),
                                  SizedBox(width: 10),
                                  ClipOval(
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: SvgPicture.asset(
                                            'assets/icons/sound.svg'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 65),
                    ],
                  ),
                  user != null
                      ? Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonLearned(
                      context: context,
                      heroTag: widget.listOfCards[widget.itemIndex].title,
                      listOfLearnedCards: widget.listOfLearnedCards,
                      cardId: widget.listOfCards[widget.itemIndex].id,
                      subtopicId: widget.subtopicId,
                    ),
                  ) : Container(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 280.0),
                child: ContainerShowMeaning(
                    trainingVariant: 1, notifyParent: changeTitleRusBg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonLearned extends StatefulWidget {
  const ButtonLearned({
    Key key,
    this.heroTag,
    this.context,
    this.listOfLearnedCards,
    this.subtopicId,
    this.cardId,
  }) : super(key: key);

  final String heroTag;
  final BuildContext context;
  final List<String> listOfLearnedCards;
  final String subtopicId;
  final String cardId;

  @override
  _ButtonLearnedState createState() => _ButtonLearnedState();
}

class _ButtonLearnedState extends State<ButtonLearned> {
  bool _learned = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: _learned == false
          ? FloatingActionButton.extended(
              heroTag: widget.heroTag,
              onPressed: () {
                FirebaseUser user =
                    Provider.of<FirebaseUser>(widget.context, listen: false);
                widget.listOfLearnedCards.add(widget.cardId);

                DB.updateArrayOfLearnedCards(
                    userId: user.uid,
                    subtopicId: widget.subtopicId,
                    learnedCards: widget.listOfLearnedCards);

                setState(() {
                  _learned = true;
                });
              },
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Изучено',
                  style: myMainTextStyle,
                ),
              ),
              backgroundColor: Colors.grey[200],
              elevation: 1.0,
            )
          : Container(
              height: 48,
              alignment: Alignment.center,
              child: SizedBox(
                width: 180,
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.green[600],
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Изучено',
                      style: TextStyle(
                        color: Colors.green[600],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _learned = false;
                        });
                      },
                      child: Text(
                        'Вернуть',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF878787),
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ContainerShowMeaning extends StatefulWidget {
  ContainerShowMeaning({
    Key key,
    this.trainingVariant,
    @required this.notifyParent,
  }) : super(key: key);

  final int trainingVariant;
  final Function() notifyParent;

  @override
  _ContainerShowMeaningState createState() => _ContainerShowMeaningState();
}

class _ContainerShowMeaningState extends State<ContainerShowMeaning>
    with AutomaticKeepAliveClientMixin<ContainerShowMeaning> {
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.notifyParent();
        setState(() {
          _show = false;
        });
      },
      child: _show == false
          ? Container()
          : Container(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0)),
                  color: Colors.grey[100],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset('assets/icons/eye.svg'),
                    Text(
                      widget.trainingVariant == 0
                          ? 'Показать изображение'
                          : 'Показать английское слово',
                      style: TextStyle(
                        color: hexToColor('#979797'),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
