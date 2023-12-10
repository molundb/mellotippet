import 'package:flutter/material.dart';
import 'package:mellotippet/styles/colors.dart';
import 'package:mellotippet/styles/text_styles.dart';

@immutable
class MelloTippetTheme {
  const MelloTippetTheme();

  ThemeData toThemeData() {
    return ThemeData(
      primaryColor: MellotippetColors.melloPurple,
      appBarTheme: const AppBarTheme(
        color: MellotippetColors.melloLightPink,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MellotippetColors.melloLightOrange,
        ),
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        bodyMedium: MellotippetTextStyle.defaultStyle,
        bodySmall: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
      ),
    );
  }
}
