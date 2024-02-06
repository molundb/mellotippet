import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:mellotippet/common/repositories/database_repository.dart';
import 'package:mellotippet/common/repositories/feature_flag_repository.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';

part 'prediction_controller.freezed.dart';

abstract class PredictionController
    extends StateNotifier<PredictionControllerState> {
  PredictionController({
    required this.databaseRepository,
    required this.featureFlagRepository,
    required PredictionControllerState state,
  }) : super(state);

  final DatabaseRepository databaseRepository;
  final FeatureFlagRepository featureFlagRepository;

  StateNotifierProvider<PredictionController, PredictionControllerState>
      getStateNotifier();

  fetchSongs() async {
    final songs = await databaseRepository
        .getSongs(featureFlagRepository.getCurrentCompetition());

    final predictionRows = await Future.wait(songs.map((song) async {
      String? imageUrl;
      if (song.image != null) {
        final storageRef = FirebaseStorage.instance.ref();

        final heat2Ref = storageRef.child("2024/heat2/${song.image}");

        try {
          imageUrl = await heat2Ref.getDownloadURL();
        } catch (e) {
          Logger().e("song.image: ${song.image}, e: $e");
        }
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
