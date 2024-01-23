import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';

part 'prediction_controller.freezed.dart';

abstract class PredictionController
    extends StateNotifier<PredictionControllerState> {
  PredictionController({
    required PredictionControllerState state,
  }) : super(state);

  StateNotifierProvider<PredictionController, PredictionControllerState>
      getStateNotifier();

  fetchSongs();

  onItemReorder(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  );

  Future<bool> submitPrediction();
}

@Freezed(makeCollectionsUnmodifiable: false)
class PredictionControllerState with _$PredictionControllerState {
  const factory PredictionControllerState({
    @Default(false) bool loading,
    @Default([[], []]) List<List<PredictionRow>> songLists,
    @Default(false) bool ctaEnabled,
  }) = _PredictionControllerState;
}
