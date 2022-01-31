import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/text_form_widget.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  UserCredential userCredential =
      await FirebaseAuth.instance.signInAnonymously();

  FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL:
          "https://melodifestivalen-competition-default-rtdb.europe-west1.firebasedatabase.app");
  DatabaseReference ref = database.ref();
  DatabaseEvent event = await ref.once();
  print(event.snapshot.value);

  FirebaseAuth auth = FirebaseAuth.instance;
  auth.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

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
        home: const HomePage(title: 'Melodifestivalen Competition'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _nameController;
  late TextEditingController _finalist1Controller;
  late TextEditingController _finalist2Controller;
  late TextEditingController _semifinalist1Controller;
  late TextEditingController _semifinalist2Controller;
  late TextEditingController _fifthPlaceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _finalist1Controller = TextEditingController();
    _finalist2Controller = TextEditingController();
    _semifinalist1Controller = TextEditingController();
    _semifinalist2Controller = TextEditingController();
    _fifthPlaceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _finalist1Controller.dispose();
    _finalist2Controller.dispose();
    _semifinalist1Controller.dispose();
    _semifinalist2Controller.dispose();
    _fifthPlaceController.dispose();
    super.dispose();
  }

  void submit() {
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(44.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormFieldWidget(
                textInputType: TextInputType.name,
                controller: _nameController,
                prefixIcon: const Icon(Icons.emoji_emotions_outlined),
                hintText: 'Enter your name',
                onSubmitField: submit,
              ),
              TextFormFieldWidget(
                textInputType: TextInputType.number,
                controller: _finalist1Controller,
                prefixIcon: const Icon(Icons.star),
                hintText: 'Finalist',
              ),
              TextFormFieldWidget(
                textInputType: TextInputType.number,
                controller: _finalist2Controller,
                prefixIcon: const Icon(Icons.star),
                hintText: 'Finalist',
              ),
              TextFormFieldWidget(
                textInputType: TextInputType.number,
                controller: _semifinalist1Controller,
                prefixIcon: const Icon(Icons.star_border),
                hintText: 'Semifinalist',
              ),
              TextFormFieldWidget(
                textInputType: TextInputType.number,
                controller: _semifinalist2Controller,
                prefixIcon: const Icon(Icons.star_border),
                hintText: 'Semifinalist',
              ),
              TextFormFieldWidget(
                textInputType: TextInputType.number,
                controller: _fifthPlaceController,
                prefixIcon: const Icon(Icons.five_g_outlined),
                hintText: 'Fifth place',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
