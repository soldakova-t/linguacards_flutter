import 'package:flutter/material.dart';
import 'package:magicards/shared/custom_icons_icons.dart';
import 'package:magicards/shared/shared.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final bool isHomePage;

  AppBottomNav({this.selectedIndex, this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            icon: Icon(CustomIcons.bottomnav_words,),
            title: Text('Слова')),
        BottomNavigationBarItem(
            icon: Icon(CustomIcons.bottomnav_search,),
            title: Text('Поиск')),
        /*BottomNavigationBarItem(
            icon: Icon(CustomIcons.bottomnav_heart,),
            title: Text('Мой список')),*/
        BottomNavigationBarItem(
            icon: Icon(CustomIcons.bottomnav_profile,),
            title: Text('Профиль')),
      ].toList(),
      currentIndex: selectedIndex,
      selectedItemColor: MyColors.mainBrightColor,
      unselectedItemColor: MyColors.mainDarkColor,
      selectedFontSize: 12,
      iconSize: 24,
      backgroundColor: Colors.white,
      onTap: (int idx) {
        switch (idx) {
          case 0:
            if (selectedIndex != 0 || !isHomePage) { Navigator.pushNamed(context, '/'); }
            break;
          case 1:
            if (selectedIndex != 1) { Navigator.pushNamed(context, '/about'); }
            break;
          case 2:
            if (selectedIndex != 2) { Navigator.pushNamed(context, '/profile'); }
            break;
            break;
          case 3:
            if (selectedIndex != 3) { Navigator.pushNamed(context, '/profile'); }
            break;
        }
      },
    );
  }
}