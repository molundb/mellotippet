import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";
import { PredictionAndScore } from "./prediction-and-score";

export default class SemifinalPredictionAndScore {
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

  getPredictions() {
    return [this.finalist1.prediction, this.finalist2.prediction];
  }
}

const semifinalPredictionConverter = {
  toFirestore(semifinalPrediction: SemifinalPredictionAndScore): DocumentData {
    return {
      finalist1: semifinalPrediction.finalist1.toJson(),
      finalist2: semifinalPrediction.finalist2.toJson(),
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot): SemifinalPredictionAndScore {
    const data = snapshot.data();
    return new SemifinalPredictionAndScore({
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

export { SemifinalPredictionAndScore, semifinalPredictionConverter };
