import 'package:freezed_annotation/freezed_annotation.dart';

part 'prediction_and_score.freezed.dart';
part 'prediction_and_score.g.dart';

@freezed
class PredictionAndScore with _$PredictionAndScore {
  factory PredictionAndScore({required int prediction, @Default(0) int score}) =
      _PredictionAndScore;

  factory PredictionAndScore.fromJson(Map<String, dynamic> json) =>
      _$PredictionAndScoreFromJson(json);

// factory PredictionAndScore.fromFirestore(
//   DocumentSnapshot<Map<String, dynamic>> snapshot,
//   SnapshotOptions? options,
// ) {
//   final data = snapshot.data();
//
//   return PredictionAndScore.fromJson(data ?? {});
// }
//
// factory PredictionAndScore.fromJson(Map<String, dynamic> json) =>
//     PredictionAndScore(
//       prediction: json['prediction'] ?? -1,
//       score: json['score'] ?? -1,
//     );
}
