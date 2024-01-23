import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/prediction/final_prediction_controller.dart';
import 'package:mellotippet/prediction/prediction_page/prediction_page.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';

class FinalPredictionPage extends ConsumerStatefulWidget {
  final SnackbarHandler snackbarHandler;

  const FinalPredictionPage({super.key, required this.snackbarHandler});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FinalPredictionPageState();
}

class _FinalPredictionPageState extends ConsumerState<FinalPredictionPage> {
  FinalPredictionController get controller =>
      ref.read(FinalPredictionController.provider.notifier);

  @override
  Widget build(BuildContext context) {
    return PredictionPage(
      snackbarHandler: widget.snackbarHandler,
      emptyTopListText:
          'Dra alla bidrag ovanför linjen och rangordna för att tippa',
      controller: controller,
    );
  }
}
