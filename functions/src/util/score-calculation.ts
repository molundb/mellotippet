import { HeatPrediction } from "../models/heat-prediction";

function calculateHeatFinalistScore(
  finalist: number,
  prediction: HeatPrediction
): number {
  var score = 0;

  if (finalist == prediction.finalist1 || finalist == prediction.finalist2) {
    score = 5;
  } else if (
    finalist == prediction.semifinalist1 ||
    finalist == prediction.semifinalist2
  ) {
    score = 3;
  } else if (finalist == prediction.fifthPlace) {
    score = 1;
  }

  return score;
}

function calculateHeatSemifinalistScore(
  semifinalist: number,
  prediction: HeatPrediction
): number {
  var score = 0;

  if (
    semifinalist == prediction.finalist1 ||
    semifinalist == prediction.finalist2
  ) {
    score = 1;
  } else if (
    semifinalist == prediction.semifinalist1 ||
    semifinalist == prediction.semifinalist2
  ) {
    score = 2;
  } else if (semifinalist == prediction.fifthPlace) {
    score = 1;
  }

  return score;
}

export { calculateHeatFinalistScore, calculateHeatSemifinalistScore };
