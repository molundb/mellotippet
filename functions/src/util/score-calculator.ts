import { HeatResult } from "../models/heat-result";
import { HeatPredictionAndScore } from "../models/heat-prediction-and-score";
import { FinalkvalPredictionAndScore } from "../models/finalkval-prediction-and-score";
import { FinalkvalResult } from "../models/finalkval-result";
import { FinalPredictionAndScore } from "../models/final-prediction-and-score";
import { FinalResult } from "../models/final-result";

class ScoreCalculator {
  calculateFinalScore(
    result: FinalResult,
    predictionAndScores: FinalPredictionAndScore
  ): FinalPredictionAndScore {
    for (let i = 0; i < result.toList().length; i++) {
      const placement = i + 1;
      const songStartNumber = result.toList()[i];
      const predictedPlacement = predictionAndScores
        .toList()
        .findIndex((i) => i.prediction == songStartNumber);
      const predictionAndScore = predictionAndScores.toList()[predictedPlacement];

      if (predictionAndScore != undefined) {
        predictionAndScore.score = this.calculateScoreForFinalPlacement(
          placement,
          predictedPlacement + 1
        );
      }
    }

    return predictionAndScores;
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

  calculateFinalkvalScore(
    result: FinalkvalResult,
    predictionAndScore: FinalkvalPredictionAndScore
  ): FinalkvalPredictionAndScore {
    predictionAndScore.finalist1.score =
      this.calculateScoreForFinalkvalFinalist(
        predictionAndScore.finalist1.prediction,
        result
      );
    predictionAndScore.finalist2.score =
      this.calculateScoreForFinalkvalFinalist(
        predictionAndScore.finalist2.prediction,
        result
      );

    return predictionAndScore;
  }

  private calculateScoreForFinalkvalFinalist(
    prediction: number,
    result: FinalkvalResult
  ) {
    if (result.finalists().includes(prediction)) {
      return 3;
    } else {
      return 0;
    }
  }

  calculateHeatScore(
    result: HeatResult,
    predictionAndScore: HeatPredictionAndScore
  ): HeatPredictionAndScore {
    predictionAndScore.finalist1.score =
      this.calculateScoreForHeatFinalistPrediction(
        predictionAndScore.finalist1.prediction,
        result
      );
    predictionAndScore.finalist2.score =
      this.calculateScoreForHeatFinalistPrediction(
        predictionAndScore.finalist2.prediction,
        result
      );
    predictionAndScore.semifinalist1.score =
      this.calculateScoreForHeatSemifinalistPrediction(
        predictionAndScore.semifinalist1.prediction,
        result
      );
    predictionAndScore.semifinalist2.score =
      this.calculateScoreForHeatSemifinalistPrediction(
        predictionAndScore.semifinalist2.prediction,
        result
      );
    predictionAndScore.fifthPlace.score =
      this.calculateScoreForHeatFifthPlacePrediction(
        predictionAndScore.fifthPlace.prediction,
        result
      );

    return predictionAndScore;
  }

  private calculateScoreForHeatFinalistPrediction(
    prediction: number,
    result: HeatResult
  ): number {
    let score = 0;

    if (result.finalists().includes(prediction)) {
      score = 5;
    } else if (result.semifinalists().includes(prediction)) {
      score = 1;
    }

    return score;
  }

  private calculateScoreForHeatSemifinalistPrediction(
    prediction: number,
    result: HeatResult
  ): number {
    let score = 0;

    if (result.finalists().includes(prediction)) {
      score = 3;
    } else if (result.semifinalists().includes(prediction)) {
      score = 2;
    }

    return score;
  }

  private calculateScoreForHeatFifthPlacePrediction(
    prediction: number,
    result: HeatResult
  ): number {
    let score = 0;

    if (result.finalists().includes(prediction)) {
      score = 1;
    } else if (result.semifinalists().includes(prediction)) {
      score = 1;
    }

    return score;
  }
}

export { ScoreCalculator };
