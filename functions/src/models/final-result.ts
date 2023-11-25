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

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
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

const finalResultConverter = {
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
      placement1: data.result.placement1,
      placement2: data.result.placement2,
      placement3: data.result.placement3,
      placement4: data.result.placement4,
      placement5: data.result.placement5,
      placement6: data.result.placement6,
      placement7: data.result.placement7,
      placement8: data.result.placement8,
      placement9: data.result.placement9,
      placement10: data.result.placement10,
      placement11: data.result.placement11,
      placement12: data.result.placement12,
    });
  },
};

export { FinalResult, finalResultConverter };
