import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/database_repository.dart';
import 'package:mellotippet/common/repositories/feature_flag_repository.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'prediction_controller.freezed.dart';
part 'prediction_controller.g.dart';

@Riverpod(keepAlive: true)
class PredictionController extends _$PredictionController {
  PredictionController.internal();

  final DatabaseRepository databaseRepository = getIt.get<DatabaseRepository>();
  final FeatureFlagRepository featureFlagRepository =
      getIt.get<FeatureFlagRepository>();

  @override
  PredictionControllerState build() => const PredictionControllerState();

  factory PredictionController() {
    throw UnimplementedError();
  }

  NotifierProvider<_$PredictionController, PredictionControllerState>
      getNotifier() {
    throw UnimplementedError();
  }

  fetchSongs(BuildContext context) async {
    final currentCompetition = featureFlagRepository.getCurrentCompetition();
    final songs = await databaseRepository.getSongs(currentCompetition);

    final predictionRows = await Future.wait(songs.map((song) async {
      String? imageUrl = await databaseRepository.getImageDownloadUrl(
        DateTime.now().year,
        currentCompetition,
        song.image,
      );

      if (imageUrl != null && context.mounted) {
        precacheImage(NetworkImage(imageUrl), context);
      }

      return PredictionRow(
        artist: song.artist,
        song: song.song,
        imageUrl: imageUrl,
        startNumber: song.startNumber,
        prediction: PredictedPosition.notPlaced(),
      );
    }));

    predictionRows.sort((a, b) => a.startNumber.compareTo(b.startNumber));

    final songLists = [...state.songLists];
    songLists[0] = [];
    songLists[1] = predictionRows;
    state = state.copyWith(songLists: songLists);
  }

  onItemReorder(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,) {
    throw UnimplementedError();
  }

  Future<bool> submitPrediction() {
    throw UnimplementedError();
  }
}

@Freezed(makeCollectionsUnmodifiable: false)
class PredictionControllerState with _$PredictionControllerState {
  const factory PredictionControllerState({
    @Default(false) bool loading,
    @Default([[], []]) List<List<PredictionRow>> songLists,
    @Default(false) bool ctaEnabled,
  }) = _PredictionControllerState;
}
