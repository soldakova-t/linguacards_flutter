import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:magicards/shared/custom_icons_icons.dart';
import 'package:magicards/shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final bool isHomePage;

  AppBottomNav({this.selectedIndex, this.isHomePage});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            /*boxShadow: [
              BoxShadow(color: Colors.grey[350], spreadRadius: 0, blurRadius: 10)
            ],*/
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  // sets the background color of the `BottomNavigationBar`
                  canvasColor: Color(0xCCFFFFFF),
                  // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                  primaryColor: Color(0xCCFFFFFF),
                  textTheme: Theme.of(context).textTheme.copyWith(
                      caption: new TextStyle(color: Color(0xCCFFFFFF))),
                ), // sets the inactive color of the `BottomNavigationBar`
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(
                          CustomIcons.bottomnav_home,
                        ),
                        label: "Главная"),
                    BottomNavigationBarItem(
                        icon: Icon(
                          CustomIcons.bottomnav_words,
                        ),
                        label: "Слова"),
                    BottomNavigationBarItem(
                        icon: Icon(
                          CustomIcons.bottomnav_profile,
                        ),
                        label: user == null ? "Войти" : "Профиль"),
                  ].toList(),
                  currentIndex: selectedIndex,
                  selectedItemColor: MyColors.logoPinkColor,
                  unselectedItemColor: MyColors.mainDarkColor,
                  selectedFontSize: 12,
                  iconSize: 24,
                  elevation: 0,
                  onTap: (int idx) {
                    switch (idx) {
                      case 0:
                        if (selectedIndex != 0 || !isHomePage) {
                          Navigator.pushNamed(context, '/');
                        }
                        break;
                      case 1:
                        if (selectedIndex != 1) {
                          Navigator.pushNamed(context, '/words');
                        }
                        break;
                      case 2:
                        if (selectedIndex != 2) {
                          user == null
                              ? Navigator.pushNamed(
                                  context,
                                  '/login',
                                  arguments: {"prevScreen": "bottomNav"},
                                )
                              : Navigator.pushNamed(context, '/settings');
                        }
                        break;
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
