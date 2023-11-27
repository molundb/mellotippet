import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/prediction/prediction_model.dart';

part 'heat_result_model.freezed.dart';

part 'heat_result_model.g.dart';

@freezed
class HeatResultModel with _$HeatResultModel implements PredictionModel {
  const factory HeatResultModel({
    required int finalist1,
    required int finalist2,
    required int semifinalist1,
    required int semifinalist2,
  }) = _HeatResultModel;

  factory HeatResultModel.fromJson(Map<String, Object?> json) =>
      _$HeatResultModelFromJson(json);

  factory HeatResultModel.fromFirestore(
    DocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) =>
      HeatResultModel.fromJson(snapshot.data() as Map<String, dynamic>);
}
