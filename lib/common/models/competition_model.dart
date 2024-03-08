import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/final_result_model.dart';
import 'package:mellotippet/common/models/heat_result_model.dart';
import 'package:mellotippet/common/models/semifinal_result_model.dart';

part 'competition_model.freezed.dart';

@freezed
class CompetitionModel with _$CompetitionModel {
  const factory CompetitionModel({
    required String id,
    required CompetitionType type,
    required int lowestScore,
    PredictionModel? result,
    required String appBarSubtitle,
  }) = _CompetitionModel;

  factory CompetitionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final resultSnapshot = data?['result'];

    CompetitionType type;
    PredictionModel? result;

    switch (snapshot.id) {
      case 'final':
        type = CompetitionType.theFinal;
        if (resultSnapshot != null) {
          result = FinalResultModel.fromJson(resultSnapshot);
        }
        break;
      case 'finalkval':
        type = CompetitionType.finalkval;
        if (resultSnapshot != null) {
          result = SemifinalResultModel.fromJson(resultSnapshot);
        }
        break;
      default:
        type = CompetitionType.heat;
        if (resultSnapshot != null) {
          result = HeatResultModel.fromJson(resultSnapshot);
        }
        break;
    }

    return CompetitionModel(
      id: snapshot.id,
      type: type,
      lowestScore: data?['lowestScore'] ?? -1,
      result: result,
      appBarSubtitle: data?['appBarSubtitle'] ?? "",
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
  finalkval,
  theFinal,
}
