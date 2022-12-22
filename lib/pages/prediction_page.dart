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
  late TextEditingController _nameController;
  late TextEditingController _finalist1Controller;
  late TextEditingController _finalist2Controller;
  late TextEditingController _semifinalist1Controller;
  late TextEditingController _semifinalist2Controller;
  late TextEditingController _fifthPlaceController;
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            textInputType: TextInputType.name,
            controller: _nameController,
            prefixIcon: const Icon(Icons.emoji_emotions_outlined),
            hintText: 'Enter your name',
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
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
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
      _nameController.text,
      _finalist1Controller.text,
      _finalist2Controller.text,
      _semifinalist1Controller.text,
      _semifinalist2Controller.text,
      _fifthPlaceController.text,
    );
  }
}
