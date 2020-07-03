import 'package:flutter/material.dart';

/// Construct a color from a hex code string, of the format #RRGGBB.
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class MyColors {
  static const Color mainBgColor = Color(0xFFF3F3F3);
  static const Color mainDarkColor = Color(0xFF393560);
  static const Color mainBrightColor = Color(0xFFFA5C5C);
  static const Color greenBrightColor = Color(0xFF1AC840);
  static const Color subtitleColor = Color(0x99171245);
  static const Color trainingVariantsIconsColor = Color(0xCC393560);
}

// My Text Styles
const myH1 = TextStyle(
  fontSize: 28,
  color: MyColors.mainDarkColor,
  fontWeight: FontWeight.bold,
);

const myH2 = TextStyle(
  fontSize: 20,
  color: MyColors.mainDarkColor,
  fontWeight: FontWeight.bold,
);

const mySubtitle16Style = TextStyle(
  fontSize: 16,
  color: MyColors.mainDarkColor,
  fontWeight: FontWeight.bold,
);

const mySubtitle14Style = TextStyle(
  fontSize: 14,
  color: MyColors.subtitleColor,
);

const myMainTextStyle = TextStyle(
  fontSize: 14,
  color: MyColors.mainDarkColor,
  decoration: TextDecoration.none,
  // fontWeight: FontWeight.normal,
);

const myVariantsTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
  decoration: TextDecoration.none,
  letterSpacing: 0.85,
);

const myLabelTextStyle = TextStyle(
  fontSize: 12,
  color: MyColors.mainDarkColor,
);

const myToolbarTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: MyColors.mainDarkColor,
);

const myH1Card = TextStyle(
  fontSize: 36,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const myTranscriptionCard = TextStyle(
  fontSize: 13,
  color: Color(0xFF878787),
  fontFamily: 'Helvetica',
);

const myLabelTextStyleCard = TextStyle(
  fontSize: 14,
  color: Color(0xFF878787),
);

const myExampleCard = TextStyle(
  fontSize: 14,
  color: Color(0xFF878787),
  decoration: TextDecoration.none,
);

const myExampleMainWordCard = TextStyle(
  fontSize: 14,
  color: Colors.black,
  decoration: TextDecoration.none,
);
