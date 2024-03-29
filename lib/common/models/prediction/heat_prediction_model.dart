import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';

part 'heat_prediction_model.freezed.dart';
part 'heat_prediction_model.g.dart';

@freezed
class HeatPredictionModel
    with _$HeatPredictionModel
    implements PredictionModel {
  const factory HeatPredictionModel({
    required PredictionAndScore finalist1,
    required PredictionAndScore finalist2,
    required PredictionAndScore semifinalist1,
    required PredictionAndScore semifinalist2,
    required PredictionAndScore fifthPlace,
  }) = _HeatPredictionModel;

  factory HeatPredictionModel.fromJson(Map<String, Object?> json) =>
      _$HeatPredictionModelFromJson(json);

  factory HeatPredictionModel.fromFirestore(
    DocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) =>
      HeatPredictionModel.fromJson(snapshot.data() as Map<String, dynamic>);

  static Map<String, dynamic> toFirestore(
    HeatPredictionModel prediction,
    SetOptions? options,
  ) =>
      prediction.toJson();
}