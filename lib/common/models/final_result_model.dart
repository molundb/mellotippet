import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/prediction/prediction_model.dart';

part 'final_result_model.freezed.dart';
part 'final_result_model.g.dart';

@freezed
class FinalResultModel with _$FinalResultModel implements PredictionModel {
  const factory FinalResultModel({
    required int placement1,
    required int placement2,
    required int placement3,
    required int placement4,
    required int placement5,
    required int placement6,
    required int placement7,
    required int placement8,
    required int placement9,
    required int placement10,
    required int placement11,
    required int placement12,
  }) = _FinalResultModel;

  factory FinalResultModel.fromJson(Map<String, Object?> json) =>
      _$FinalResultModelFromJson(json);

  factory FinalResultModel.fromFirestore(
    DocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) =>
      FinalResultModel.fromJson(snapshot.data() as Map<String, dynamic>);
}
