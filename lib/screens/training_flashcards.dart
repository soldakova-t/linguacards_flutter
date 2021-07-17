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
    this.trainingVariant,
    this.listOfCards,
    this.listLearnedCardsIDs,
    this.topicId,
    this.mapSubtopicsProgress = const {"": ""},
    this.numberOfCardsInSubtopic,
  }) : super(key: key);

  final int trainingVariant;
  final List<Magicard> listOfCards;
  final List<String>
      listLearnedCardsIDs; // For updating when more cards are learned.
  final String topicId; // For updating when more cards are learned.
  final Map<String, String>
      mapSubtopicsProgress; // For updating when more cards are learned.
  final int
      numberOfCardsInSubtopic; // For updating when more cards are learned.

  @override
  _TrainingFlashcardsState createState() => _TrainingFlashcardsState();
}

class _TrainingFlashcardsState extends State<TrainingFlashcards> {
  String _engVersion = "br";

  @override
  void initState() {
    //if (widget.userInfo != null) _engVersion = widget.userInfo["eng_version"];
    Globals.playPronounciation("http://magicards.ru/cards_sounds/" +
            widget.listOfCards[0].subtopic.toString() +
            "/" +
            widget.listOfCards[0].title +
            ".mp3" ??
        "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainBgColor,
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 16.0,
            top: 30 + MediaQuery.of(context).padding.top,
            right: 10.0,
            height: 49,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  top: 24,
                  child: Consumer<TrainingFlashcardsState>(
                    builder: (context, state, child) => Row(
                      children: [
                        Container(
                          width: 84.0,
                          child: AnimatedProgress(
                            value: state.progress,
                            height: 5.0,
                          ),
                        ),
                        SizedBox(width: convertWidthFrom360(context, 18)),
                        Container(
                          child: Text(
                            state.currentCardNumber.toString() +
                                " из " +
                                widget.listOfCards.length.toString(),
                            style: myProgress,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      var state = Provider.of<TrainingFlashcardsState>(context,
                          listen: false);
                      state.progress = (1 / widget.listOfCards.length);
                      state.currentCardNumber = 1;
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 103 + MediaQuery.of(context).padding.top,
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
      controller:
          state.controller, // Here we can change left and right paddings.
      onPageChanged: (int idx) {
        Globals.playPronounciation("http://magicards.ru/cards_sounds/" +
                widget.listOfCards[idx].subtopic.toString() +
                "/" +
                widget.listOfCards[idx].title +
                ".mp3" ??
            "");
      },
      itemBuilder: (BuildContext context, int itemIndex) {
        if (trainingVariant == 0) {
          return CarouselItemWordOpened(
            listOfCards: widget.listOfCards,
            listLearnedCardsIDs: widget.listLearnedCardsIDs,
            topicId: widget.topicId,
            context: context,
            itemIndex: itemIndex,
            engVersion: _engVersion,
            mapSubtopicsProgress: widget.mapSubtopicsProgress,
            numberOfCardsInSubtopic: widget.numberOfCardsInSubtopic,
          );
        } else
          return Container();
      },
      itemCount: widget.listOfCards.length,
    );
  }
}

class CarouselItemWordOpened extends StatefulWidget {
  const CarouselItemWordOpened({
    Key key,
    @required this.listOfCards,
    @required this.context,
    @required this.itemIndex,
    this.listLearnedCardsIDs,
    this.topicId,
    this.mapSubtopicsProgress,
    this.numberOfCardsInSubtopic,
    this.engVersion,
  }) : super(key: key);

  final List<Magicard> listOfCards;
  final List<String> listLearnedCardsIDs;
  final String topicId;
  final BuildContext context;
  final int itemIndex;
  final Map<String, String> mapSubtopicsProgress;
  final int numberOfCardsInSubtopic;
  final String engVersion;

  @override
  _CarouselItemWordOpenedState createState() => _CarouselItemWordOpenedState();
}

class _CarouselItemWordOpenedState extends State<CarouselItemWordOpened> {
  bool _showMeaningAndActions = false;

  static void preload(BuildContext context, String path) {
    var configuration = createLocalImageConfiguration(context);
    new NetworkImage(path)..resolve(configuration);
  }

  @override
  Widget build(BuildContext context) {
    var trainingState =
        Provider.of<TrainingFlashcardsState>(context, listen: false);

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
        widget.listOfCards[widget.itemIndex].subtopic.toString() +
        "/" +
        bigPhotoWidth.toString() +
        "/" +
        widget.listOfCards[widget.itemIndex].number.toString() +
        ".jpg";

    preload(context, pathPhoto);

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx < 0 &&
            (widget.itemIndex + 1) < widget.listOfCards.length) {
          trainingState.progress =
              (widget.itemIndex + 2) / widget.listOfCards.length;
          trainingState.currentCardNumber = widget.itemIndex + 2;
          trainingState.nextPage();
        }
        if (details.delta.dx > 0 && widget.itemIndex > 0) {
          trainingState.progress = widget.itemIndex / widget.listOfCards.length;
          trainingState.currentCardNumber = widget.itemIndex;
          trainingState.prevPage();
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.mainBgColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Вспомните, что означает это слово:"),
                SizedBox(height: 30),
                Text(
                  widget.listOfCards[widget.itemIndex].title,
                  style: myH1Card,
                ),
                SizedBox(height: 10),
                Text(
                  widget.listOfCards[widget.itemIndex].partOfSpeech,
                  style: myTranscription,
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Globals.playPronounciation(
                        "http://magicards.ru/cards_sounds/" +
                                widget.listOfCards[widget.itemIndex].subtopic
                                    .toString() +
                                "/" +
                                widget.listOfCards[widget.itemIndex].title +
                                ".mp3" ??
                            "");
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        '[' +
                            widget
                                .listOfCards[widget.itemIndex].transcriptionBr +
                            ']',
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
                if (_showMeaningAndActions == true &&
                    (widget.listOfCards[widget.itemIndex].syn1 != '' ||
                        widget.listOfCards[widget.itemIndex].syn2 != ''))
                  RichText(
                    text: TextSpan(
                      text: "also ",
                      style: myTranscription,
                      children: <TextSpan>[
                        TextSpan(
                            text: widget.listOfCards[widget.itemIndex].syn1,
                            style: TextStyle(color: Colors.black)),
                        if (widget.listOfCards[widget.itemIndex].syn1 != '' &&
                            widget.listOfCards[widget.itemIndex].syn2 != '')
                          TextSpan(
                              text: ", ",
                              style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: widget.listOfCards[widget.itemIndex].syn2,
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                SizedBox(height: 40),
                if (_showMeaningAndActions == true)
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: convertHeightFrom360(context, 360, 215),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    convertHeightFrom360(context, 360, 16)),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(pathPhoto),
                              ),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.listOfCards[widget.itemIndex].titleRus,
                            style: myTitleRus,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _showMeaningAndActions == true
                ? Column(
                    children: [
                      ButtonLearned(
                        context: context,
                        heroTag: widget.listOfCards[widget.itemIndex].title,
                        cardId: widget.listOfCards[widget.itemIndex].id,
                        listLearnedCardsIDs: widget.listLearnedCardsIDs,
                        topicId: widget.topicId,
                        learned: false,
                        mapSubtopicsProgress: widget.mapSubtopicsProgress,
                        numberOfCardsInSubtopic: widget.numberOfCardsInSubtopic,
                      ),
                      SizedBox(height: 16),
                      (widget.itemIndex < (widget.listOfCards.length - 1))
                          ? _buildButtonNext()
                          : _buildButtonFinish(),
                    ],
                  )
                : _buildButtonCheck(),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonCheck() {
    return Container(
      height: convertHeightFrom360(widget.context, 360, 46),
      child: ElevatedButton(
          style: myPrimaryButtonStyle,
          child:
              Center(child: Text("Проверить", style: myPrimaryButtonTextStyle)),
          onPressed: () {
            setState(() {
              _showMeaningAndActions = true;
            });
          }),
    );
  }

  Widget _buildButtonNext() {
    return Container(
      height: convertHeightFrom360(widget.context, 360, 46),
      child: ElevatedButton(
          style: myPrimaryButtonStyle,
          child: Center(child: Text("Далее", style: myPrimaryButtonTextStyle)),
          onPressed: () {
            var state = Provider.of<TrainingFlashcardsState>(widget.context,
                listen: false);
            state.progress = (widget.itemIndex + 2) / widget.listOfCards.length;
            state.currentCardNumber = widget.itemIndex + 2;
            state.nextPage();
          }),
    );
  }

  Widget _buildButtonFinish() {
    return Container(
      height: convertHeightFrom360(widget.context, 360, 46),
      child: ElevatedButton(
          style: myPrimaryButtonStyle,
          child:
              Center(child: Text("Завершить", style: myPrimaryButtonTextStyle)),
          onPressed: () {
            var state =
                Provider.of<TrainingFlashcardsState>(context, listen: false);
            state.progress = (1 / widget.listOfCards.length);
            Navigator.of(context).pop();
          }),
    );
  }
}

/*class ButtonLearned extends StatefulWidget {
  const ButtonLearned({
    Key key,
    this.heroTag,
    this.context,
    this.listLearnedCardsIDs,
    this.topicId,
    this.cardId,
    this.learned,
    this.mapSubtopicsProgress,
    this.numberOfCardsInSubtopic,
  }) : super(key: key);

  final String heroTag;
  final BuildContext context;
  final List<String> listLearnedCardsIDs;
  final Map<String, String> mapSubtopicsProgress;
  final String topicId;
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
    User user = Provider.of<User>(widget.context, listen: false);

    return Container(
      height: convertHeightFrom360(context, 360, 46),
      child: _learned == false
          ? ElevatedButton(
              style: mySecondaryButtonStyle,
              child: Center(
                  child: Text("Отметить изученным",
                      style: mySecondaryButtonTextStyle)),
              onPressed: () {
                widget.listLearnedCardsIDs.add(widget.cardId);

                DB.updateArrayOfLearnedCards(
                    userId: user.uid,
                    subtopicId: widget.topicId,
                    learnedCardsIDs: widget.listLearnedCardsIDs);

                double _newProgress = widget.listLearnedCardsIDs.length /
                    widget.numberOfCardsInSubtopic;
                widget.mapSubtopicsProgress.update(
                    widget.topicId, (value) => (_newProgress).toString(),
                    ifAbsent: () => (_newProgress).toString());

                DB.updateSubtopicsProgress(
                  user.uid,
                  widget.mapSubtopicsProgress,
                );

                setState(() {
                  _learned = true;
                });
              })
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
                      "Изучено",
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

                          DB.updateArrayOfLearnedCards(
                              userId: user.uid,
                              subtopicId: widget.topicId,
                              learnedCardsIDs: widget.listLearnedCardsIDs);

                          double _newProgress =
                              widget.listLearnedCardsIDs.length /
                                  widget.numberOfCardsInSubtopic;
                          widget.mapSubtopicsProgress.update(widget.topicId,
                              (value) => (_newProgress).toString(),
                              ifAbsent: () => (_newProgress).toString());

                          DB.updateSubtopicsProgress(
                            user.uid,
                            widget.mapSubtopicsProgress,
                          );

                          setState(() {
                            _learned = false;
                          });
                        },
                        child: Text(
                          "Вернуть",
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
              'Войдите, чтобы отмечать слова изученными',
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
}*/
