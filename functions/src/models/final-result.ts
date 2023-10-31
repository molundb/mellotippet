import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";

export default class FinalResult {
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

  static fromJson(result?: any) {
    return new FinalResult({
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

const finalPredictionOrResultConverter = {
  toFirestore(finalPredictionOrResult: FinalResult): DocumentData {
    return {
      placement1: finalPredictionOrResult.placement1,
      placement2: finalPredictionOrResult.placement2,
      placement3: finalPredictionOrResult.placement3,
      placement4: finalPredictionOrResult.placement4,
      placement5: finalPredictionOrResult.placement5,
      placement6: finalPredictionOrResult.placement6,
      placement7: finalPredictionOrResult.placement7,
      placement8: finalPredictionOrResult.placement8,
      placement9: finalPredictionOrResult.placement9,
      placement10: finalPredictionOrResult.placement10,
      placement11: finalPredictionOrResult.placement11,
      placement12: finalPredictionOrResult.placement12,
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot): FinalResult {
    const data = snapshot.data();
    return new FinalResult({
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

export { FinalResult, finalPredictionOrResultConverter };
