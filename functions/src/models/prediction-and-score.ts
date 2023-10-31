class PredictionAndScore {
  prediction: number;
  score: number;

  constructor({ prediction, score }: { prediction: number; score: number }) {
    this.prediction = prediction;
    this.score = score;
  }

  toJson() {
    return {
      prediction: this.prediction,
      score: this.score,
    };
  }
}

export { PredictionAndScore };
