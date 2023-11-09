import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/config/config.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/login/login_page.dart';
import 'package:melodifestivalen_competition/styles/colors.dart';
import 'package:melodifestivalen_competition/styles/text_styles.dart';

class MelodifestivalenCompetitionApp extends StatelessWidget {
  final config = getIt.get<Config>();
  final snackbarKey = getIt.get<GlobalKey<ScaffoldMessengerState>>();

  MelodifestivalenCompetitionApp({super.key});

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
            color: MellotippetColors.melloPurple,
            shape: RoundedRectangleBorder(),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: MellotippetColors.melloYellow,
              // textStyle: const TextStyle(
              //   fontSize: 12,
              // )
            ),
          ),
          fontFamily: 'Hind',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            bodyMedium: MellotippetTextStyle.defaultStyle,
            bodySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
