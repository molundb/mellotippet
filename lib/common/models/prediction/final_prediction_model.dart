import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';
import 'package:mellotippet/common/models/prediction/prediction_model.dart';

part 'final_prediction_model.freezed.dart';
part 'final_prediction_model.g.dart';

@freezed
class FinalPredictionModel
    with _$FinalPredictionModel
    implements PredictionModel {
  const factory FinalPredictionModel({
    required PredictionAndScore placement1,
    required PredictionAndScore placement2,
    required PredictionAndScore placement3,
    required PredictionAndScore placement4,
    required PredictionAndScore placement5,
    required PredictionAndScore placement6,
    required PredictionAndScore placement7,
    required PredictionAndScore placement8,
    required PredictionAndScore placement9,
    required PredictionAndScore placement10,
    required PredictionAndScore placement11,
    required PredictionAndScore placement12,
  }) = _FinalPredictionModel;

  factory FinalPredictionModel.fromJson(Map<String, Object?> json) =>
      _$FinalPredictionModelFromJson(json);

  factory FinalPredictionModel.fromFirestore(
    DocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) =>
      FinalPredictionModel.fromJson(snapshot.data() as Map<String, dynamic>);

  static Map<String, dynamic> toFirestore(
    FinalPredictionModel prediction,
    SetOptions? options,
  ) =>
      prediction.toJson();
}

extension FinalPredictionToMap on FinalPredictionModel {
  Map<int, String> toMap() {
    return <int, String>{
      placement1.prediction: 'F',
      placement2.prediction: 'F',
      placement3.prediction: 'F',
      placement4.prediction: 'F',
      placement5.prediction: 'F',
      placement6.prediction: 'F',
      placement7.prediction: 'F',
      placement8.prediction: 'F',
      placement9.prediction: 'F',
      placement10.prediction: 'F',
      placement11.prediction: 'F',
      placement12.prediction: 'F',
    };
  }
}

extension FinalPredictionToList on FinalPredictionModel {
  List<int> toList() {
    return [
      placement1.prediction,
      placement2.prediction,
      placement3.prediction,
      placement4.prediction,
      placement5.prediction,
      placement6.prediction,
      placement7.prediction,
      placement8.prediction,
      placement9.prediction,
      placement10.prediction,
      placement11.prediction,
      placement12.prediction,
    ];
  }
}
