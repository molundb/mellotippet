import 'package:collection/collection.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/prediction/prediction_page/prediction_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class HeatPredictionController extends PredictionController {
  HeatPredictionController() : super.internal();

  static final provider =
      NotifierProvider<HeatPredictionController, PredictionControllerState>(
    () => HeatPredictionController(),
  );

  @override
  getNotifier() {
    return provider;
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
          return element
              .copyWithPredictionPosition(PredictedPosition.finalist());
        case < 4:
          return element
              .copyWithPredictionPosition(PredictedPosition.semifinalist());
        case == 4:
          return element
              .copyWithPredictionPosition(PredictedPosition.fifthPlace());
        default:
          return element
              .copyWithPredictionPosition(PredictedPosition.notPlaced());
      }
    }).toList();

    songLists[1] = songLists[1]
        .map((e) => e.copyWithPredictionPosition(PredictedPosition.notPlaced()))
        .toList();

    final ctaEnabled = songLists[0].length >= 5;
    state = state.copyWith(songLists: songLists, ctaEnabled: ctaEnabled);
  }

  @override
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
