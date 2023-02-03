import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/common/models/participant_model.dart';

class CompetitionModel {
  // List<ParticipantModel>? participants;
  // DateTime time;
  // String? locationName;
  Map<String, dynamic> result;

  CompetitionModel({
    // required this.participants,
    // required this.time,
    // required this.locationName,
    required this.result,
  });

  factory CompetitionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CompetitionModel(
      // participants: null,
      // time: (data?['time'] as Timestamp).toDate(),
      // locationName: data?['locationName'],
      result: data?['result'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      // if (participants != null) "participants": participants,
      // "time": time,
      // if (locationName != null) "locationName": locationName,
    };
  }
}
