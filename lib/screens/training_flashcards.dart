import 'package:flutter/material.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import 'package:magicards/screens/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class TrainingFlashcards extends StatefulWidget {
  TrainingFlashcards({
    Key key,
    this.listOfCards,
    this.listLearnedCardsIDs,
    this.subtopicId,
    this.trainingVariant,
    this.mapSubtopicsProgress,
    this.numberOfCardsInSubtopic,
    this.showYouSignedInSnackBar,
    this.userInfo,
  }) : super(key: key);

  final List<Magicard> listOfCards;
  final List<String> listLearnedCardsIDs;
  final String subtopicId;
  final int trainingVariant;
  final Map<String, String> mapSubtopicsProgress;
  final int numberOfCardsInSubtopic;
  final bool showYouSignedInSnackBar;
  final Map<String, dynamic> userInfo;

  @override
  _TrainingFlashcardsState createState() => _TrainingFlashcardsState();
}

class _TrainingFlashcardsState extends State<TrainingFlashcards> {
  String _engVersion;

  @override
  void initState() {
    _engVersion = widget.userInfo["eng_version"];
    Globals.playPronounciation(widget.listOfCards[0].sound[_engVersion] ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    state.progress = (1 / widget.listOfCards.length);
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
            child: _buildCarousel(context, widget.trainingVariant),
          ),
        ],
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
        state.progress = ((idx + 1) / widget.listOfCards.length);
        Globals.playPronounciation(widget.listOfCards[idx].sound[_engVersion] ?? "");
      },
      itemBuilder: (BuildContext context, int itemIndex) {
        if (trainingVariant == 0) {
          return CarouselItemWordOpened(
            listOfCards: widget.listOfCards,
            listLearnedCardsIDs: widget.listLearnedCardsIDs,
            context: context,
            itemIndex: itemIndex,
            subtopicId: widget.subtopicId,
            mapSubtopicsProgress: widget.mapSubtopicsProgress,
            numberOfCardsInSubtopic: widget.numberOfCardsInSubtopic,
            engVersion: _engVersion,
          );
        } else {
          return CarouselItemPhotoOpened(
            listOfCards: widget.listOfCards,
            listLearnedCardsIDs: widget.listLearnedCardsIDs,
            context: context,
            itemIndex: itemIndex,
            subtopicId: widget.subtopicId,
            mapSubtopicsProgress: widget.mapSubtopicsProgress,
            numberOfCardsInSubtopic: widget.numberOfCardsInSubtopic,
            engVersion: _engVersion,
          );
        }
      },
      itemCount: widget.listOfCards.length,
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
    this.listLearnedCardsIDs,
    this.subtopicId,
    this.mapSubtopicsProgress,
    this.numberOfCardsInSubtopic, this.engVersion,
  }) : super(key: key);

  final List<Magicard> listOfCards;
  final List<String> listLearnedCardsIDs;
  final String subtopicId;
  final BuildContext context;
  final int itemIndex;
  final Map<String, String> mapSubtopicsProgress;
  final int numberOfCardsInSubtopic;
  final String engVersion;

  @override
  Widget build(BuildContext context) {
    var trainingState = Provider.of<TrainingFlashcardsState>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    print(engVersion);

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
                          capitalize(listOfCards[itemIndex].title),
                          style: myH1Card,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: GestureDetector(
                          onTap: () {
                            Globals.playPronounciation(
                                listOfCards[itemIndex].sound[engVersion] ??
                                    "");
                          },
                          child: Row(
                            children: <Widget>[
                              Text(
                                '[' +
                                    listOfCards[itemIndex].transcription +
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
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          capitalize(listOfCards[itemIndex].titleRus),
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: user != null
                        ? ButtonLearned(
                            context: context,
                            heroTag: listOfCards[itemIndex].title,
                            cardId: listOfCards[itemIndex].id,
                            listLearnedCardsIDs: listLearnedCardsIDs,
                            subtopicId: subtopicId,
                            learned: false,
                            mapSubtopicsProgress: mapSubtopicsProgress,
                            numberOfCardsInSubtopic: numberOfCardsInSubtopic,
                          )
                        : SignInBlock('signIn' + listOfCards[itemIndex].title,
                            "training"),
                  ),
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
    this.listLearnedCardsIDs,
    this.subtopicId,
    this.mapSubtopicsProgress,
    this.numberOfCardsInSubtopic, this.engVersion,
  }) : super(key: key);

  final List<Magicard> listOfCards;
  final List<String> listLearnedCardsIDs;
  final String subtopicId;
  final BuildContext context;
  final int itemIndex;
  final Map<String, String> mapSubtopicsProgress;
  final int numberOfCardsInSubtopic;
  final String engVersion;

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
  void initState() {
    super.initState();
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
                                    capitalize(widget
                                        .listOfCards[widget.itemIndex].titleRus),
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
                                capitalize(widget.listOfCards[widget.itemIndex].title),
                                style: myH1Card,
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Globals.playPronounciation(widget
                                          .listOfCards[widget.itemIndex]
                                          .sound[widget.engVersion] ??
                                      "");
                                },
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 65),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: user != null
                        ? ButtonLearned(
                            context: context,
                            heroTag: widget.listOfCards[widget.itemIndex].title,
                            listLearnedCardsIDs: widget.listLearnedCardsIDs,
                            cardId: widget.listOfCards[widget.itemIndex].id,
                            subtopicId: widget.subtopicId,
                            learned: false,
                            mapSubtopicsProgress: widget.mapSubtopicsProgress,
                            numberOfCardsInSubtopic:
                                widget.numberOfCardsInSubtopic,
                          )
                        : SignInBlock(
                            'signIn' +
                                widget.listOfCards[widget.itemIndex].title,
                            "training"),
                  ),
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
    this.listLearnedCardsIDs,
    this.subtopicId,
    this.cardId,
    this.learned,
    this.mapSubtopicsProgress,
    this.numberOfCardsInSubtopic,
  }) : super(key: key);

  final String heroTag;
  final BuildContext context;
  final List<String> listLearnedCardsIDs;
  final Map<String, String> mapSubtopicsProgress;
  final String subtopicId;
  final String cardId;
  final bool learned;
  final int numberOfCardsInSubtopic;

  @override
  _ButtonLearnedState createState() => _ButtonLearnedState();
}

