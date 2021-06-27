import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';

class ChooseVariant extends StatefulWidget {
  @override
  _ChooseVariantState createState() => _ChooseVariantState();
}

class _ChooseVariantState extends State<ChooseVariant> {
  final AuthServiceFirebase auth = AuthServiceFirebase();
  String _chosenVariant;

  @override
  void initState() {
    _chosenVariant = "br";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    if (user != null) {
      return StreamBuilder(
          stream: DB.getUserInfoStream(user.uid),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {

              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: Text('Вариант английского'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          DB.updateEnglishVariant(user.uid, "br");
                          setState(() {
                            _chosenVariant = "br";
                          });
                        },
                        child: SelectionListItem(
                          title: 'Британский',
                          action: () {},
                          checked: snapshot.data["eng_version"] == "br" ? true : false,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          DB.updateEnglishVariant(user.uid, "am");
                          setState(() {
                            _chosenVariant = "am";
                          });
                        },
                        child: SelectionListItem(
                          title: 'Американский',
                          action: () {},
                          checked: snapshot.data["eng_version"] == "am" ? true : false,
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: AppBottomNav(selectedIndex: 2),
              );
            } else {
              return LinearProgressIndicator();
            }
          });
    } else {
      return LoginPage();
    }
  }
}
