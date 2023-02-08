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
  final _formKey = GlobalKey<FormState>();

  PredictionController get controller =>
      ref.read(PredictionController.provider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUsername();
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome, ${state.username}!',
                    style: const TextStyle(
                      fontSize: 32,
                      color: MelloPredixColors.melloYellow,
                    ),
                  ),
                  const SizedBox(height: 32),
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
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star_border),
                    hintText: 'Semifinalist',
                    onSaved: controller.setSemifinalist1,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.star_border),
                    hintText: 'Semifinalist',
                    onSaved: controller.setSemifinalist2,
                    validator: controller.validatePredictionInput,
                  ),
                  TextFormFieldWidget(
                    textInputType: TextInputType.number,
                    prefixIcon: const Icon(Icons.five_g_outlined),
                    hintText: 'Fifth place',
                    onSaved: controller.setFifthPlace,
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
