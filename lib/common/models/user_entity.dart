class UserEntity {
  const UserEntity({
    this.username,
    this.score,
  });

  final String? username;
  final int? score;

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        username: json['username'],
        score: json['score'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'score': score,
      };

  factory UserEntity.empty() => const UserEntity(
        username: null,
        score: null,
      );
}

