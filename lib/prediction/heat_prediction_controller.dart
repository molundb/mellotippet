import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/service_location/get_it.dart';

part 'heat_prediction_controller.freezed.dart';

class HeatPredictionController
    extends StateNotifier<HeatPredictionControllerState> {
  HeatPredictionController({
    required this.databaseRepository,
    required this.featureFlagRepository,
    required HeatPredictionControllerState state,
  }) : super(state);

  final DatabaseRepository databaseRepository;
  final FeatureFlagRepository featureFlagRepository;

  static final provider = StateNotifierProvider<HeatPredictionController,
      HeatPredictionControllerState>(
    (ref) => HeatPredictionController(
      databaseRepository: getIt.get<DatabaseRepository>(),
      featureFlagRepository: getIt.get<FeatureFlagRepository>(),
      state: const HeatPredictionControllerState(loading: true),
    ),
  );

  Future<void> getUsernameAndCurrentCompetition() async {
    state = state.copyWith(loading: true);
    final username = await databaseRepository.getCurrentUsername();
    final currentCompetition = featureFlagRepository.getCurrentCompetition();
    state = state.copyWith(
      loading: false,
      username: username,
      currentCompetition: currentCompetition,
    );
  }

  void setOthers() {
    final others = List<PredictionRow>.generate(
        6,
        (int index) => PredictionRow(
              // key: Key('$index'),
              startNumber: index + 1,
            ));

    state = state.copyWith(others: others);
  }

  void setFinalist1(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            finalist1: PredictionAndScore(prediction: int.parse(value))));
  }

  void setFinalist2(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            finalist2: PredictionAndScore(prediction: int.parse(value))));
  }

  void setSemifinalist1(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            semifinalist1: PredictionAndScore(prediction: int.parse(value))));
  }

  void setSemifinalist2(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            semifinalist2: PredictionAndScore(prediction: int.parse(value))));
  }

  void setFifthPlace(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            fifthPlace: PredictionAndScore(prediction: int.parse(value))));
  }

  void setRow(PredictionRow? prediction, int index) {
    final predictions = [...state.predictions];
    final others = [...state.others];

    others.remove(prediction);

    final previous = predictions[index];
    if (previous != null) {
      others.add(previous);
    }

    predictions[index] = prediction;

    state = state.copyWith(predictions: predictions, others: others);
  }

  void clearRow(int index) {
    final predictions = [...state.predictions];
    predictions[index] = null;

    state = state.copyWith(predictions: predictions);
  }

  Future<bool> submitPrediction() {
    var prediction = state.prediction;
    if (prediction == null) {
      return Future.value(false);
    }

    return databaseRepository.uploadHeatPrediction(
      state.currentCompetition,
      prediction,
    );
  }

  String? validatePredictionInput(String? prediction) {
    if (prediction == null || prediction.isEmpty) {
      return 'Prediction can not be empty';
    }

    if (prediction.length > 2) {
      return 'Prediction is too long';
    }

    if (!_isNumeric(prediction)) {
      return 'Prediction is not a number';
    }

    if (int.tryParse(prediction)! < 1 || int.tryParse(prediction)! > 12) {
      return 'Prediction must be between 1 and 12';
    }

    return null;
  }

  bool _isNumeric(String s) => int.tryParse(s) != null;

  bool duplicatePredictions() {
    var prediction = state.prediction;
    if (prediction == null) {
      return false;
    }

    var duplicate = false;

    final List<int> predictions = [
      prediction.finalist1.prediction,
      prediction.finalist2.prediction,
      prediction.semifinalist1.prediction,
      prediction.semifinalist2.prediction,
      prediction.fifthPlace.prediction,
    ];

    List<int> tempPredictions = [];
    for (var element in predictions) {
      if (tempPredictions.contains(element)) {
        duplicate = true;
        break;
      } else {
        tempPredictions.add(element);
      }
    }

    return duplicate;
  }
}

@freezed
class HeatPredictionControllerState with _$HeatPredictionControllerState {
  const factory HeatPredictionControllerState({
    @Default(false) bool loading,
    @Default("") String username,
    @Default("") String currentCompetition,
    HeatPredictionModel? prediction,
    @Default([null, null, null, null, null]) List<PredictionRow?> predictions,
    @Default([]) List<PredictionRow> others,
  }) = _HeatPredictionControllerState;
}
