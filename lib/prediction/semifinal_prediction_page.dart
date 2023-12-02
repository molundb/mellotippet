import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/old_cta_button.dart';
import 'package:mellotippet/common/widgets/text_form_widget.dart';
import 'package:mellotippet/prediction/semifinal_prediction_controller.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';
import 'package:mellotippet/styles/colors.dart';

class SemifinalPredictionPage extends ConsumerStatefulWidget {
  final SnackbarHandler snackbarHandler;

  const SemifinalPredictionPage({super.key, required this.snackbarHandler});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SemifinalPredictionPageState();
}

class _SemifinalPredictionPageState
    extends ConsumerState<SemifinalPredictionPage> {
  final _formKey = GlobalKey<FormState>();

  SemifinalPredictionController get controller =>
      ref.read(SemifinalPredictionController.provider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUsernameAndCurrentCompetition();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(SemifinalPredictionController.provider);

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
                      color: MellotippetColors.melloLightOrange,
                    ),
                  ),
                  const SizedBox(height: 64),
                  Text(
                    'Please make your prediction for the ${state.currentCompetition}!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: MellotippetColors.melloLightOrange,
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
                OldCtaButton(
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
        widget.snackbarHandler.showText(
          title: 'Error: same prediction in multiple positions',
        );
      }
    }
  }

  void _submit(BuildContext context) async {
    final successful = await controller.submitPrediction();

    if (successful) {
      widget.snackbarHandler.showText(
          title: 'Upload Successful!', level: SnackbarAlertLevel.success);
    } else {
      widget.snackbarHandler
          .showText(title: 'Upload Failed!', level: SnackbarAlertLevel.error);
    }
  }
}
