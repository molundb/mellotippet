export default class HeatResult {
  readonly finalist1: number;
  readonly finalist2: number;
  readonly semifinalist1: number;
  readonly semifinalist2: number;

  constructor({
    finalist1,
    finalist2,
    semifinalist1,
    semifinalist2,
  }: {
    finalist1: number;
    finalist2: number;
    semifinalist1: number;
    semifinalist2: number;
  }) {
    this.finalist1 = finalist1;
    this.finalist2 = finalist2;
    this.semifinalist1 = semifinalist1;
    this.semifinalist2 = semifinalist2;
  }

  static fromJson(result: any) {
    return new HeatResult({
      finalist1: result.finalist1,
      finalist2: result.finalist2,
      semifinalist1: result.semifinalist1,
      semifinalist2: result.semifinalist2,
    });
  }

  toResult() {
    return {
      result: {
        finalist1: this.finalist1,
        finalist2: this.finalist2,
        semifinalist1: this.semifinalist1,
        semifinalist2: this.semifinalist2,
      },
    };
  }

  finalists() {
    return [this.finalist1, this.finalist2];
  }

  semifinalists() {
    return [this.semifinalist1, this.semifinalist2];
  }
}

export { HeatResult };
