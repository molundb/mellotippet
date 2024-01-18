import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/heat_result_model.dart';

part 'competition_model.freezed.dart';

@freezed
class CompetitionModel with _$CompetitionModel {
  const factory CompetitionModel({
    required String id,
    required CompetitionType type,
    required int lowestScore,
    required PredictionModel result,
    required String appBarSubtitle,
  }) = _CompetitionModel;

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
        result = HeatResultModel.fromJson(data?['result']);
        break;
    }

    return CompetitionModel(
      id: snapshot.id,
      type: type,
      lowestScore: data?['lowestScore'] ?? -1,
      result: result,
      appBarSubtitle: data?['appBarSubtitle'],
    );
  }

  static Map<String, dynamic> toFirestore(
    CompetitionModel model,
    SetOptions? options,
  ) =>
      {};
}

enum CompetitionType {
  heat,
  semifinal,
  theFinal,
}
