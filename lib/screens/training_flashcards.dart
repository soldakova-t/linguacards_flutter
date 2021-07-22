import 'package:flutter/material.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import 'package:magicards/screens/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class TrainingFlashcards extends StatefulWidget {
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
    Globals.playPronounciation("http://magicards.ru/cards_sounds/" +
            learningState.cardsForTraining[0].subtopic.toString() +
            "/" +
            learningState.cardsForTraining[0].title +
            ".mp3" ??
        "");
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
                        SizedBox(width: convertWidthFrom360(context, 18)),
                        Container(
                          child: Text(
                            trainingState.currentCardNumber.toString() +
                                " из " +
                                learningState.cardsForTraining.length
                                    .toString(),
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
                      var trainingState =
                          Provider.of<TrainingState>(context, listen: false);
                      trainingState.trainingProgress =
                          (1 / learningState.cardsForTraining.length);
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
        Globals.playPronounciation("http://magicards.ru/cards_sounds/" +
                learningState.cardsForTraining[idx].subtopic.toString() +
                "/" +
                learningState.cardsForTraining[idx].title +
                ".mp3" ??
            "");
      },
      itemBuilder: (BuildContext context, int itemIndex) {
        if (trainingVariant == 0) {
          return CarouselItemWordOpened(itemIndex: itemIndex);
        } else
          return Container();
      },
      itemCount: learningState.cardsForTraining.length,
    );
  }
}

class CarouselItemWordOpened extends StatefulWidget {
  const CarouselItemWordOpened({
    Key key,
    @required this.itemIndex,
  }) : super(key: key);

  final int itemIndex;

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
    learningState.card = learningState.cardsForTraining[widget.itemIndex];
  }

  @override
  Widget build(BuildContext context) {
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

    String pathPhoto = "http://magicards.ru/cards_photos/" +
        learningState.cardsForTraining[widget.itemIndex].subtopic.toString() +
        "/" +
        bigPhotoWidth.toString() +
        "/" +
        learningState.cardsForTraining[widget.itemIndex].number.toString() +
        ".jpg";

    preload(context, pathPhoto);

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx < 0 &&
            (widget.itemIndex + 1) < learningState.cardsForTraining.length) {
          trainingState.trainingProgress =
              (widget.itemIndex + 2) / learningState.cardsForTraining.length;
          trainingState.currentCardNumber = widget.itemIndex + 2;
          trainingState.nextPage();
        }
        if (details.delta.dx > 0 && widget.itemIndex > 0) {
          trainingState.trainingProgress =
              widget.itemIndex / learningState.cardsForTraining.length;
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
                  learningState.cardsForTraining[widget.itemIndex].title,
                  style: myH1Card,
                ),
                SizedBox(height: 10),
                Text(
                  learningState.cardsForTraining[widget.itemIndex].partOfSpeech,
                  style: myTranscription,
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Globals.playPronounciation(
                        "http://magicards.ru/cards_sounds/" +
                                learningState.cardsForTraining[widget.itemIndex].subtopic
                                    .toString() +
                                "/" +
                                learningState.cardsForTraining[widget.itemIndex].title +
                                ".mp3" ??
                            "");
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        '[' +
                            learningState.cardsForTraining[widget.itemIndex].transcriptionBr +
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
                    (learningState.cardsForTraining[widget.itemIndex].syn1 != '' ||
                        learningState.cardsForTraining[widget.itemIndex].syn2 != ''))
                  RichText(
                    text: TextSpan(
                      text: "also ",
                      style: myTranscription,
                      children: <TextSpan>[
                        TextSpan(
                            text: learningState.cardsForTraining[widget.itemIndex].syn1,
                            style: TextStyle(color: Colors.black)),
                        if (learningState.cardsForTraining[widget.itemIndex].syn1 != '' &&
                            learningState.cardsForTraining[widget.itemIndex].syn2 != '')
                          TextSpan(
                              text: ", ",
                              style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: learningState.cardsForTraining[widget.itemIndex].syn2,
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
                            learningState.cardsForTraining[widget.itemIndex].titleRus,
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
                      ButtonLearned(),
                      SizedBox(height: 16),
                      (widget.itemIndex < (learningState.cardsForTraining.length - 1))
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
            trainingState.trainingProgress =
                (widget.itemIndex + 2) / learningState.cardsForTraining.length;
            trainingState.currentCardNumber = widget.itemIndex + 2;
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
            trainingState.trainingProgress = (1 / learningState.cardsForTraining.length);
            Navigator.of(context).pop();
          }),
    );
  }
}
