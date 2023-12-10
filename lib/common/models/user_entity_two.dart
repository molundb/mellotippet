import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity_two.freezed.dart';

part 'user_entity_two.g.dart';

@freezed
class User with _$User {
  const factory User({
    String? id,
    String? username,
    required num totalScore,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  factory User.fromFirestore(
    DocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) =>
      User.fromJson(snapshot.data() as Map<String, dynamic>);

  static Map<String, dynamic> toFirestore(User model, SetOptions? options) =>
      model.toJson();
}
