class UserEntity {
  const UserEntity({
    this.username,
    this.scoreS,
    this.totalScore,
    this.competitionToScore,
  });

  final String? username;
  final String? scoreS;
  final int? totalScore;
  final Map<String, int>? competitionToScore;

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        username: json['username'],
        scoreS: json['scoreS'],
        totalScore: json['totalScore'],
        competitionToScore: json['competitionToScore'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'score': scoreS,
        'totalScore': totalScore,
        'competitionToScore': competitionToScore,
      };

  factory UserEntity.empty() => const UserEntity(
        username: null,
        scoreS: null,
        totalScore: null,
        competitionToScore: null,
      );
}