class _ButtonLearnedState extends State<ButtonLearned> {
  bool _learned = false;

  @override
  void initState() {
    super.initState();
    _learned = widget.learned;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user =
        Provider.of<FirebaseUser>(widget.context, listen: false);

    return Container(
      height: 48,
      child: _learned == false
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.mainBrightColor, width: 1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: FloatingActionButton.extended(
                heroTag: widget.heroTag,
                onPressed: () {
                  widget.listLearnedCardsIDs.add(widget.cardId);

                  double _newProgress = widget.listLearnedCardsIDs.length /
                      widget.numberOfCardsInSubtopic;
                  widget.mapSubtopicsProgress.update(
                      widget.subtopicId, (value) => (_newProgress).toString(),
                      ifAbsent: () => (_newProgress).toString());

                  DB.updateArrayOfLearnedCards(
                      userId: user.uid,
                      subtopicId: widget.subtopicId,
                      learnedCardsIDs: widget.listLearnedCardsIDs);

                  DB.updateSubtopicsProgress(
                    user.uid,
                    widget.mapSubtopicsProgress,
                  );

                  setState(() {
                    _learned = true;
                  });
                },
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    'Изучено',
                    style: TextStyle(color: MyColors.mainBrightColor),
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
              ),
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
                      child: GestureDetector(
                        onTap: () {
                          widget.listLearnedCardsIDs.remove(widget.cardId);

                          double _newProgress =
                              widget.listLearnedCardsIDs.length /
                                  widget.numberOfCardsInSubtopic;
                          widget.mapSubtopicsProgress.update(widget.subtopicId,
                              (value) => (_newProgress).toString(),
                              ifAbsent: () => (_newProgress).toString());

                          DB.updateArrayOfLearnedCards(
                              userId: user.uid,
                              subtopicId: widget.subtopicId,
                              learnedCardsIDs: widget.listLearnedCardsIDs);

                          DB.updateSubtopicsProgress(
                            user.uid,
                            widget.mapSubtopicsProgress,
                          );

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
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class SignInBlock extends StatelessWidget {
  const SignInBlock(this.heroTag, this.nextPage, {Key key}) : super(key: key);

  final String heroTag;
  final String nextPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 260,
            child: Text(
              'Войдите, чтобы отмечать слова изученными. Это займет 1 минуту',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.mainBrightColor, width: 1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: FloatingActionButton.extended(
              heroTag: heroTag,
              onPressed: () {
                Navigator.of(context).push(_createRouteToSignIn(nextPage));
              },
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Войти',
                  style: TextStyle(color: MyColors.mainBrightColor),
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRouteToSignIn(String nextPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        LoginPage(prevPage: nextPage),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
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
