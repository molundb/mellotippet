import { HeatResult } from "../models/heat-result";
import { HeatPrediction } from "../models/heat-prediction";
import SemifinalPrediction from "../models/semifinal-prediction";
import SemifinalResult from "../models/semifinal-result";
import FinalPredictionOrResult from "../models/final-prediction-or-result";

class ScoreCalculator {
  calculateFinalScore(
    result: FinalPredictionOrResult,
    prediction: FinalPredictionOrResult
  ) {
    var score = 0;

    for (let i = 0; i < result.toList().length; i++) {
      let placement = i+1;
      let startNumber = result.toList()[i];
      let predictedPlacement = prediction.toList().indexOf(startNumber)+1;

      if (predictedPlacement != -1) {
        score += this.calculateScoreForFinalPlacement(
          placement,
          predictedPlacement
        );
      }
    }

    return score;
  }

  private calculateScoreForFinalPlacement(
    placement: number,
    predictedPlacement: number
  ) {
    if (placement <= 4) {
      return Math.max(0, 5 - Math.abs(placement - predictedPlacement));
    } else if (placement <= 8) {
      return Math.max(0, 3 - Math.abs(placement - predictedPlacement));
    } else {
      return Math.max(0, 2 - Math.abs(placement - predictedPlacement));
    }
  }

  calculateSemifinalScore(
    result: SemifinalResult,
    prediction: SemifinalPrediction
  ) {
    var score = 0;

    score += this.calculateScoreForSemifinalFinalist(
      result.finalist1,
      prediction
    );
    score += this.calculateScoreForSemifinalFinalist(
      result.finalist2,
      prediction
    );

    return score;
  }

  private calculateScoreForSemifinalFinalist(
    finalist: number,
    prediction: SemifinalPrediction
  ) {
    if (prediction.toList().includes(finalist)) {
      return 3;
    } else {
      return 0;
    }
  }

  calculateHeatScore(result: HeatResult, prediction: HeatPrediction) {
    var score = 0;

    score += this.calculateScoreForHeatFinalist(result.finalist1, prediction);
    score += this.calculateScoreForHeatFinalist(result.finalist2, prediction);
    score += this.calculateScoreForHeatSemifinalist(
      result.semifinalist1,
      prediction
    );
    score += this.calculateScoreForHeatSemifinalist(
      result.semifinalist2,
      prediction
    );

    return score;
  }

  private calculateScoreForHeatFinalist(
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

  private calculateScoreForHeatSemifinalist(
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
}

export { ScoreCalculator };
