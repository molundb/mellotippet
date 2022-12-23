import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/repositories/authentication_repository.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/firebase_options.dart';
import 'package:melodifestivalen_competition/mello_bottom_navigation_bar.dart';
import 'package:melodifestivalen_competition/pages/prediction_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setUpGetIt();
  await _signInAnonymously();

  runApp(const MelodifestivalenCompetitionApp());
}

class MelodifestivalenCompetitionApp extends StatelessWidget {
  const MelodifestivalenCompetitionApp({Key? key}) : super(key: key);

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
        title: 'Melodifestivalen Competition',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  const MelloBottomNavigationBar(),
      ),
    );
  }
}

Future<void> _signInAnonymously() async {
  final auth = getIt.get<AuthenticationRepository>();
  await auth.signInAnonymously();
}