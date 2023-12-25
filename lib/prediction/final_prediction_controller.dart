import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/service_location/get_it.dart';

part 'final_prediction_controller.freezed.dart';

class FinalPredictionController
    extends StateNotifier<FinalPredictionControllerState> {
  FinalPredictionController({
    required this.databaseRepository,
    required this.featureFlagRepository,
    required FinalPredictionControllerState state,
  }) : super(state);

  final DatabaseRepository databaseRepository;
  final FeatureFlagRepository featureFlagRepository;

  static final provider = StateNotifierProvider<FinalPredictionController,
      FinalPredictionControllerState>(
    (ref) => FinalPredictionController(
      databaseRepository: getIt.get<DatabaseRepository>(),
      featureFlagRepository: getIt.get<FeatureFlagRepository>(),
      state: const FinalPredictionControllerState(loading: true),
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

  void setPlacement1(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement1: PredictionAndScore(prediction: int.parse(value))));
  }

  void setPlacement2(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement2: PredictionAndScore(prediction: int.parse(value))));
  }

  void setPlacement3(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement3: PredictionAndScore(prediction: int.parse(value))));
  }

  void setPlacement4(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement4: PredictionAndScore(prediction: int.parse(value))));
  }

  void setPlacement5(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement5: PredictionAndScore(prediction: int.parse(value))));
  }

  void setPlacement6(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement6: PredictionAndScore(prediction: int.parse(value))));
  }

  void setPlacement7(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement7: PredictionAndScore(prediction: int.parse(value))));
  }

  void setPlacement8(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement8: PredictionAndScore(prediction: int.parse(value))));
  }

  void setPlacement9(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement9: PredictionAndScore(prediction: int.parse(value))));
  }

  void setPlacement10(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement10: PredictionAndScore(prediction: int.parse(value))));
  }

  void setPlacement11(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement11: PredictionAndScore(prediction: int.parse(value))));
  }

  void setPlacement12(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction?.copyWith(
            placement12: PredictionAndScore(prediction: int.parse(value))));
  }

  Future<bool> submitPrediction() {
    var prediction = state.prediction;
    if (prediction == null) {
      return Future.value(false);
    }

    return databaseRepository.uploadFinalPrediction(
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
      prediction.placement1.prediction,
      prediction.placement2.prediction,
      prediction.placement3.prediction,
      prediction.placement4.prediction,
      prediction.placement5.prediction,
      prediction.placement6.prediction,
      prediction.placement7.prediction,
      prediction.placement8.prediction,
      prediction.placement9.prediction,
      prediction.placement10.prediction,
      prediction.placement11.prediction,
      prediction.placement12.prediction,
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
class FinalPredictionControllerState with _$FinalPredictionControllerState {
  const factory FinalPredictionControllerState({
    @Default(false) bool loading,
    @Default("") String username,
    @Default("") String currentCompetition,
    FinalPredictionModel? prediction,
  }) = _FinalPredictionControllerState;
}
