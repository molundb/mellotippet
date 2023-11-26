import 'dart:math';

import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/heat_result_model.dart';

int calculateScore(CompetitionModel competition, PredictionModel? prediction) {
  if (prediction == null) {
    return competition.lowestScore - 1;
  }

  int score = 0;

  switch (competition.type) {
    case CompetitionType.theFinal:
      score = _calculateFinalScore(
        competition.result as FinalPredictionModel,
        prediction as FinalPredictionModel,
      );
      break;
    case CompetitionType.semifinal:
      score = _calculateSemifinalScore(
        competition.result as SemifinalPredictionModel,
        prediction as SemifinalPredictionModel,
      );
      break;
    case CompetitionType.heat:
      score = _calculateHeatScore(
        competition.result as HeatResultModel,
        prediction as HeatPredictionModel,
      );
      break;
  }

  return score;
}

int _calculateHeatScore(
  HeatResultModel result,
  HeatPredictionModel prediction,
) {
  var score = 0;

  score += calculateHeatFinalistScore(result.finalist1, prediction);
  score += calculateHeatFinalistScore(result.finalist2, prediction);
  score += calculateHeatSemifinalistScore(result.semifinalist1, prediction);
  score += calculateHeatSemifinalistScore(result.semifinalist2, prediction);

  return score;
}

int calculateHeatFinalistScore(
  int? finalist,
  HeatPredictionModel prediction,
) {
  var score = 0;

  if (finalist == prediction.finalist1.prediction ||
      finalist == prediction.finalist2.prediction) {
    score = 5;
  } else if (finalist == prediction.semifinalist1.prediction ||
      finalist == prediction.semifinalist2.prediction) {
    score = 3;
  } else if (finalist == prediction.fifthPlace.prediction) {
    score = 1;
  }
  return score;
}

int calculateHeatSemifinalistScore(
  int? semifinalist,
  HeatPredictionModel prediction,
) {
  var score = 0;

  if (semifinalist == prediction.finalist1.prediction ||
      semifinalist == prediction.finalist2.prediction) {
    score = 1;
  } else if (semifinalist == prediction.semifinalist1.prediction ||
      semifinalist == prediction.semifinalist2.prediction) {
    score = 2;
  } else if (semifinalist == prediction.fifthPlace.prediction) {
    score = 1;
  }
  return score;
}

int _calculateSemifinalScore(
  SemifinalPredictionModel result,
  SemifinalPredictionModel prediction,
) {
  var score = 0;
  final predictions = [
    prediction.finalist1.prediction,
    prediction.finalist2.prediction,
  ];

  score +=
      calculateSemifinalFinalistScore(result.finalist1.prediction, predictions);
  score +=
      calculateSemifinalFinalistScore(result.finalist2.prediction, predictions);

  return score;
}

int calculateSemifinalFinalistScore(
  int? finalist,
  List<int?> predictions,
) {
  if (predictions.contains(finalist)) {
    return 2;
  } else {
    return 0;
  }
}

int _calculateFinalScore(
  FinalPredictionModel result,
  FinalPredictionModel prediction,
) {
  var score = 0;

  final from1to4Result = [
    result.placement1.prediction,
    result.placement2.prediction,
    result.placement3.prediction,
    result.placement4.prediction,
  ];

  final from5to8Result = [
    result.placement5.prediction,
    result.placement6.prediction,
    result.placement7.prediction,
    result.placement8.prediction,
  ];

  final from9to12Result = [
    result.placement9.prediction,
    result.placement10.prediction,
    result.placement11.prediction,
    result.placement12.prediction,
  ];

  final predictions = prediction.toList();

  score += _calculateFinalistGroupScore(
    5,
    1,
    from1to4Result,
    predictions,
  );
  score += _calculateFinalistGroupScore(
    3,
    5,
    from5to8Result,
    predictions,
  );
  score += _calculateFinalistGroupScore(
    2,
    9,
    from9to12Result,
    predictions,
  );

  return score;
}

int _calculateFinalistGroupScore(
  int maxScore,
  int groupStartPosition,
  List<int> finalistsOrdered,
  List<int> predictions,
) {
  var score = 0;

  for (var i = 0; i < finalistsOrdered.length; i++) {
    score += calculateFinalistScore(
      maxScore,
      groupStartPosition + i,
      finalistsOrdered[i],
      predictions,
    );
  }

  return score;
}

int calculateFinalistScore(
  int maxScore,
  int finalistPosition,
  int finalistStartingNumber,
  List<int> predictions,
) {
  var score = 0;

  var indexOf = predictions.indexOf(finalistStartingNumber) + 1;
  var i = (finalistPosition - indexOf);
  final distance = i.abs();
  score += max(0, maxScore - distance);

  return score;
}
