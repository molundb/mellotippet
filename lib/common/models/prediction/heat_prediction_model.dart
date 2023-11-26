import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';
import 'package:mellotippet/common/models/prediction/prediction_model.dart';

part 'heat_prediction_model.freezed.dart';

part 'heat_prediction_model.g.dart';

@freezed
class HeatPredictionModel extends PredictionModel with _$HeatPredictionModel {
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
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return HeatPredictionModel.fromJson(data ?? {});
  }

// factory HeatPredictionModel.fromJson(Map<String, dynamic> json) =>
//     HeatPredictionModel(
//       finalist1: PredictionAndScore.fromJson(json['finalist1']),
//       finalist2: PredictionAndScore.fromJson(json['finalist2']),
//       semifinalist1: PredictionAndScore.fromJson(json['semifinalist1']),
//       semifinalist2: PredictionAndScore.fromJson(json['semifinalist2']),
//       fifthPlace: PredictionAndScore.fromJson(json['fifthPlace']),
//     );

// HeatPredictionModel copyWith({
//   int? finalist1,
//   int? finalist2,
//   int? semifinalist1,
//   int? semifinalist2,
//   int? fifthPlace,
// }) {
//   return HeatPredictionModel(
//     finalist1: finalist1 ?? this.finalist1,
//     finalist2: finalist2 ?? this.finalist2,
//     semifinalist1: semifinalist1 ?? this.semifinalist1,
//     semifinalist2: semifinalist2 ?? this.semifinalist2,
//     fifthPlace: fifthPlace ?? this.fifthPlace,
//   );
// }
}

// extension HeatPredictionToMap on HeatPredictionModel {
//   Map<int, String> toMap() {
//     return <int, String>{
//       finalist1!: 'F',
//       finalist2!: 'F',
//       semifinalist1!: 'SF',
//       semifinalist2!: 'SF',
//       fifthPlace!: '5th',
//     };
//   }
// }
