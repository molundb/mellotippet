import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melodifestivalen_competition/common/models/prediction_model.dart';

class HeatPredictionModel extends PredictionModel {
  HeatPredictionModel({
    this.finalist1,
    this.finalist2,
    this.semifinalist1,
    this.semifinalist2,
    this.fifthPlace,
  });

  int? finalist1;
  int? finalist2;
  int? semifinalist1;
  int? semifinalist2;
  int? fifthPlace;

  factory HeatPredictionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return HeatPredictionModel.fromJson(data ?? {});
  }

  factory HeatPredictionModel.fromJson(Map<String, dynamic> json) =>
      HeatPredictionModel(
        finalist1: json['finalist1'] ?? -1,
        finalist2: json['finalist2'] ?? -1,
        semifinalist1: json['semifinalist1'] ?? -1,
        semifinalist2: json['semifinalist2'] ?? -1,
        fifthPlace: json['fifthPlace'] ?? -1,
      );

  HeatPredictionModel copyWith({
    int? finalist1,
    int? finalist2,
    int? semifinalist1,
    int? semifinalist2,
    int? fifthPlace,
  }) {
    return HeatPredictionModel(
      finalist1: finalist1 ?? this.finalist1,
      finalist2: finalist2 ?? this.finalist2,
      semifinalist1: semifinalist1 ?? this.semifinalist1,
      semifinalist2: semifinalist2 ?? this.semifinalist2,
      fifthPlace: fifthPlace ?? this.fifthPlace,
    );
  }
}

extension HeatPredictionToMap on HeatPredictionModel {
  Map<int, String> toMap() {
    return <int, String>{
      finalist1!: 'F',
      finalist2!: 'F',
      semifinalist1!: 'SF',
      semifinalist2!: 'SF',
      fifthPlace!: '5th',
    };
  }
}
