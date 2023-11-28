import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/cta_button.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/common/widgets/text_form_widget.dart';
import 'package:mellotippet/prediction/final_prediction_controller.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';
import 'package:mellotippet/styles/colors.dart';

class FinalPredictionPage extends ConsumerStatefulWidget {
  final SnackbarHandler snackbarHandler;

  const FinalPredictionPage({super.key, required this.snackbarHandler});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FinalPredictionPageState();
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
                      color: MellotippetColors.melloLightOrange,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Please make your prediction for the ${state.currentCompetition}!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: MellotippetColors.melloLightOrange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const PredictionRow(
                      imageAsset: 'assets/images/tone-sekelius.png'),
                  const PredictionRow(),
                  const PredictionRow(),
                  const PredictionRow(),
                  const PredictionRow(),
                  const PredictionRow(),
                  const SizedBox(height: 8),
                  const SizedBox(height: 16),
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
        title: 'Upload Successful!',
        level: SnackbarAlertLevel.success,
      );
    } else {
      widget.snackbarHandler.showText(
        title: 'Upload Failed!',
        level: SnackbarAlertLevel.error,
      );
    }
  }
}
