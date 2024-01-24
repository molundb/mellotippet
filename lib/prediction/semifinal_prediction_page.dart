import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/prediction/prediction_page/prediction_page.dart';
import 'package:mellotippet/prediction/semifinal_prediction_controller.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';

class SemifinalPredictionPage extends ConsumerStatefulWidget {
  const SemifinalPredictionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SemifinalPredictionPageState();
}

class _SemifinalPredictionPageState
    extends ConsumerState<SemifinalPredictionPage> {
  SemifinalPredictionController get controller =>
      ref.read(SemifinalPredictionController.provider.notifier);

  @override
  Widget build(BuildContext context) {
    return PredictionPage(
      snackbarHandler: getIt.get<SnackbarHandler>(),
      emptyTopListText: 'Dra två bidrag ovanför linjen för att tippa',
      controller: controller,
    );
  }
}
