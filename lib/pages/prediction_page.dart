import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/database.dart';
import 'package:melodifestivalen_competition/dependencyInjection/get_it.dart';
import 'package:melodifestivalen_competition/text_form_widget.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<StatefulWidget> createState() => PredictionPageState();
}

class PredictionPageState extends State<PredictionPage> {
  String name = '';
  String finalist1 = '';
  String finalist2 = '';
  String semifinalist2 = '';
  String semifinalist1 = '';
  String fifthPlace = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            textInputType: TextInputType.name,
            prefixIcon: const Icon(Icons.emoji_emotions_outlined),
            hintText: 'Enter your name',
            onSaved: (String? value) {
              name = value ?? '';
            },
          ),
          TextFormFieldWidget(
            textInputType: TextInputType.number,
            prefixIcon: const Icon(Icons.star),
            hintText: 'Finalist',
            onSaved: (String? value) {
              finalist1 = value ?? '';
            },
          ),
          TextFormFieldWidget(
            textInputType: TextInputType.number,
            prefixIcon: const Icon(Icons.star),
            hintText: 'Finalist',
            onSaved: (String? value) {
              finalist2 = value ?? '';
            },
          ),
          TextFormFieldWidget(
            textInputType: TextInputType.number,
            prefixIcon: const Icon(Icons.star_border),
            hintText: 'Semifinalist',
            onSaved: (String? value) {
              semifinalist1 = value ?? '';
            },
          ),
          TextFormFieldWidget(
            textInputType: TextInputType.number,
            prefixIcon: const Icon(Icons.star_border),
            hintText: 'Semifinalist',
            onSaved: (String? value) {
              semifinalist2 = value ?? '';
            },
          ),
          TextFormFieldWidget(
            textInputType: TextInputType.number,
            prefixIcon: const Icon(Icons.five_g_outlined),
            hintText: 'Fifth place',
            onSaved: (String? value) {
              fifthPlace = value ?? '';
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _submit();
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final database = getIt.get<Database>();
    database.storePrediction(
      name,
      finalist1,
      finalist2,
      semifinalist1,
      semifinalist2,
      fifthPlace,
    );
  }
}
