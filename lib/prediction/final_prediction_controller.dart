import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/prediction/prediction_page/prediction_controller.dart';
import 'package:mellotippet/service_location/get_it.dart';

part 'final_prediction_controller.freezed.dart';

class FinalPredictionController extends PredictionController {
  FinalPredictionController({
    required this.databaseRepository,
    required this.featureFlagRepository,
    required super.state,
  });

  final DatabaseRepository databaseRepository;
  final FeatureFlagRepository featureFlagRepository;

  static final provider = StateNotifierProvider<FinalPredictionController,
      PredictionControllerState>(
    (ref) => FinalPredictionController(
      databaseRepository: getIt.get<DatabaseRepository>(),
      featureFlagRepository: getIt.get<FeatureFlagRepository>(),
      state: const PredictionControllerState(loading: true),
    ),
  );

  @override
  getStateNotifier() {
    return provider;
  }

  @override
  fetchSongs() async {
    final songs = await databaseRepository.getSongs('final');

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

  @override
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
      element.copyWithPredictionPosition(PredictedPosition.finalist);
      return element;
    }).toList();

    songLists[1] = songLists[1]
        .map((e) => e.copyWithPredictionPosition(PredictedPosition.notPlaced))
        .toList();

    final ctaEnabled = songLists[0].length >= 12;
    state = state.copyWith(songLists: songLists, ctaEnabled: ctaEnabled);
  }

  @override
  Future<bool> submitPrediction() {
    final placement1 = state.songLists[0][0].startNumber;
    final placement2 = state.songLists[0][1].startNumber;
    final placement3 = state.songLists[0][2].startNumber;
    final placement4 = state.songLists[0][3].startNumber;
    final placement5 = state.songLists[0][4].startNumber;
    final placement6 = state.songLists[0][5].startNumber;
    final placement7 = state.songLists[0][6].startNumber;
    final placement8 = state.songLists[0][7].startNumber;
    final placement9 = state.songLists[0][8].startNumber;
    final placement10 = state.songLists[0][9].startNumber;
    final placement11 = state.songLists[0][10].startNumber;
    final placement12 = state.songLists[0][11].startNumber;

    var prediction = FinalPredictionModel(
      placement1: PredictionAndScore(prediction: placement1),
      placement2: PredictionAndScore(prediction: placement2),
      placement3: PredictionAndScore(prediction: placement3),
      placement4: PredictionAndScore(prediction: placement4),
      placement5: PredictionAndScore(prediction: placement5),
      placement6: PredictionAndScore(prediction: placement6),
      placement7: PredictionAndScore(prediction: placement7),
      placement8: PredictionAndScore(prediction: placement8),
      placement9: PredictionAndScore(prediction: placement9),
      placement10: PredictionAndScore(prediction: placement10),
      placement11: PredictionAndScore(prediction: placement11),
      placement12: PredictionAndScore(prediction: placement12),
    );

    return databaseRepository.uploadFinalPrediction(
      featureFlagRepository.getCurrentCompetition(),
      prediction,
    );
  }
}
