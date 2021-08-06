import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magicards/services/services.dart';
import 'package:provider/provider.dart';

class NoConnectionScreen extends StatefulWidget {
  @override
  _NoConnectionScreenState createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var trainingState = Provider.of<TrainingState>(context, listen: false);
      trainingState.currentCardNumber = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    String message = "Нет соединения";

    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Removes status bar's shadow.
        toolbarHeight: 0,
      ),
      body: Center(child: Text(message, style: TextStyle(fontSize: 18))),
    );
  }
}
