import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/all_models.dart';

part 'user_score_entity.freezed.dart';

@freezed
class UserScoreEntity with _$UserScoreEntity {
  const factory UserScoreEntity({
    String? username,
    int? totalScore,
    Map<String, int>? competitionToScore,
    Map<CompetitionModel, PredictionModel?>? competitionToPrediction,
  }) = _UserScoreEntity;

  factory UserScoreEntity.empty() => const UserScoreEntity(
        username: null,
        totalScore: null,
        competitionToScore: null,
        competitionToPrediction: null,
      );
}
