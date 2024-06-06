import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/prediction/prediction_page/prediction_controller.dart';

class SemifinalPredictionController extends PredictionController {
  SemifinalPredictionController() : super.internal();

  static final provider = NotifierProvider<SemifinalPredictionController,
      PredictionControllerState>(
    () => SemifinalPredictionController(),
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
        default:
          return element
              .copyWithPredictionPosition(PredictedPosition.notPlaced());
      }
    }).toList();

    songLists[1] = songLists[1]
        .map((e) => e.copyWithPredictionPosition(PredictedPosition.notPlaced()))
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
