export default class SemifinalResult {
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
    return new SemifinalResult({
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

export { SemifinalResult };
