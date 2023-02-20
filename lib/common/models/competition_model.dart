import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionModel {
  String id;
  // List<ParticipantModel>? participants;
  // DateTime time;
  // String? locationName;
  int lowestScore;
  Map<String, dynamic> result;
  // List<PredictionModel> predictions;

  CompetitionModel({
    required this.id,
    // required this.participants,
    // required this.time,
    // required this.locationName,
    required this.lowestScore,
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
      lowestScore: data?['lowestScore'],
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
