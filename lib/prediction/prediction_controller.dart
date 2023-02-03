import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';

class PredictionController extends StateNotifier<PredictionControllerState> {
  static final provider =
      StateNotifierProvider<PredictionController, PredictionControllerState>(
          (ref) => PredictionController());

  final DatabaseRepository _databaseRepository =
      getIt.get<DatabaseRepository>();

  PredictionController({PredictionControllerState? state})
      : super(state ?? const PredictionControllerState());

  Future<void> getUsername() async {
    state = state.copyWith(loading: true);
    final username = await _databaseRepository.getCurrentUsername();
    state = state.copyWith(loading: false, username: username);
  }

  void setFinalist1(String? value) {
    state = state.copyWith(
        prediction: state.prediction?.copyWith(finalist1: value));
  }

  void setFinalist2(String? value) {
    state = state.copyWith(
        prediction: state.prediction?.copyWith(finalist2: value));
  }

  void setSemifinalist1(String? value) {
    state = state.copyWith(
        prediction: state.prediction?.copyWith(semifinalist1: value));
  }

  void setSemifinalist2(String? value) {
    state = state.copyWith(
        prediction: state.prediction?.copyWith(semifinalist2: value));
  }

  void setFifthPlace(String? value) {
    state = state.copyWith(
        prediction: state.prediction?.copyWith(fifthPlace: value));
  }

  void submitPrediction() {
    _databaseRepository.uploadPrediction(state.prediction!);
  }
}

@immutable
class PredictionControllerState {
  const PredictionControllerState({
    this.loading = false,
    this.username = "",
    this.prediction,
  });

  final bool loading;
  final String username;
  final PredictionModel? prediction;

  PredictionControllerState copyWith({
    bool? loading,
    String? username,
    PredictionModel? prediction,
  }) {
    return PredictionControllerState(
      loading: loading ?? this.loading,
      username: username ?? this.username,
      prediction: prediction ?? this.prediction,
    );
  }
}
