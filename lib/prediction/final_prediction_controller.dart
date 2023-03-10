import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';

class FinalPredictionController extends StateNotifier<FinalPredictionControllerState> {
  FinalPredictionController({
    required this.databaseRepository,
    required this.featureFlagRepository,
    FinalPredictionControllerState? state,
  }) : super(state ?? FinalPredictionControllerState.withDefaults());

  final DatabaseRepository databaseRepository;
  final FeatureFlagRepository featureFlagRepository;

  static final provider =
      StateNotifierProvider<FinalPredictionController, FinalPredictionControllerState>(
          (ref) => FinalPredictionController(
                databaseRepository: getIt.get<DatabaseRepository>(),
                featureFlagRepository: getIt.get<FeatureFlagRepository>(),
              ));

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

  void setPosition1(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position1: int.parse(value)));
  }

  void setPosition2(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position2: int.parse(value)));
  }

  void setPosition3(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position3: int.parse(value)));
  }

  void setPosition4(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position4: int.parse(value)));
  }

  void setPosition5(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position5: int.parse(value)));
  }

  void setPosition6(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position6: int.parse(value)));
  }

  void setPosition7(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position7: int.parse(value)));
  }

  void setPosition8(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position8: int.parse(value)));
  }

  void setPosition9(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position9: int.parse(value)));
  }

  void setPosition10(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position10: int.parse(value)));
  }

  void setPosition11(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position11: int.parse(value)));
  }

  void setPosition12(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(position12: int.parse(value)));
  }

  Future<bool> submitPrediction() => databaseRepository.uploadFinalPrediction(
        state.currentCompetition,
        state.prediction,
      );

  String? validatePredictionInput(String? prediction) {
    if (prediction == null || prediction.isEmpty) {
      return 'Prediction can not be empty';
    }

    if (prediction.length > 1) {
      return 'Prediction is too long';
    }

    if (!_isNumeric(prediction)) {
      return 'Prediction is not a number';
    }

    if (int.tryParse(prediction)! < 1 || int.tryParse(prediction)! > 8) {
      return 'Prediction must be between 1 and 8';
    }

    return null;
  }

  bool _isNumeric(String s) => int.tryParse(s) != null;

  bool duplicatePredictions() {
    var duplicate = false;

    final List<int> predictions = [
      state.prediction.position1!,
      state.prediction.position2!,
      state.prediction.position3!,
      state.prediction.position4!,
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

@immutable
class FinalPredictionControllerState {
  const FinalPredictionControllerState({
    this.loading = false,
    this.username = "",
    this.currentCompetition = "",
    required this.prediction,
  });

  final bool loading;
  final String username;
  final String currentCompetition;
  final FinalPredictionModel prediction;

  FinalPredictionControllerState copyWith({
    bool? loading,
    String? username,
    String? currentCompetition,
    FinalPredictionModel? prediction,
  }) {
    return FinalPredictionControllerState(
      loading: loading ?? this.loading,
      username: username ?? this.username,
      currentCompetition: currentCompetition ?? this.currentCompetition,
      prediction: prediction ?? this.prediction,
    );
  }

  factory FinalPredictionControllerState.withDefaults() => FinalPredictionControllerState(
        prediction: FinalPredictionModel(),
      );
}
