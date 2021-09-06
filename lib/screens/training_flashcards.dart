import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import '../screens/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class TrainingFlashcards extends StatefulWidget {
  final List<Magicard> cards;

  const TrainingFlashcards(this.cards, {Key key}) : super(key: key);

  @override
  _TrainingFlashcardsState createState() => _TrainingFlashcardsState();
}

class _TrainingFlashcardsState extends State<TrainingFlashcards> {
  int trainingVariant = 0;
  var learningState;

  @override
  void initState() {
    super.initState();

    learningState = Provider.of<LearningState>(context, listen: false);

    Magicard card = widget.cards[0];
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
    return FutureBuilder<bool>(
      future: FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return NetworkSensitive(
            child: Scaffold(
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
                          child: Consumer<TrainingState>(
                            builder: (context, trainingState, child) => Row(
                              children: [
                                Container(
                                  width: 84.0,
                                  child: AnimatedProgress(
                                    value: trainingState.trainingProgress,
                                    height: 5.0,
                                  ),
                                ),
                                SizedBox(
                                    width: convertWidthFrom360(context, 18)),
                                Container(
                                  child: Text(
                                    trainingState.currentCardNumber.toString() +
                                        " из " +
                                        widget.cards.length.toString(),
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
                              var trainingState = Provider.of<TrainingState>(
                                  context,
                                  listen: false);
                              trainingState.trainingProgress =
                                  (1 / widget.cards.length);
                              trainingState.currentCardNumber = 1;
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
                    child: _buildCarousel(context, trainingVariant),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildCarousel(BuildContext context, int trainingVariant) {
    var trainingState = Provider.of<TrainingState>(context);

    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: trainingState
          .controller, // Here we can change left and right paddings.
      onPageChanged: (int idx) {
        Magicard card = widget.cards[idx];
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
      },
      itemBuilder: (BuildContext context, int itemIndex) {
        if (trainingVariant == 0) {
          return CarouselItemWordOpened(
            itemIndex: itemIndex,
            cards: widget.cards,
          );
        } else
          return Container();
      },
      itemCount: widget.cards.length,
    );
  }
}

class CarouselItemWordOpened extends StatefulWidget {
  const CarouselItemWordOpened({
    Key key,
    @required this.itemIndex,
    this.cards,
  }) : super(key: key);

  final int itemIndex;
  final List<Magicard> cards;

  @override
  _CarouselItemWordOpenedState createState() => _CarouselItemWordOpenedState();
}

class _CarouselItemWordOpenedState extends State<CarouselItemWordOpened> {
  bool _showMeaningAndActions = false;
  var learningState;

  static void preload(BuildContext context, String path) {
    var configuration = createLocalImageConfiguration(context);
    new NetworkImage(path)..resolve(configuration);
  }

  @override
  void initState() {
    super.initState();
    learningState = Provider.of<LearningState>(context, listen: false);

    // For button "Mark as learned"
    learningState.card = widget.cards[widget.itemIndex];
  }

  @override
  Widget build(BuildContext context) {
    Magicard card = widget.cards[widget.itemIndex];

    User user = Provider.of<User>(context);
    var trainingState = Provider.of<TrainingState>(context, listen: false);

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

    preload(context, cardPhotoPath);

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx < 0 &&
            (widget.itemIndex + 1) < widget.cards.length) {
          trainingState.trainingProgress =
              (widget.itemIndex + 2) / widget.cards.length;
          trainingState.currentCardNumber = widget.itemIndex + 2;
          trainingState.nextPage();
        }
        if (details.delta.dx > 0 && widget.itemIndex > 0) {
          trainingState.trainingProgress =
              widget.itemIndex / widget.cards.length;
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
                SizedBox(height: 20),
                Text(
                  card.title,
                  style: myH1Card,
                ),
                SizedBox(height: 10),
                Text(
                  Strings.getPartOfSpeech(card.partOfSpeech),
                  style: myTranscription,
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
                if (_showMeaningAndActions == true &&
                    (card.syn1 != '' || card.syn2 != ''))
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
                SizedBox(height: 10),
                if (_showMeaningAndActions == true)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
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
                                image: NetworkImage(cardPhotoPath),
                              ),
                              color: Colors.white,
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
                      ],
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
                      user != null ? ButtonLearned() : Container(),
                      SizedBox(height: 16),
                      (widget.itemIndex < (widget.cards.length - 1))
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
      height: convertHeightFrom360(context, 360, 46),
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
      height: convertHeightFrom360(context, 360, 46),
      child: ElevatedButton(
          style: myPrimaryButtonStyle,
          child: Center(child: Text("Далее", style: myPrimaryButtonTextStyle)),
          onPressed: () {
            var trainingState =
                Provider.of<TrainingState>(context, listen: false);

            learningState = Provider.of<LearningState>(context, listen: false);

            bool learned = false;
            Magicard card = learningState.card;

            User user = Provider.of<User>(context, listen: false);
            if (user != null) {
              if (learningState.listLearnedCardsIDs != null) {
                if (learningState.listLearnedCardsIDs.contains(card.id)) {
                  learned = true;
                }
              }
            }

            int incremento = 2;
            if (learned == true) incremento = 1;

            trainingState.currentCardNumber = widget.itemIndex + incremento;
            trainingState.trainingProgress =
                (widget.itemIndex + incremento) / widget.cards.length;

            trainingState.nextPage();
          }),
    );
  }

  Widget _buildButtonFinish() {
    return Container(
      height: convertHeightFrom360(context, 360, 46),
      child: ElevatedButton(
          style: myPrimaryButtonStyle,
          child:
              Center(child: Text("Завершить", style: myPrimaryButtonTextStyle)),
          onPressed: () {
            var trainingState =
                Provider.of<TrainingState>(context, listen: false);
            trainingState.trainingProgress = (1 / widget.cards.length);
            Navigator.of(context).pop();
          }),
    );
  }
}
