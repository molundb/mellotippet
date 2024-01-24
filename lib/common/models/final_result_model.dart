import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/prediction/prediction_model.dart';

part 'final_result_model.freezed.dart';
part 'final_result_model.g.dart';

@freezed
class FinalResultModel with _$FinalResultModel implements PredictionModel {
  const factory FinalResultModel({
    required int finalist1,
    required int finalist2,
  }) = _FinalResultModel;

  factory FinalResultModel.fromJson(Map<String, Object?> json) =>
      _$FinalResultModelFromJson(json);

  factory FinalResultModel.fromFirestore(
    DocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) =>
      FinalResultModel.fromJson(snapshot.data() as Map<String, dynamic>);
}
