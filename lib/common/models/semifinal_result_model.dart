import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/prediction/prediction_model.dart';

part 'semifinal_result_model.freezed.dart';
part 'semifinal_result_model.g.dart';

@freezed
class SemifinalResultModel
    with _$SemifinalResultModel
    implements PredictionModel {
  const factory SemifinalResultModel({
    required int finalist1,
    required int finalist2,
  }) = _SemifinalResultModel;

  factory SemifinalResultModel.fromJson(Map<String, Object?> json) =>
      _$SemifinalResultModelFromJson(json);

  factory SemifinalResultModel.fromFirestore(
    DocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) =>
      SemifinalResultModel.fromJson(snapshot.data() as Map<String, dynamic>);
}
