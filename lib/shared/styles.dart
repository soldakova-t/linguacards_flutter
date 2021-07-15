import 'package:flutter/material.dart';

/// Construct a color from a hex code string, of the format #RRGGBB.
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class MyColors {
  static const Color mainBgColor = Color(0xFFF8F6F6);
  static const Color mainDarkColor = Color(0xFF1B2C3B);
  static const Color mainBrightColor = Color(0xff32B3FC);
  static const Color greenBrightColor = Color(0xFF1AC840);
  static const Color subtitleColor = Color(0xFF979797);
  static const Color trainingVariantsIconsColor = Color(0xCC393560);
  static const Color inputBgColor = Color(0xFFF6F6F6);
  static const Color inputErrorColor = Color(0x0DFA5C5C);
  static const Color hideAccessColor = Color(0xFFEDEDED);
  static const Color popularBgColor = Color(0xFFFEFFDA);
  static const Color additionalTextGreyColor = Color(0xFFB9B9B9);
}

// My Text Styles

const myMainTextStyle = TextStyle(
  fontSize: 16, // In Figma 15.
  color: Colors.black,
  decoration: TextDecoration.none,
  fontFamily: "SF Compact Display",
  // fontWeight: FontWeight.normal,
);

const myTitleStyle = TextStyle(
  fontSize: 16, // In Figma 15.
  color: Colors.black,
  decoration: TextDecoration.none,
  fontFamily: "SF Compact Display",
  fontWeight: FontWeight.w900,
);

const myCardTitleStyle = TextStyle(
  fontSize: 16, // In Figma 15.
  color: Colors.black,
  decoration: TextDecoration.none,
  fontFamily: "SF Compact Display",
  fontWeight: FontWeight.w500,
);

const myPopularLabelStyle = TextStyle(
  fontSize: 10, // In Figma 15.
  color: Colors.black,
  decoration: TextDecoration.none,
  fontFamily: "SF Compact Display",
  fontWeight: FontWeight.w900,
);

const mySubtitleStyle = TextStyle(
  fontSize: 14, // In Figma 13.
  color: MyColors.subtitleColor,
  decoration: TextDecoration.none,
  fontFamily: "SF Compact Display",
);

const myPercentStyle = TextStyle(
  fontSize: 13,
  color: MyColors.subtitleColor,
  decoration: TextDecoration.none,
  fontFamily: "SF Compact Display",
);


const myHeaderStyle = TextStyle(
  fontSize: 23, // In Figma 21.
  color: Colors.black,
  fontFamily: "SF Compact Display",
  fontWeight: FontWeight.w900,
);


const myNotLearnedTabLabelStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w900,
);

const myLearnedTabLabelStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

const myLogoStyle = TextStyle(
  fontSize: 17,
  color: Colors.black,
  fontFamily: "SF Compact Display",
);



final ButtonStyle myPrimaryButtonStyle = ButtonStyle(
  elevation: MaterialStateProperty.all(0.0),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(12)),
    ),
  ),
  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.disabled)) {
      return hexToColor("#A3DEFF"); // Disabled color
    }
    return MyColors.mainBrightColor; // Regular color
  }),
);


const myPrimaryButtonTextStyle = TextStyle(
  fontSize: 17,
  color: Colors.white,
  fontFamily: "SF Compact Display",
  fontWeight: FontWeight.w600,
);

final ButtonStyle mySecondaryButtonStyle = ButtonStyle(
  elevation: MaterialStateProperty.all(0.0),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(12)),
    ),
  ),
  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.disabled)) {
      return hexToColor("#ECEBEB"); // Disabled color
    }
    return hexToColor("#ECEBEB"); // Regular color
  }),
);


const mySecondaryButtonTextStyle = TextStyle(
  fontSize: 17,
  color: MyColors.mainBrightColor,
  fontFamily: "SF Compact Display",
  fontWeight: FontWeight.w600,
);

// Are not used.

const myLearnedCardTitleStyle = TextStyle(
  fontSize: 16, // In Figma 15.
  color: Colors.grey,
  decoration: TextDecoration.none,
  fontFamily: "SF Compact Display",
  fontWeight: FontWeight.w500,
);

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

const myProgress = TextStyle(
  fontSize: 15,
  color: MyColors.additionalTextGreyColor,
  fontFamily: 'Helvetica',
);

const myTranscription = TextStyle(
  fontSize: 15,
  color: MyColors.additionalTextGreyColor,
  fontFamily: 'Helvetica',
);

const myTitleRus = TextStyle(
  fontSize: 15,
  color: MyColors.subtitleColor,
);

const myExampleCard = TextStyle(
  fontSize: 14,
  color: MyColors.additionalTextGreyColor,
  decoration: TextDecoration.none,
);

const myExampleMainWordCard = TextStyle(
  fontSize: 14,
  color: Colors.black,
  decoration: TextDecoration.none,
);

const myAuthButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
);

const labelSpeedDialStyle = TextStyle(
  fontSize: 15,
  backgroundColor: Colors.white,
);
