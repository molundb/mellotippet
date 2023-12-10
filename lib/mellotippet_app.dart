import 'package:flutter/material.dart';
import 'package:mellotippet/config/config.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/force_upgrade/force_upgrade_page.dart';
import 'package:mellotippet/styles/colors.dart';
import 'package:mellotippet/styles/text_styles.dart';

class MellotippetApp extends StatelessWidget {
  final config = getIt.get<Config>();
  final snackbarKey = getIt.get<GlobalKey<ScaffoldMessengerState>>();

  MellotippetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: MaterialApp(
        title: config.title,
        scaffoldMessengerKey: snackbarKey,
        theme: ThemeData(
          primaryColor: MellotippetColors.melloPurple,
          appBarTheme: const AppBarTheme(
            color: MellotippetColors.melloLightPink,
            shape: RoundedRectangleBorder(),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: MellotippetColors.melloLightOrange,
              // textStyle: const TextStyle(
              //   fontSize: 12,
              // )
            ),
          ),
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            bodyMedium: MellotippetTextStyle.defaultStyle,
            bodySmall: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
          ),
        ),
        home: const ForceUpgradePage(),
      ),
    );
  }
}
