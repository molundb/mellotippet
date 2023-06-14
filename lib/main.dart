import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/text_form_widget.dart';

void main() {
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
