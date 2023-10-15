import {DocumentData, QueryDocumentSnapshot} from "firebase-admin/firestore";

export default class SemifinalPrediction {
  constructor(
    readonly finalist1: number,
    readonly finalist2: number,
  ) {}

  toList() {
    return [this.finalist1, this.finalist2]
  }
}

const semifinalPredictionConverter = {
  toFirestore(semifinalPrediction: SemifinalPrediction): DocumentData {
    return {
      finalist1: semifinalPrediction.finalist1,
      finalist2: semifinalPrediction.finalist2,
    };
  },
  fromFirestore(
    snapshot: QueryDocumentSnapshot,
  ): SemifinalPrediction {
    const data = snapshot.data();
    return new SemifinalPrediction(
      data.finalist1,
      data.finalist2,
    );
  },
};

export {SemifinalPrediction, semifinalPredictionConverter}
