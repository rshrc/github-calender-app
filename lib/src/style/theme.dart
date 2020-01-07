import 'dart:ui';

import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/functions/saveState.dart';
import 'package:flutter/material.dart';

class Style {
  check() async {
    c.theme = await getColor();
    c.theme = c.theme == null ? 0 : c.theme;
  }

  Style();

  static Color primaryGradientStart = Color(0xFF9f60fb);
  static Color primaryGradientEnd = Color(0xFFa45ed6);

  static var primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    stops: [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static Color primaryColor = Color(0xffffffff);
  static Color invertPrimaryColor = Color(0xff212121);

  static Color greyColor = const Color(0x1FFFFFFF);
  static Color invertGreyColor = const Color(0x1F000000);

  static Color subtitleColor = const Color(0xffbdbdbd);
  static Color invertSubtitleColor = const Color(0xff757575);

  static Color backgreyColor = Color(0xffeeeeee);
  static Color backInvertGreyColor = Color(0xff424242);

  static Color primaryColor2 = Color(0xffa45ed6);
  static Color secondaryColor = Color(0xfff0af00);
  static Color sendColor = Color(0xff1000ff);
  static Color todayColor = Color(0xff0000ff);

  static Color weekdayColor = Color(0xf000000);
  static List<Color> randomColor = [
    Color(0xff654321),
    Color(0xff654321),
    Color(0xff654321),
    Color(0xff654321),
    Color(0xff654321),
    Color(0xff654321),
    Color(0xff654321),
  ];
  // Color
}
