import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity_two.freezed.dart';

part 'user_entity_two.g.dart';

@freezed
class User with _$User {
  const factory User({
    String? id,
    String? username,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return User.fromJson({'id': snapshot.id, 'username': data?['username']});
  }

  static Map<String, dynamic> toFirestore(User model, SetOptions? options) {
    return {
      // if (participants != null) "participants": participants,
      // "time": time,
      // if (locationName != null) "locationName": locationName,
    };
  }
}
