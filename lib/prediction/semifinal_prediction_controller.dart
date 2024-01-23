import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/prediction/prediction_page/prediction_controller.dart';
import 'package:mellotippet/service_location/get_it.dart';

class SemifinalPredictionController extends PredictionController {
  SemifinalPredictionController({
    required this.databaseRepository,
    required this.featureFlagRepository,
    required super.state,
  });

  final DatabaseRepository databaseRepository;
  final FeatureFlagRepository featureFlagRepository;

  static final provider = StateNotifierProvider<SemifinalPredictionController,
      PredictionControllerState>(
    (ref) => SemifinalPredictionController(
      databaseRepository: getIt.get<DatabaseRepository>(),
      featureFlagRepository: getIt.get<FeatureFlagRepository>(),
      state: const PredictionControllerState(),
    ),
  );

  @override
  getStateNotifier() {
    return provider;
  }

  @override
  fetchSongs() async {
    final songs = await databaseRepository.getSongs('semifinal');

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
      switch (index) {
        case < 2:
          element =
              element.copyWithPredictionPosition(PredictedPosition.finalist);
        default:
          element =
              element.copyWithPredictionPosition(PredictedPosition.notPlaced);
      }

      return element;
    }).toList();

    songLists[1] = songLists[1]
        .map((e) => e.copyWithPredictionPosition(PredictedPosition.notPlaced))
        .toList();

    final ctaEnabled = songLists[0].length >= 2;
    state = state.copyWith(songLists: songLists, ctaEnabled: ctaEnabled);
  }

  @override
  Future<bool> submitPrediction() {
    final finalist1 = state.songLists[0][0].startNumber;
    final finalist2 = state.songLists[0][1].startNumber;

    var prediction = SemifinalPredictionModel(
      finalist1: PredictionAndScore(prediction: finalist1),
      finalist2: PredictionAndScore(prediction: finalist2),
    );

    return databaseRepository.uploadSemifinalPrediction(
      featureFlagRepository.getCurrentCompetition(),
      prediction,
    );
  }
}
