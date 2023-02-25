import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  const User({
    this.id,
    this.username,
  });

  final String? id;
  final String? username;

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      id: snapshot.id,
      username: data?['username'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      // if (participants != null) "participants": participants,
      // "time": time,
      // if (locationName != null) "locationName": locationName,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'id': id,
      };

  factory User.empty() => const User(
        id: null,
        username: null,
      );
}
