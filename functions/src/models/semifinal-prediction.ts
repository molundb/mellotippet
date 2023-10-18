import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";

export default class SemifinalPrediction {
  readonly finalist1: number;
  readonly finalist2: number;

  constructor({
    finalist1,
    finalist2,
  }: {
    finalist1: number;
    finalist2: number;
  }) {
    this.finalist1 = finalist1;
    this.finalist2 = finalist2;
  }

  toList() {
    return [this.finalist1, this.finalist2];
  }
}

const semifinalPredictionConverter = {
  toFirestore(semifinalPrediction: SemifinalPrediction): DocumentData {
    return {
      finalist1: semifinalPrediction.finalist1,
      finalist2: semifinalPrediction.finalist2,
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot): SemifinalPrediction {
    const data = snapshot.data();
    return new SemifinalPrediction({
      finalist1: data.finalist1,
      finalist2: data.finalist2,
    });
  },
};

export { SemifinalPrediction, semifinalPredictionConverter };
