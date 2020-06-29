import 'package:flutter/material.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TrainingFlashcards extends StatelessWidget {
  TrainingFlashcards({Key key, this.listOfCards}) : super(key: key);
  final List<Magicard> listOfCards;

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
                    height: 8.0,
                    child: Consumer<TrainingFlashcardsState>(
                      builder: (context, state, child) =>
                          AnimatedProgress(value: state.progress),
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
              child: _buildCarousel(context),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 60.0 + MediaQuery.of(context).padding.top),
              child: CustomGradientContainer(
                  width: 40,
                  colors: [Colors.grey[200], Colors.white.withOpacity(0.0)],
                  stops: [0.0, 0.95]),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 60.0 + MediaQuery.of(context).padding.top),
              alignment: Alignment.topRight,
              child: CustomGradientContainer(
                  width: 40,
                  colors: [Colors.white.withOpacity(0.0), Colors.grey[200]],
                  stops: [0.0, 0.95]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context) {
    var state = Provider.of<TrainingFlashcardsState>(context);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: state.controller,
        onPageChanged: (int idx) {
          state.progress = ((idx + 1) / listOfCards.length);
        },
        itemBuilder: (BuildContext context, int itemIndex) {
          return _buildCarouselItem(context, itemIndex);
        },
        itemCount: listOfCards.length,
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex) {
    var state = Provider.of<TrainingFlashcardsState>(context);

    return Padding(
      padding: EdgeInsets.only(left: 4.0, top: 10.0, right: 4.0, bottom: 10.0),
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx < 0) {
            state.nextPage();
          }
          if (details.delta.dx > 0) {
            state.prevPage();
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
                padding: const EdgeInsets.all(34.0),
                child: Stack(children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        listOfCards[itemIndex].title,
                        style: myH1Card,
                      ),
                      SizedBox(height: 10),
                      Row(
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
                                child:
                                    SvgPicture.asset('assets/icons/sound.svg'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        listOfCards[itemIndex].titleRus,
                        style: myMainTextStyleCard,
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.network(listOfCards[itemIndex].photo),
                        ),
                      ),
                      SizedBox(height: 120),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 48,
                      width: 196,
                      child: FloatingActionButton.extended(
                        heroTag: null,
                        onPressed: () {},
                        label: Text('Изучено'),
                        backgroundColor: MyColors.mainBrightColor,
                      ),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: ShowMeaning(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowMeaning extends StatefulWidget {
  ShowMeaning({Key key}) : super(key: key);

  @override
  _ShowMeaningState createState() => _ShowMeaningState();
}

class _ShowMeaningState extends State<ShowMeaning>
    with AutomaticKeepAliveClientMixin<ShowMeaning> {
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _show = false;
        });
      },
      child: Container(
        width: double.infinity,
        child: Opacity(
          opacity: _show == true ? 1.0 : 0.0,
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
                  'Показать значение',
                  style: TextStyle(
                    color: hexToColor('#979797'),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomGradientContainer extends StatelessWidget {
  const CustomGradientContainer({
    Key key,
    @required List<Color> colors,
    @required List<double> stops,
    @required double width,
  })  : _colors = colors,
        _stops = stops,
        _width = width,
        super(key: key);

  final List<Color> _colors;
  final List<double> _stops;
  final double _width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _colors,
          stops: _stops,
        ),
      ),
    );
  }
}
