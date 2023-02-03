class UserEntity {
  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
  });

  final String id;
  final String username;
  final String email;

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['id'] ?? "",
        username: json['username'] ?? "",
        email: json['email'] ?? "",
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'username': username,
        'email': email,
      };

  factory UserEntity.empty() => const UserEntity(
        id: "",
        username: "",
        email: "",
      );

  List<Object?> get props => [id, username, email];
}

