import 'package:melodifestivalen_competition/common/models/models.dart';

class UserScoreEntity {
  const UserScoreEntity({
    this.username,
    this.competitionToPrediction,
    this.totalScore,
    this.competitionToScore,
  });

  final String? username;
  final int? totalScore;
  final Map<String, int>? competitionToScore;
  final Map<CompetitionModel, PredictionModel?>? competitionToPrediction;

  factory UserScoreEntity.fromJson(Map<String, dynamic> json) =>
      UserScoreEntity(
        username: json['username'],
        totalScore: json['totalScore'],
        competitionToScore: json['competitionToScore'],
        competitionToPrediction: json['competitionToScore'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'totalScore': totalScore,
        'competitionToScore': competitionToScore,
        'competitionToPrediction': competitionToPrediction,
      };

  factory UserScoreEntity.empty() => const UserScoreEntity(
        username: null,
        totalScore: null,
        competitionToScore: null,
        competitionToPrediction: null,
      );
}
