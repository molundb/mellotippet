import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';
import 'package:mellotippet/common/models/prediction/prediction_model.dart';

class HeatResultModel extends PredictionModel {
  HeatResultModel({
    required this.finalist1,
    required this.finalist2,
    required this.semifinalist1,
    required this.semifinalist2,
  });

  int finalist1;
  int finalist2;
  int semifinalist1;
  int semifinalist2;

  factory HeatResultModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return HeatResultModel.fromJson(data ?? {});
  }

  factory HeatResultModel.fromJson(Map<String, dynamic> json) =>
      HeatResultModel(
        finalist1: json['finalist1'],
        finalist2: json['finalist2'],
        semifinalist1: json['semifinalist1'],
        semifinalist2: json['semifinalist2'],
      );

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
