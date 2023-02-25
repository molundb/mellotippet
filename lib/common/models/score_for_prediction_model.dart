import 'package:melodifestivalen_competition/common/models/models.dart';

class ScoreForPredictionModel {
  const ScoreForPredictionModel({
    this.result,
    this.prediction,
    this.score,
  });

  final int? result;
  final int? prediction;
  final int? score;

  factory ScoreForPredictionModel.fromJson(Map<String, dynamic> json) =>
      ScoreForPredictionModel(
        result: json['result'],
        prediction: json['prediction'],
        score: json['score'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'result': result,
        'prediction': prediction,
        'score': score,
      };

  factory ScoreForPredictionModel.empty() => const ScoreForPredictionModel(
        result: null,
        prediction: null,
        score: null,
      );
}
