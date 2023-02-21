class UserEntity {
  const UserEntity({
    this.username,
    this.score,
    this.competitionToScore,
  });

  final String? username;
  final String? score;
  final Map<String, int>? competitionToScore;

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        username: json['username'],
        score: json['score'],
        competitionToScore: json['competitionToScore'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'score': score,
        'competitionToScore': competitionToScore,
      };

  factory UserEntity.empty() => const UserEntity(
        username: null,
        score: null,
        competitionToScore: null,
      );
}
