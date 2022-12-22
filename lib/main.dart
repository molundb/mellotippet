import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/authentication.dart';
import 'package:melodifestivalen_competition/dependencyInjection/get_it.dart';
import 'package:melodifestivalen_competition/firebase_options.dart';
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
        // home: const HomePage(title: 'Melodifestivalen Competition'),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Melodifestivalen Competition'),
          ),
          body: const PredictionPage(),
        ),
      ),
    );
  }
}

Future<void> _signInAnonymously() async {
  final auth = getIt.get<Authentication>();
  await auth.signInAnonymously();
}