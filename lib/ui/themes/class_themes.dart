import 'package:flutter/material.dart';

class AppThemeCustom {
  // Grayscale
  static const Color gray900 = Color(0xFF303030);
  static const Color gray800 = Color(0xFF454545);
  static const Color gray700 = Color(0xFF585858);
  static const Color gray600 = Color(0xFF6E6E6E);
  static const Color gray500 = Color(0xFF828282);
  static const Color gray400 = Color(0xFFAAAAAA);
  static const Color gray300 = Color(0xFFBFBFBF);
  static const Color gray200 = Color(0xFFDEDEDE);
  static const Color gray100 = Color(0xFFE8E8E8);
  static const Color gray50 = Color(0xFFF2F2F2);

  // Green
  static const Color green900 = Color(0xFF002E08);
  static const Color green800 = Color(0xFF0F511D);
  static const Color green700 = Color(0xFF327025);
  static const Color green600 = Color(0xFF3E8320);
  static const Color green500 = Color(0xFF5EAF3C);
  static const Color green400 = Color(0xFF7FBF65);
  static const Color green300 = Color(0xFF98D57F);
  static const Color green200 = Color(0xFFBBDFAC);
  static const Color green100 = Color(0xFFD6F1CA);
  static const Color green50 = Color(0xFFEAFCE2);

  // Red
  static const Color red900 = Color(0xFF4E0101);
  static const Color red800 = Color(0xFF8B0202);
  static const Color red700 = Color(0xFFBA1122);
  static const Color red600 = Color(0xFFCD191E);
  static const Color red500 = Color(0xFFD63336);
  static const Color red400 = Color(0xFFD34C51);
  static const Color red300 = Color(0xFFDE797C);
  static const Color red200 = Color(0xFFEB8F93);
  static const Color red100 = Color(0xFFFAC8CD);
  static const Color red50 = Color(0xFFFFE5E6);

  // Blue
  static const Color blue900 = Color(0xFF111658);
  static const Color blue800 = Color(0xFF2D2D87);
  static const Color blue700 = Color(0xFF3036A1);
  static const Color blue600 = Color(0xFF383EB5);
  static const Color blue500 = Color(0xFF3E4DB8);
  static const Color blue400 = Color(0xFF5759A7);
  static const Color blue300 = Color(0xFF8182BD);
  static const Color blue200 = Color(0xFFACADD3);
  static const Color blue100 = Color(0xFFD2D1F0);
  static const Color blue50 = Color(0xFFE5E6FF);

  // Yellow
  static const Color yellow900 = Color(0xFF181508);
  static const Color yellow800 = Color(0xFF61531F);
  static const Color yellow700 = Color(0xFFAA9136);
  static const Color yellow600 = Color(0xFFC2A63E);
  static const Color yellow500 = Color(0xFFE5C348);
  static const Color yellow400 = Color(0xFFF3CF4D);
  static const Color yellow300 = Color(0xFFF5D971);
  static const Color yellow200 = Color(0xFFF8E294);
  static const Color yellow100 = Color(0xFFFBF1CA);
  static const Color yellow50 = Color(0xFFEFAEAD);

  // Black & White
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Método para temas
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: green500,
      scaffoldBackgroundColor: white,
      fontFamily: "OpenSans",
      colorScheme: const ColorScheme.light(
        primary: green500,
        secondary: blue500,
        surface: white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: gray900),
        bodyMedium: TextStyle(color: gray800),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: gray900,
      scaffoldBackgroundColor: gray900,
      fontFamily: "OpenSans",
      colorScheme: const ColorScheme.dark(
        primary: green500,
        secondary: blue500,
        surface: gray900,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: white),
        bodyMedium: TextStyle(color: gray200),
      ),
    );
  }
}