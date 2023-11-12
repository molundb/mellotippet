import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/dependency_injection/get_it.dart';

class SemifinalPredictionController
    extends StateNotifier<SemifinalPredictionControllerState> {
  SemifinalPredictionController({
    required this.databaseRepository,
    required this.featureFlagRepository,
    SemifinalPredictionControllerState? state,
  }) : super(state ?? SemifinalPredictionControllerState.withDefaults());

  final DatabaseRepository databaseRepository;
  final FeatureFlagRepository featureFlagRepository;

  static final provider =
      StateNotifierProvider<SemifinalPredictionController, SemifinalPredictionControllerState>(
          (ref) => SemifinalPredictionController(
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

  void setFinalist1(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(finalist1: int.parse(value)));
  }

  void setFinalist2(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(finalist2: int.parse(value)));
  }

  void setFinalist3(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(finalist3: int.parse(value)));
  }

  void setFinalist4(String? value) {
    if (value == null || value.isEmpty) return;

    state = state.copyWith(
        prediction: state.prediction.copyWith(finalist4: int.parse(value)));
  }

  Future<bool> submitPrediction() => databaseRepository.uploadSemifinalPrediction(
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
      state.prediction.finalist1!,
      state.prediction.finalist2!,
      state.prediction.finalist3!,
      state.prediction.finalist4!,
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
class SemifinalPredictionControllerState {
  const SemifinalPredictionControllerState({
    this.loading = false,
    this.username = "",
    this.currentCompetition = "",
    required this.prediction,
  });

  final bool loading;
  final String username;
  final String currentCompetition;
  final SemifinalPredictionModel prediction;

  SemifinalPredictionControllerState copyWith({
    bool? loading,
    String? username,
    String? currentCompetition,
    SemifinalPredictionModel? prediction,
  }) {
    return SemifinalPredictionControllerState(
      loading: loading ?? this.loading,
      username: username ?? this.username,
      currentCompetition: currentCompetition ?? this.currentCompetition,
      prediction: prediction ?? this.prediction,
    );
  }

  factory SemifinalPredictionControllerState.withDefaults() => SemifinalPredictionControllerState(
        prediction: SemifinalPredictionModel(),
      );
}
