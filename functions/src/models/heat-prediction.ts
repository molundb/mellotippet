import {DocumentData, QueryDocumentSnapshot} from "firebase-admin/firestore";

export default class HeatPrediction {
  constructor(
    readonly finalist1: number,
    readonly finalist2: number,
    readonly semifinalist1: number,
    readonly semifinalist2: number,
    readonly fifthPlace: number
  ) {}
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
  fromFirestore(
    snapshot: QueryDocumentSnapshot,
  ): HeatPrediction {
    const data = snapshot.data();
    return new HeatPrediction(
      data.finalist1,
      data.finalist2,
      data.semifinalist1,
      data.semifinalist2,
      data.fifthPlace
    );
  },
};

export {HeatPrediction, heatPredictionConverter}
