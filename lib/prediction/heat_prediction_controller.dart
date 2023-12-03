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

  void fetchSongs() async {
    final songs = await databaseRepository.getSongs('heat1');

    final others = songs
        .map((song) => PredictionRow(
              artist: song.artist,
              song: song.song,
              imageAsset: 'assets/images/${song.image}',
              startNumber: song.startNumber,
            ))
        .toList();

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

    final ctaDisabled = predictions.any((prediction) => prediction == null);

    state = state.copyWith(
      predictions: predictions,
      others: others,
      ctaEnabled: !ctaDisabled,
    );
  }

  void clearRow(int index) {
    final predictions = [...state.predictions];
    predictions[index] = null;

    state = state.copyWith(predictions: predictions);
  }

  Future<bool> submitPrediction() {
    var finalist1 = state.predictions[0]?.startNumber;
    var finalist2 = state.predictions[1]?.startNumber;
    var semifinalist1 = state.predictions[2]?.startNumber;
    var semifinalist2 = state.predictions[3]?.startNumber;
    var fifthPlace = state.predictions[4]?.startNumber;

    if (finalist1 == null ||
        finalist2 == null ||
        semifinalist1 == null ||
        semifinalist2 == null ||
        fifthPlace == null) {
      return Future.value(false);
    }

    var prediction = HeatPredictionModel(
      finalist1: PredictionAndScore(prediction: finalist1),
      finalist2: PredictionAndScore(prediction: finalist2),
      semifinalist1: PredictionAndScore(prediction: semifinalist1),
      semifinalist2: PredictionAndScore(prediction: semifinalist2),
      fifthPlace: PredictionAndScore(prediction: fifthPlace),
    );

    return databaseRepository.uploadHeatPrediction(
      state.currentCompetition,
      prediction,
    );
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
    @Default(false) bool ctaEnabled,
  }) = _HeatPredictionControllerState;
}
