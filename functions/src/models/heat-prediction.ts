import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";

export default class HeatPrediction {
  readonly finalist1: number;
  readonly finalist2: number;
  readonly semifinalist1: number;
  readonly semifinalist2: number;
  readonly fifthPlace: number;

  constructor({
    finalist1,
    finalist2,
    semifinalist1,
    semifinalist2,
    fifthPlace,
  }: {
    finalist1: number;
    finalist2: number;
    semifinalist1: number;
    semifinalist2: number;
    fifthPlace: number;
  }) {
    this.finalist1 = finalist1;
    this.finalist2 = finalist2;
    this.semifinalist1 = semifinalist1;
    this.semifinalist2 = semifinalist2;
    this.fifthPlace = fifthPlace;
  }
}

const heatPredictionConverter = {
  toFirestore(heatPrediction: HeatPrediction): DocumentData {
    return {
      finalist1: heatPrediction.finalist1,
      finalist2: heatPrediction.finalist2,
      semifinalist1: heatPrediction.semifinalist1,
      semifinalist2: heatPrediction.semifinalist2,
      fifthPlace: heatPrediction.fifthPlace,
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot): HeatPrediction {
    const data = snapshot.data();
    return new HeatPrediction({
      finalist1: data.finalist1,
      finalist2: data.finalist2,
      semifinalist1: data.semifinalist1,
      semifinalist2: data.semifinalist2,
      fifthPlace: data.fifthPlace,
    });
  },
};

export { HeatPrediction, heatPredictionConverter };
