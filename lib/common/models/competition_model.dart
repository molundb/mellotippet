import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melodifestivalen_competition/common/models/all_models.dart';

class CompetitionModel {
  String id;
  CompetitionType type;
  int lowestScore;
  PredictionModel result;

  CompetitionModel({
    required this.id,
    required this.type,
    required this.lowestScore,
    required this.result,
  });

  factory CompetitionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    CompetitionType type;
    PredictionModel result;
    switch (snapshot.id) {
      case 'final':
        type = CompetitionType.theFinal;
        result = FinalPredictionModel.fromJson(data?['result']);
        break;
      case 'semifinal':
        type = CompetitionType.semifinal;
        result = SemifinalPredictionModel.fromJson(data?['result']);
        break;
      default:
        type = CompetitionType.heat;
        result = HeatPredictionModel.fromJson(data?['result']);
        break;
    }

    return CompetitionModel(
      id: snapshot.id,
      type: type,
      lowestScore: data?['lowestScore'] ?? -1,
      result: result,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {};
  }
}

enum CompetitionType {
  heat,
  semifinal,
  theFinal,
}
