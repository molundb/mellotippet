import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionAndScore {
  PredictionAndScore({required this.prediction, this.score = 0});

  int prediction;
  int score;

  factory PredictionAndScore.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return PredictionAndScore.fromJson(data ?? {});
  }

  factory PredictionAndScore.fromJson(Map<String, dynamic> json) =>
      PredictionAndScore(
        prediction: json['prediction'] ?? -1,
        score: json['score'] ?? -1,
      );
}
