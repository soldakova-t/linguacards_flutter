import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Removes status bar's shadow.
        toolbarHeight: 0,
      ),
      body: Center(child: Text("Нет соединения", style: TextStyle(fontSize: 18 ))),
    );
  }
}
