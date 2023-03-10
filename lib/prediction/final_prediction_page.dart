import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/widgets/cta_button.dart';
import 'package:melodifestivalen_competition/common/widgets/text_form_widget.dart';
import 'package:melodifestivalen_competition/prediction/final_prediction_controller.dart';
import 'package:melodifestivalen_competition/prediction/semifinal_prediction_controller.dart';
import 'package:melodifestivalen_competition/styles/colors.dart';

class FinalPredictionPage extends ConsumerStatefulWidget {
  const FinalPredictionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FinalPredictionPageState();
}

class _FinalPredictionPageState extends ConsumerState<FinalPredictionPage> {
  final _formKey = GlobalKey<FormState>();

  FinalPredictionController get controller =>
      ref.read(FinalPredictionController.provider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUsernameAndCurrentCompetition();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(FinalPredictionController.provider);

    // TODO: Figure out how to handle loading

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Welcome, ${state.username}!',
                    style: const TextStyle(
                      fontSize: 32,
                      color: MelloPredixColors.melloYellow,
                    ),
                  ),
                  const SizedBox(height: 64),
                  Text(
                    'Please make your prediction for the ${state.currentCompetition}!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: MelloPredixColors.melloYellow,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '1st place',
                    onSaved: controller.setPosition1,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '2nd place',
                    onSaved: controller.setPosition2,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '3rd place',
                    onSaved: controller.setPosition3,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '4th place',
                    onSaved: controller.setPosition4,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '5th place',
                    onSaved: controller.setPosition5,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '6th place',
                    onSaved: controller.setPosition6,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '7th place',
                    onSaved: controller.setPosition7,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '8th place',
                    onSaved: controller.setPosition8,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '9th place',
                    onSaved: controller.setPosition9,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '10th place',
                    onSaved: controller.setPosition10,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '11th place',
                    onSaved: controller.setPosition11,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: '12th place',
                    onSaved: controller.setPosition12,
                    validator: controller.validatePredictionInput,
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CtaButton(
                  text: 'Submit',
                  onPressed: () => _submitPressed(context),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _submitPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!controller.duplicatePredictions()) {
        _submit(context);
      } else {
        _showErrorSnackBar(
          context,
          'Error: same prediction in multiple positions',
        );
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _submit(BuildContext context) async {
    final successful = await controller.submitPrediction();

    if (successful) {
      _showErrorSnackBar(context, 'Upload Successful!');
    } else {
      _showErrorSnackBar(context, 'Upload Failed!');
    }
  }
}
