import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mellotippet/common/models/prediction_model.dart';

class SemifinalPredictionModel extends PredictionModel {
  SemifinalPredictionModel({
    this.finalist1,
    this.finalist2,
    this.finalist3,
    this.finalist4,
  });

  int? finalist1;
  int? finalist2;
  int? finalist3;
  int? finalist4;

  factory SemifinalPredictionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    return SemifinalPredictionModel.fromJson(data ?? {});
  }

  factory SemifinalPredictionModel.fromJson(Map<String, dynamic> json) =>
      SemifinalPredictionModel(
        finalist1: json['finalist1'] ?? -1,
        finalist2: json['finalist2'] ?? -1,
        finalist3: json['finalist3'] ?? -1,
        finalist4: json['finalist4'] ?? -1,
      );

  SemifinalPredictionModel copyWith({
    int? finalist1,
    int? finalist2,
    int? finalist3,
    int? finalist4,
  }) {
    return SemifinalPredictionModel(
      finalist1: finalist1 ?? this.finalist1,
      finalist2: finalist2 ?? this.finalist2,
      finalist3: finalist3 ?? this.finalist3,
      finalist4: finalist4 ?? this.finalist4,
    );
  }
}

extension SemifinalPredictionToMap on SemifinalPredictionModel {
  Map<int, String> toMap() {
    return <int, String>{
      finalist1!: 'F',
      finalist2!: 'F',
      finalist3!: 'F',
      finalist4!: 'F',
    };
  }
}
