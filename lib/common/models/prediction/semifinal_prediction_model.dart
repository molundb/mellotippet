import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';
import 'package:mellotippet/common/models/prediction/prediction_model.dart';

part 'semifinal_prediction_model.freezed.dart';
part 'semifinal_prediction_model.g.dart';

@freezed
class SemifinalPredictionModel
    with _$SemifinalPredictionModel
    implements PredictionModel {
  const factory SemifinalPredictionModel({
    required PredictionAndScore finalist1,
    required PredictionAndScore finalist2,
  }) = _SemifinalPredictionModel;

  factory SemifinalPredictionModel.fromJson(Map<String, Object?> json) =>
      _$SemifinalPredictionModelFromJson(json);

  factory SemifinalPredictionModel.fromFirestore(
    DocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) =>
      SemifinalPredictionModel.fromJson(
          snapshot.data() as Map<String, dynamic>);

  static Map<String, dynamic> toFirestore(
    SemifinalPredictionModel prediction,
    SetOptions? options,
  ) =>
      prediction.toJson();
}

extension SemifinalPredictionToMap on SemifinalPredictionModel {
  Map<int, String> toMap() {
    return <int, String>{
      finalist1.prediction: 'F',
      finalist2.prediction: 'F',
    };
  }
}
