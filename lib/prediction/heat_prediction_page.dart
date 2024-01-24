import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/prediction/heat_prediction_controller.dart';
import 'package:mellotippet/prediction/prediction_page/prediction_page.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';

class HeatPredictionPage extends ConsumerStatefulWidget {
  const HeatPredictionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HeatPredictionPageState();
}

class _HeatPredictionPageState extends ConsumerState<HeatPredictionPage> {
  HeatPredictionController get controller =>
      ref.read(HeatPredictionController.provider.notifier);

  @override
  Widget build(BuildContext context) {
    return PredictionPage(
      snackbarHandler: getIt.get<SnackbarHandler>(),
      emptyTopListText:
          'Dra fem bidrag ovanför linjen och rangordna för att tippa',
      controller: controller,
    );
  }
}
