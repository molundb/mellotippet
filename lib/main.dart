import 'package:flutter/material.dart';

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
        home: const MyHomePage(title: 'Melodifestivalen Competition'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void submit(String text) {
    _controller.clear();
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
              TextField(
                controller: _controller,
                onSubmitted: submit,
                decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey,
                      size: 24.0,
                    ),
                    hintText: 'Enter your name',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
