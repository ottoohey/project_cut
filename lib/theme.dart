import 'package:flutter/material.dart';

// Must reload app for changes to take effect

class AppTheme {
  //
  AppTheme._();

  // static const String lightBg = '0xFFFBFAFB';
  static const Color lightBg = Color(0xFFEBEBEB);
  static const Color lightBgLight = Color(0xFFFBFAFB);
  static const Color primaryLight = Color(0xFF2372C2);
  static const Color secondaryLight = Color(0xFFFC9F1C);
  static const Color lightShadow = Colors.white;
  static const Color darkBg = Color(0xFF181A21);
  static const Color darkBgLight = Color(0xFF21242D);
  static const Color primaryDark = Color(0xFF70C8FF);
  static const Color secondaryDark = Color(0xFFFCA91C);
  static const Color darkShadow = Color(0xFF282F41);

  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      shadowColor: Colors.amber,
      color: Colors.green, // app bar bg
      titleTextStyle: TextStyle(color: Colors.red),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: lightBg,
      onPrimary: primaryLight,
      secondary: lightBgLight,
      onSecondary: secondaryLight,
      error: Colors.red,
      onError: Colors.white,
      background: lightBg,
      onBackground: primaryLight,
      surface: lightBgLight,
      onSurface: secondaryLight,
    ),
    backgroundColor: lightBgLight,
    canvasColor: lightBg, // scaffold bg
    primaryColor: primaryLight,
    shadowColor: Colors.grey.shade300,
    splashColor: lightShadow,
    sliderTheme: SliderThemeData(
      activeTickMarkColor: Colors.red,
      inactiveTickMarkColor: Colors.red,
      // tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 20),
      valueIndicatorColor: primaryLight.withOpacity(0.3),
      showValueIndicator: ShowValueIndicator.never,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      shadowColor: Colors.amber,
      color: Colors.green, // app bar bg
      titleTextStyle: TextStyle(color: Colors.red),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: darkBg,
      onPrimary: primaryDark,
      secondary: darkBgLight,
      onSecondary: secondaryDark,
      error: Colors.red,
      onError: Colors.white,
      background: darkBg,
      onBackground: primaryDark,
      surface: darkBgLight,
      onSurface: secondaryDark,
    ),
    backgroundColor: darkBgLight,
    canvasColor: darkBg, // scaffold bg
    primaryColor: primaryDark,
    shadowColor: Colors.black,
    splashColor: darkShadow,
    sliderTheme: SliderThemeData(
      activeTickMarkColor: Colors.red,
      inactiveTickMarkColor: Colors.red,
      // tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 20),
      valueIndicatorColor: primaryLight.withOpacity(0.3),
      showValueIndicator: ShowValueIndicator.never,
    ),
  );
}
