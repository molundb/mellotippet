import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";
import { PredictionAndScore } from "./prediction-and-score";

export default class FinalPredictionAndScore {
  placement1: PredictionAndScore;
  placement2: PredictionAndScore;
  placement3: PredictionAndScore;
  placement4: PredictionAndScore;
  placement5: PredictionAndScore;
  placement6: PredictionAndScore;
  placement7: PredictionAndScore;
  placement8: PredictionAndScore;
  placement9: PredictionAndScore;
  placement10: PredictionAndScore;
  placement11: PredictionAndScore;
  placement12: PredictionAndScore;

  constructor({
    placement1,
    placement2,
    placement3,
    placement4,
    placement5,
    placement6,
    placement7,
    placement8,
    placement9,
    placement10,
    placement11,
    placement12,
  }: {
    placement1: PredictionAndScore;
    placement2: PredictionAndScore;
    placement3: PredictionAndScore;
    placement4: PredictionAndScore;
    placement5: PredictionAndScore;
    placement6: PredictionAndScore;
    placement7: PredictionAndScore;
    placement8: PredictionAndScore;
    placement9: PredictionAndScore;
    placement10: PredictionAndScore;
    placement11: PredictionAndScore;
    placement12: PredictionAndScore;
  }) {
    this.placement1 = placement1;
    this.placement2 = placement2;
    this.placement3 = placement3;
    this.placement4 = placement4;
    this.placement5 = placement5;
    this.placement6 = placement6;
    this.placement7 = placement7;
    this.placement8 = placement8;
    this.placement9 = placement9;
    this.placement10 = placement10;
    this.placement11 = placement11;
    this.placement12 = placement12;
  }

  static fromJson(result?: any) {
    return new FinalPredictionAndScore({
      placement1: result.placement1,
      placement2: result.placement2,
      placement3: result.placement3,
      placement4: result.placement4,
      placement5: result.placement5,
      placement6: result.placement6,
      placement7: result.placement7,
      placement8: result.placement8,
      placement9: result.placement9,
      placement10: result.placement10,
      placement11: result.placement11,
      placement12: result.placement12,
    });
  }

  toList() {
    return [
      this.placement1,
      this.placement2,
      this.placement3,
      this.placement4,
      this.placement5,
      this.placement6,
      this.placement7,
      this.placement8,
      this.placement9,
      this.placement10,
      this.placement11,
      this.placement12,
    ];
  }

  predictions() {
    return [
      this.placement1.prediction,
      this.placement2.prediction,
      this.placement3.prediction,
      this.placement4.prediction,
      this.placement5.prediction,
      this.placement6.prediction,
      this.placement7.prediction,
      this.placement8.prediction,
      this.placement9.prediction,
      this.placement10.prediction,
      this.placement11.prediction,
      this.placement12.prediction,
    ]
  }

  totalScore() {
    return (
      this.placement1.score +
      this.placement2.score +
      this.placement3.score +
      this.placement4.score +
      this.placement5.score +
      this.placement6.score +
      this.placement7.score +
      this.placement8.score +
      this.placement9.score +
      this.placement10.score +
      this.placement11.score +
      this.placement12.score
    );
  }
}

const finalPredictionAndScoreConverter = {
  toFirestore(
    finalPredictionOrResult: FinalPredictionAndScore
  ): DocumentData {
    return {
      placement1: finalPredictionOrResult.placement1.toJson(),
      placement2: finalPredictionOrResult.placement2.toJson(),
      placement3: finalPredictionOrResult.placement3.toJson(),
      placement4: finalPredictionOrResult.placement4.toJson(),
      placement5: finalPredictionOrResult.placement5.toJson(),
      placement6: finalPredictionOrResult.placement6.toJson(),
      placement7: finalPredictionOrResult.placement7.toJson(),
      placement8: finalPredictionOrResult.placement8.toJson(),
      placement9: finalPredictionOrResult.placement9.toJson(),
      placement10: finalPredictionOrResult.placement10.toJson(),
      placement11: finalPredictionOrResult.placement11.toJson(),
      placement12: finalPredictionOrResult.placement12.toJson()
    };
  },
  fromFirestore(
    snapshot: QueryDocumentSnapshot
  ): FinalPredictionAndScore {
    const data = snapshot.data();
    return new FinalPredictionAndScore({
      placement1: new PredictionAndScore({
        prediction: data.placement1.prediction,
        score: data.placement1.score,
      }),
      placement2: new PredictionAndScore({
        prediction: data.placement2.prediction,
        score: data.placement2.score,
      }),
      placement3: new PredictionAndScore({
        prediction: data.placement3.prediction,
        score: data.placement3.score,
      }),
      placement4: new PredictionAndScore({
        prediction: data.placement4.prediction,
        score: data.placement4.score,
      }),
      placement5: new PredictionAndScore({
        prediction: data.placement5.prediction,
        score: data.placement5.score,
      }),
      placement6: new PredictionAndScore({
        prediction: data.placement6.prediction,
        score: data.placement6.score,
      }),
      placement7: new PredictionAndScore({
        prediction: data.placement7.prediction,
        score: data.placement7.score,
      }),
      placement8: new PredictionAndScore({
        prediction: data.placement8.prediction,
        score: data.placement8.score,
      }),
      placement9: new PredictionAndScore({
        prediction: data.placement9.prediction,
        score: data.placement9.score,
      }),
      placement10: new PredictionAndScore({
        prediction: data.placement10.prediction,
        score: data.placement10.score,
      }),
      placement11: new PredictionAndScore({
        prediction: data.placement11.prediction,
        score: data.placement11.score,
      }),
      placement12: new PredictionAndScore({
        prediction: data.placement12.prediction,
        score: data.placement12.score,
      }),
    });
  },
};

export { FinalPredictionAndScore, finalPredictionAndScoreConverter };
