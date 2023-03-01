import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';

class CompetitionModel {
  String id;
  int lowestScore;
  HeatPredictionModel result;

  CompetitionModel({
    required this.id,
    required this.lowestScore,
    required this.result,
  });

  factory CompetitionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CompetitionModel(
      id: snapshot.id,
      lowestScore: data?['lowestScore'] ?? -1,
      result: HeatPredictionModel.fromJson(data?['result']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {};
  }
}
