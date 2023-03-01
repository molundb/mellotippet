import 'package:melodifestivalen_competition/common/models/models.dart';

int calculateScore(CompetitionModel competition, HeatPredictionModel? prediction) {
  if (prediction == null) {
    return competition.lowestScore -1;
  }

  return _calculateScoreWithResult(competition.result, prediction);
}

int _calculateScoreWithResult(HeatPredictionModel result, HeatPredictionModel prediction) {
  var score = 0;

  score += calculateFinalistScore(result.finalist1, prediction);
  score += calculateFinalistScore(result.finalist2, prediction);
  score += calculateSemifinalistScore(result.semifinalist1, prediction);
  score += calculateSemifinalistScore(result.semifinalist2, prediction);

  return score;
}

int calculateFinalistScore(
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

int calculateSemifinalistScore(
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
