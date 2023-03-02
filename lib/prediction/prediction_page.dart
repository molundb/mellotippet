import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/widgets/cta_button.dart';
import 'package:melodifestivalen_competition/common/widgets/text_form_widget.dart';
import 'package:melodifestivalen_competition/prediction/prediction_controller.dart';
import 'package:melodifestivalen_competition/styles/colors.dart';

class PredictionPage extends ConsumerStatefulWidget {
  const PredictionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PredictionPageState();
}

class _PredictionPageState extends ConsumerState<PredictionPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  PredictionController get controller =>
      ref.read(PredictionController.provider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUsernameAndCurrentCompetition();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(PredictionController.provider);

    // TODO: Figure out how to handle loading

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Form(
              key: _formKey1,
              child: Column(
                children: [
                  Text(
                    'Welcome, ${state.username}!',
                    style: const TextStyle(
                      fontSize: 32,
                      color: MelloPredixColors.melloYellow,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Please make your prediction for ${state.currentCompetition} group 1!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: MelloPredixColors.melloYellow,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: 'Finalist',
                    onSaved: controller.setFinalist1,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: 'Finalist',
                    onSaved: controller.setFinalist2,
                    validator: controller.validatePredictionInput,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CtaButton(
                        text: 'Submit group 1',
                        onPressed: () => _submitPressed(context, _formKey1, 1),
                      )
                    ],
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Form(
              key: _formKey2,
              child: Column(
                children: [
                  Text(
                    'Please make your prediction for ${state.currentCompetition} group 2!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: MelloPredixColors.melloYellow,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: 'Finalist',
                    onSaved: controller.setFinalist3,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star),
                    hintText: 'Finalist',
                    onSaved: controller.setFinalist4,
                    validator: controller.validatePredictionInput,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CtaButton(
                        text: 'Submit group 2',
                        onPressed: () => _submitPressed(context, _formKey2, 2),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitPressed(
    BuildContext context,
    GlobalKey<FormState> formKey,
    int group,
  ) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (!controller.duplicatePredictions(group)) {
        _submit(context, group);
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

  void _submit(BuildContext context, int group) async {
    final successful = await controller.submitPrediction(group);

    if (successful) {
      _showErrorSnackBar(context, 'Upload Successful!');
    } else {
      _showErrorSnackBar(context, 'Upload Failed!');
    }
  }
}
