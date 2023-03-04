import 'package:melodifestivalen_competition/common/models/models.dart';

int calculateScore(CompetitionModel competition, PredictionModel? prediction) {
  if (prediction == null) {
    return competition.lowestScore - 1;
  }

  int score = 0;

  switch (competition.type) {
    case CompetitionType.theFinal:
      break;
    case CompetitionType.semifinal:
      score = _calculateSemifinalScore(
        competition.result as SemifinalPredictionModel,
        prediction as SemifinalPredictionModel,
      );
      break;
    case CompetitionType.heat:
      score = _calculateHeatScore(
        competition.result as HeatPredictionModel,
        prediction as HeatPredictionModel,
      );
      break;
  }

  return score;
}

int _calculateHeatScore(
  HeatPredictionModel result,
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

  if (finalist == prediction.finalist1 || finalist == prediction.finalist2) {
    score = 5;
  } else if (finalist == prediction.semifinalist1 ||
      finalist == prediction.semifinalist2) {
    score = 3;
  } else if (finalist == prediction.fifthPlace) {
    score = 1;
  }
  return score;
}

int calculateHeatSemifinalistScore(
  int? semifinalist,
  HeatPredictionModel prediction,
) {
  var score = 0;

  if (semifinalist == prediction.finalist1 ||
      semifinalist == prediction.finalist2) {
    score = 1;
  } else if (semifinalist == prediction.semifinalist1 ||
      semifinalist == prediction.semifinalist2) {
    score = 2;
  } else if (semifinalist == prediction.fifthPlace) {
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
    prediction.finalist1,
    prediction.finalist2,
    prediction.finalist3,
    prediction.finalist4,
  ];

  score += calculateSemifinalFinalistScore(result.finalist1, predictions);
  score += calculateSemifinalFinalistScore(result.finalist2, predictions);
  score += calculateSemifinalFinalistScore(result.finalist3, predictions);
  score += calculateSemifinalFinalistScore(result.finalist4, predictions);

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
