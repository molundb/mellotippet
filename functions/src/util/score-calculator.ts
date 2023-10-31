import { HeatResult } from "../models/heat-result";
import { HeatPredictionAndScore } from "../models/heat-prediction";
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
      let placement = i + 1;
      let startNumber = result.toList()[i];
      let predictedPlacement = prediction.toList().indexOf(startNumber) + 1;

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

  calculateHeatScore(
    result: HeatResult,
    predictionAndScore: HeatPredictionAndScore,
  ): HeatPredictionAndScore {

    predictionAndScore.finalist1.score += this.calculateScoreForHeatFinalist(
      result.finalist1,
      predictionAndScore
    );
    predictionAndScore.finalist2.score += this.calculateScoreForHeatFinalist(
      result.finalist2,
      predictionAndScore
    );
    predictionAndScore.semifinalist1.score += this.calculateScoreForHeatSemifinalist(
      result.semifinalist1,
      predictionAndScore
    );
    predictionAndScore.semifinalist2.score += this.calculateScoreForHeatSemifinalist(
      result.semifinalist2,
      predictionAndScore
    );

    return predictionAndScore;
  }

  private calculateScoreForHeatFinalist(
    finalist: number,
    predictionAndScore: HeatPredictionAndScore
  ): number {
    var score = 0;

    if (predictionAndScore.finalistPredictions().includes(finalist)) {
      score = 5;
    } else if (
      predictionAndScore.semifinalistPredictions().includes(finalist)
    ) {
      score = 3;
    } else if (finalist == predictionAndScore.fifthPlace.prediction) {
      score = 1;
    }

    return score;
  }

  private calculateScoreForHeatSemifinalist(
    semifinalist: number,
    predictionAndScore: HeatPredictionAndScore
  ): number {
    var score = 0;

    if (predictionAndScore.finalistPredictions().includes(semifinalist)) {
      score = 1;
    } else if (
      predictionAndScore.semifinalistPredictions().includes(semifinalist)
    ) {
      score = 2;
    } else if (semifinalist == predictionAndScore.fifthPlace.prediction) {
      score = 1;
    }

    return score;
  }
}

export { ScoreCalculator };
