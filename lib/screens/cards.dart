import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:magicards/screens/training_flashcards.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import '../screens/screens.dart';
import 'package:provider/provider.dart';

class CardsScreen extends StatefulWidget {
  final Subtopic subtopic;
  CardsScreen({Key key, this.subtopic}) : super(key: key);

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  static const kExpandedHeight = 155.0;
  ScrollController _scrollController;
  List<Magicard> listOfCards = List<Magicard>();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
      floatingActionButton: Container(
        height: 48,
        width: 196,
        child: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => ChooseVariantOverlay(
                listOfCards: listOfCards,
              ),
            );
          },
          label: Text('Флешкарты'),
          backgroundColor: MyColors.mainBrightColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: AppBottomNav(
        selectedIndex: 0,
        isHomePage: false,
      ),
    );
  }

  _showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      //position: RelativeRect.fromLTRB(40, 40, double.infinity, double.infinity),
      position: RelativeRect.fromLTRB(double.infinity, double.infinity, 140, 0),
      items: [
        PopupMenuItem(
          child: Text("View"),
        ),
        PopupMenuItem(
          child: Text("Edit"),
        ),
        PopupMenuItem(
          child: Text("Delete"),
        ),
      ],
      elevation: 8.0,
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('cards')
          .where('subtopic', isEqualTo: widget.subtopic.title)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    listOfCards =
        snapshot.map((document) => Magicard.fromSnapshot(document)).toList();

    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: hexToColor('#B2B2B2'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          expandedHeight: kExpandedHeight + kToolbarHeight,
          title: _showTitle
              ? Text(
                  widget.subtopic.title,
                  style: myToolbarTextStyle,
                )
              : null,
          flexibleSpace: _showTitle
              ? null
              : FlexibleSpaceBar(
                  background: SubtopicDetails(subtopic: widget.subtopic),
                ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 15,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => CardContent(
                card: Magicard.fromSnapshot(snapshot[index]),
                learned: false,
              ),
              childCount: snapshot.length,
            ),
          ),
        ),
      ],
    );
  }
}

class SubtopicDetails extends StatelessWidget {
  final Subtopic subtopic;

  const SubtopicDetails({Key key, this.subtopic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 40,
              right: 40,
              top: 56 + kToolbarHeight,
            ),
            child: Container(
              child: Text(
                subtopic.title,
                style: myH1,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 40,
            ),
            child: Text(subtopic.titleRus, style: mySubtitle14Style),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 28,
            ),
            child: Container(
              width: 76,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Center(
                child: Text('240 слов', style: myLabelTextStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final Magicard card;
  final bool learned;

  const CardContent({
    Key key,
    this.card,
    this.learned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => TrainingMatch(
              listOfCards: listOfCards,
            ),
          ),
        );*/
      },
      child: Ink(
        color: Colors.white,
        child: Padding(
          key: ValueKey(card.title),
          padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 0.0),
          child: ListTile(
            contentPadding: const EdgeInsets.only(
              left: 0.0,
              right: 0.0,
            ),
            leading: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  card.photo,
                  height: 70,
                  width: 70,
                  fit: card.whiteBg == '1' ? BoxFit.contain : BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              card.title,
              style: mySubtitle16Style,
            ),
            subtitle: Text(
              card.titleRus,
              style: mySubtitle14Style,
            ),
            trailing: SizedBox(
              width: 88,
              height: 25,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.check,
                    size: 18,
                    color: Colors.green[600],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Изучено',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChooseVariantOverlay extends StatelessWidget {
  ChooseVariantOverlay({
    Key key,
    this.listOfCards,
  }) : super(key: key);

  final List<Magicard> listOfCards;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: Container(
            height: 123.0,
            width: 320.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[700],
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  //offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: 320,
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 22),
                        Icon(Icons.favorite),
                        SizedBox(width: 16),
                        Text(
                          'Скрыть изображения',
                          style: myVariantsTextStyle,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => TrainingFlashcards(
                          listOfCards: listOfCards,
                          trainingVariant: 0,
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[400],
                ),
                FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: 320,
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 22),
                        Icon(Icons.favorite),
                        SizedBox(width: 16),
                        Text(
                          'Скрыть английские слова',
                          style: myVariantsTextStyle,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => TrainingFlashcards(
                          listOfCards: listOfCards,
                          trainingVariant: 1,
                        ),
                      ),
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }
}
