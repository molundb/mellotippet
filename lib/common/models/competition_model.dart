import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/common/models/participant_model.dart';

class CompetitionModel {
  String id;
  // List<ParticipantModel>? participants;
  // DateTime time;
  // String? locationName;
  Map<String, dynamic> result;
  // List<PredictionModel> predictions;

  CompetitionModel({
    required this.id,
    // required this.participants,
    // required this.time,
    // required this.locationName,
    required this.result,
    // required this.predictions,
  });

  factory CompetitionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CompetitionModel(
      id: snapshot.id,
      // participants: null,
      // time: (data?['time'] as Timestamp).toDate(),
      // locationName: data?['locationName'],
      result: data?['result'],
      // predictions: data?['predictions']((document) {
      //   PredictionModel.fromJson(document);
      // }),
        //PredictionModel.fromJson(data?['predictions']),
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
