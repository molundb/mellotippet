import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@freezed
class Song with _$Song {
  const factory Song({
    required String artist,
    required String song,
    @Default('adam-woods.png') String image,
    required int startNumber,
  }) = _Song;

  factory Song.fromJson(Map<String, Object?> json) => _$SongFromJson(json);

  factory Song.fromFirestore(
    DocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) =>
      Song.fromJson(snapshot.data() as Map<String, dynamic>);

  static Map<String, dynamic> toFirestore(Song song, SetOptions? options) =>
      song.toJson();
}
