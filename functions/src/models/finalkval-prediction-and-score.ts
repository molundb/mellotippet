import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";
import { PredictionAndScore } from "./prediction-and-score";

export default class FinalkvalPredictionAndScore {
  finalist1: PredictionAndScore;
  finalist2: PredictionAndScore;

  constructor({
    finalist1,
    finalist2,
  }: {
    finalist1: PredictionAndScore;
    finalist2: PredictionAndScore;
  }) {
    this.finalist1 = finalist1;
    this.finalist2 = finalist2;
  }

  predictions() {
    return [this.finalist1.prediction, this.finalist2.prediction];
  }

  totalScore() {
    return this.finalist1.score + this.finalist2.score;
  }
}

const finalkvalPredictionAndScoreConverter = {
  toFirestore(finalkvalPrediction: FinalkvalPredictionAndScore): DocumentData {
    return {
      finalist1: finalkvalPrediction.finalist1.toJson(),
      finalist2: finalkvalPrediction.finalist2.toJson(),
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot): FinalkvalPredictionAndScore {
    const data = snapshot.data();
    return new FinalkvalPredictionAndScore({
      finalist1: new PredictionAndScore({
        prediction: data.finalist1.prediction,
        score: data.finalist1.score,
      }),
      finalist2: new PredictionAndScore({
        prediction: data.finalist2.prediction,
        score: data.finalist2.score,
      }),
    });
  },
};

export { FinalkvalPredictionAndScore, finalkvalPredictionAndScoreConverter };
