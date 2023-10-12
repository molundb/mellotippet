import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";

export default class FinalPrediction {
  constructor(
    readonly position1: number,
    readonly position2: number,
    readonly position3: number,
    readonly position4: number,
    readonly position5: number,
    readonly position6: number,
    readonly position7: number,
    readonly position8: number,
    readonly position9: number,
    readonly position10: number,
    readonly position11: number,
    readonly position12: number
  ) {}
}

const finalPredictionConverter = {
  toFirestore(finalPrediction: FinalPrediction): DocumentData {
    return {
      position1: finalPrediction.position1,
      position2: finalPrediction.position2,
      position3: finalPrediction.position3,
      position4: finalPrediction.position4,
      position5: finalPrediction.position5,
      position6: finalPrediction.position6,
      position7: finalPrediction.position7,
      position8: finalPrediction.position8,
      position9: finalPrediction.position9,
      position10: finalPrediction.position10,
      position11: finalPrediction.position11,
      position12: finalPrediction.position12,
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot): FinalPrediction {
    const data = snapshot.data();
    return new FinalPrediction(
      data.position1,
      data.position2,
      data.position3,
      data.position4,
      data.position5,
      data.position6,
      data.position7,
      data.position8,
      data.position9,
      data.position10,
      data.position11,
      data.position12
    );
  },
};

export { FinalPrediction, finalPredictionConverter };
