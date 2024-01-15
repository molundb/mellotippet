import 'package:collection/collection.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
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

  void fetchSongs() async {
    final songs = await databaseRepository.getSongs('heat1');

    final predictionRows = songs
        .map((song) => PredictionRow(
              artist: song.artist,
              song: song.song,
              imageAsset: 'assets/images/${song.image}',
              startNumber: song.startNumber,
            ))
        .toList();

    final songLists = [...state.songLists];
    songLists[0] = [];
    songLists[1] = predictionRows;
    state = state.copyWith(songLists: songLists);
  }

  //
  // void setFinalist1(String? value) {
  //   if (value == null || value.isEmpty) return;
  //
  //   state = state.copyWith(
  //       prediction: state.prediction?.copyWith(
  //           finalist1: PredictionAndScore(prediction: int.parse(value))));
  // }
  //
  // void setFinalist2(String? value) {
  //   if (value == null || value.isEmpty) return;
  //
  //   state = state.copyWith(
  //       prediction: state.prediction?.copyWith(
  //           finalist2: PredictionAndScore(prediction: int.parse(value))));
  // }
  //
  // void setSemifinalist1(String? value) {
  //   if (value == null || value.isEmpty) return;
  //
  //   state = state.copyWith(
  //       prediction: state.prediction?.copyWith(
  //           semifinalist1: PredictionAndScore(prediction: int.parse(value))));
  // }
  //
  // void setSemifinalist2(String? value) {
  //   if (value == null || value.isEmpty) return;
  //
  //   state = state.copyWith(
  //       prediction: state.prediction?.copyWith(
  //           semifinalist2: PredictionAndScore(prediction: int.parse(value))));
  // }
  //
  // void setFifthPlace(String? value) {
  //   if (value == null || value.isEmpty) return;
  //
  //   state = state.copyWith(
  //       prediction: state.prediction?.copyWith(
  //           fifthPlace: PredictionAndScore(prediction: int.parse(value))));
  // }
  //
  // void setRow(PredictionRow? prediction, int index) {
  //   final predictions = [...state.predictions];
  //   final others = [...state.others];
  //
  //   others.remove(prediction);
  //
  //   final previous = predictions[index];
  //   if (previous != null) {
  //     others.add(previous);
  //   }
  //
  //   predictions[index] = prediction;
  //
  //   final ctaDisabled = predictions.any((prediction) => prediction == null);
  //
  //   state = state.copyWith(
  //     predictions: predictions,
  //     others: others,
  //     ctaEnabled: !ctaDisabled,
  //   );
  // }
  //
  // void clearRow(int index) {
  //   final predictions = [...state.predictions];
  //   predictions[index] = null;
  //
  //   state = state.copyWith(predictions: predictions);
  // }

  onItemReorder(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    final songLists = [...state.songLists];
    final movedItem = songLists[oldListIndex].removeAt(oldItemIndex);
    songLists[newListIndex].insert(newItemIndex, movedItem);

    songLists[0] = songLists[0].mapIndexed((index, element) {
      switch (index) {
        case < 2:
          element =
              element.copyWithPredictionPosition(PredictedPosition.finalist);
        case < 4:
          element = element
              .copyWithPredictionPosition(PredictedPosition.semifinalist);
        case == 4:
          element =
              element.copyWithPredictionPosition(PredictedPosition.fifthPlace);
        default:
          element =
              element.copyWithPredictionPosition(PredictedPosition.notPlaced);
      }

      return element;
    }).toList();

    final ctaEnabled = songLists[0].length >= 5;
    state = state.copyWith(songLists: songLists, ctaEnabled: ctaEnabled);
  }

  Future<bool> submitPrediction() {
    final finalist1 = state.songLists[0][0].startNumber;
    final finalist2 = state.songLists[0][1].startNumber;
    final semifinalist1 = state.songLists[0][2].startNumber;
    final semifinalist2 = state.songLists[0][3].startNumber;
    final fifthPlace = state.songLists[0][4].startNumber;

    var prediction = HeatPredictionModel(
      finalist1: PredictionAndScore(prediction: finalist1),
      finalist2: PredictionAndScore(prediction: finalist2),
      semifinalist1: PredictionAndScore(prediction: semifinalist1),
      semifinalist2: PredictionAndScore(prediction: semifinalist2),
      fifthPlace: PredictionAndScore(prediction: fifthPlace),
    );

    return databaseRepository.uploadHeatPrediction(
      featureFlagRepository.getCurrentCompetition(),
      prediction,
    );
  }
}

@Freezed(makeCollectionsUnmodifiable: false)
class HeatPredictionControllerState with _$HeatPredictionControllerState {
  const factory HeatPredictionControllerState({
    @Default(false) bool loading,
    HeatPredictionModel? prediction,
    @Default([[], []]) List<List<PredictionRow>> songLists,
    @Default(false) bool ctaEnabled,
  }) = _HeatPredictionControllerState;
}
