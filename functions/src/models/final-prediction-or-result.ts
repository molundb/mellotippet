import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";

export default class FinalPredictionOrResult {
  readonly placement1: number;
  readonly placement2: number;
  readonly placement3: number;
  readonly placement4: number;
  readonly placement5: number;
  readonly placement6: number;
  readonly placement7: number;
  readonly placement8: number;
  readonly placement9: number;
  readonly placement10: number;
  readonly placement11: number;
  readonly placement12: number;

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
    placement1: number;
    placement2: number;
    placement3: number;
    placement4: number;
    placement5: number;
    placement6: number;
    placement7: number;
    placement8: number;
    placement9: number;
    placement10: number;
    placement11: number;
    placement12: number;
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

  toResult() {
    return {
      result: {
        placement1: this.placement1,
        placement2: this.placement2,
        placement3: this.placement3,
        placement4: this.placement4,
        placement5: this.placement5,
        placement6: this.placement6,
        placement7: this.placement7,
        placement8: this.placement8,
        placement9: this.placement9,
        placement10: this.placement10,
        placement11: this.placement11,
        placement12: this.placement12,
      },
    };
  }
}

const finalPredictionConverter = {
  toFirestore(finalPrediction: FinalPredictionOrResult): DocumentData {
    return {
      placement1: finalPrediction.placement1,
      placement2: finalPrediction.placement2,
      placement3: finalPrediction.placement3,
      placement4: finalPrediction.placement4,
      placement5: finalPrediction.placement5,
      placement6: finalPrediction.placement6,
      placement7: finalPrediction.placement7,
      placement8: finalPrediction.placement8,
      placement9: finalPrediction.placement9,
      placement10: finalPrediction.placement10,
      placement11: finalPrediction.placement11,
      placement12: finalPrediction.placement12,
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot): FinalPredictionOrResult {
    const data = snapshot.data();
    return new FinalPredictionOrResult({
      placement1: data.placement1,
      placement2: data.placement2,
      placement3: data.placement3,
      placement4: data.placement4,
      placement5: data.placement5,
      placement6: data.placement6,
      placement7: data.placement7,
      placement8: data.placement8,
      placement9: data.placement9,
      placement10: data.placement10,
      placement11: data.placement11,
      placement12: data.placement12,
    });
  },
};

export { FinalPredictionOrResult, finalPredictionConverter };
