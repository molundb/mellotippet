import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";

export default class FinalkvalResult {
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

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  static fromJson(result: any) {
    return new FinalkvalResult({
      finalist1: result.finalist1,
      finalist2: result.finalist2,
    });
  }

  toResult() {
    return {
      result: {
        finalist1: this.finalist1,
        finalist2: this.finalist2,
      },
    };
  }

  finalists() {
    return [this.finalist1, this.finalist2];
  }
}

const finalkvalResultConverter = {
  toFirestore(finalkvalResult: FinalkvalResult): DocumentData {
    return {
      result: {
        finalist1: finalkvalResult.finalist1,
        finalist2: finalkvalResult.finalist2,
      },
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot): FinalkvalResult {
    const data = snapshot.data();
    return new FinalkvalResult({
      finalist1: data.result.finalist1,
      finalist2: data.result.finalist2,
    });
  },
};

export { FinalkvalResult, finalkvalResultConverter };
