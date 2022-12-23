import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/repositories/database_repository.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/models/prediction_model.dart';
import 'package:melodifestivalen_competition/widgets/text_form_widget.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<StatefulWidget> createState() => PredictionPageState();
}

class PredictionPageState extends State<PredictionPage> {
  PredictionModel prediction = PredictionModel();

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
              prediction.name = value;
            },
          ),
          TextFormFieldWidget(
            textInputType: TextInputType.number,
            prefixIcon: const Icon(Icons.star),
            hintText: 'Finalist',
            onSaved: (String? value) {
              prediction.finalist1 = value;
            },
          ),
          TextFormFieldWidget(
            textInputType: TextInputType.number,
            prefixIcon: const Icon(Icons.star),
            hintText: 'Finalist',
            onSaved: (String? value) {
              prediction.finalist2 = value;
            },
          ),
          TextFormFieldWidget(
            textInputType: TextInputType.number,
            prefixIcon: const Icon(Icons.star_border),
            hintText: 'Semifinalist',
            onSaved: (String? value) {
              prediction.semifinalist1 = value;
            },
          ),
          TextFormFieldWidget(
            textInputType: TextInputType.number,
            prefixIcon: const Icon(Icons.star_border),
            hintText: 'Semifinalist',
            onSaved: (String? value) {
              prediction.semifinalist2 = value;
            },
          ),
          TextFormFieldWidget(
            textInputType: TextInputType.number,
            prefixIcon: const Icon(Icons.five_g_outlined),
            hintText: 'Fifth place',
            onSaved: (String? value) {
              prediction.fifthPlace = value;
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
    final database = getIt.get<DatabaseRepository>();
    database.uploadPrediction(prediction);
  }
}
