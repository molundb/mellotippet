import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";
import { PredictionAndScore } from "./prediction-and-score";

export default class HeatPredictionAndScore {
  readonly finalist1: PredictionAndScore;
  readonly finalist2: PredictionAndScore;
  readonly semifinalist1: PredictionAndScore;
  readonly semifinalist2: PredictionAndScore;
  readonly fifthPlace: PredictionAndScore;

  constructor({
    finalist1,
    finalist2,
    semifinalist1,
    semifinalist2,
    fifthPlace,
  }: {
    finalist1: PredictionAndScore;
    finalist2: PredictionAndScore;
    semifinalist1: PredictionAndScore;
    semifinalist2: PredictionAndScore;
    fifthPlace: PredictionAndScore;
  }) {
    this.finalist1 = finalist1;
    this.finalist2 = finalist2;
    this.semifinalist1 = semifinalist1;
    this.semifinalist2 = semifinalist2;
    this.fifthPlace = fifthPlace;
  }

  finalistPredictions() {
    return [this.finalist1.prediction, this.finalist2.prediction];
  }

  semifinalistPredictions() {
    return [this.semifinalist1.prediction, this.semifinalist2.prediction];
  }

  totalScore() {
    return (
      this.finalist1.score +
      this.finalist2.score +
      this.semifinalist1.score +
      this.semifinalist2.score +
      this.fifthPlace.score
    );
  }
}

const heatPredictionAndScoreConverter = {
  toFirestore(heatPrediction: HeatPredictionAndScore): DocumentData {
    return {
      finalist1: heatPrediction.finalist1.toJson(),
      finalist2: heatPrediction.finalist2.toJson(),
      semifinalist1: heatPrediction.semifinalist1.toJson(),
      semifinalist2: heatPrediction.semifinalist2.toJson(),
      fifthPlace: heatPrediction.fifthPlace.toJson(),
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot): HeatPredictionAndScore {
    const data = snapshot.data();
    return new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({
        prediction: data.finalist1.prediction,
        score: data.finalist1.score,
      }),
      finalist2: new PredictionAndScore({
        prediction: data.finalist2.prediction,
        score: data.finalist2.score,
      }),
      semifinalist1: new PredictionAndScore({
        prediction: data.semifinalist1.prediction,
        score: data.semifinalist1.score,
      }),
      semifinalist2: new PredictionAndScore({
        prediction: data.semifinalist2.prediction,
        score: data.semifinalist2.score,
      }),
      fifthPlace: new PredictionAndScore({
        prediction: data.fifthPlace.prediction,
        score: data.fifthPlace.score,
      }),
    });
  },
};

export { HeatPredictionAndScore, heatPredictionAndScoreConverter };
