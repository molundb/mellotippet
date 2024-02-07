import 'package:flutter/material.dart';
import 'package:mellotippet/styles/colors.dart';

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
    );
  }
}
