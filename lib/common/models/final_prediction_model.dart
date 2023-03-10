import 'package:melodifestivalen_competition/common/models/prediction_model.dart';

class FinalPredictionModel extends PredictionModel {
  FinalPredictionModel({
    this.position1,
    this.position2,
    this.position3,
    this.position4,
    this.position5,
    this.position6,
    this.position7,
    this.position8,
    this.position9,
    this.position10,
    this.position11,
    this.position12,
  });

  int? position1;
  int? position2;
  int? position3;
  int? position4;
  int? position5;
  int? position6;
  int? position7;
  int? position8;
  int? position9;
  int? position10;
  int? position11;
  int? position12;

  factory FinalPredictionModel.fromJson(Map<String, dynamic> json) =>
      FinalPredictionModel(
        position1: json['position1'] ?? -1,
        position2: json['position2'] ?? -1,
        position3: json['position3'] ?? -1,
        position4: json['position4'] ?? -1,
        position5: json['position5'] ?? -1,
        position6: json['position6'] ?? -1,
        position7: json['position7'] ?? -1,
        position8: json['position8'] ?? -1,
        position9: json['position9'] ?? -1,
        position10: json['position10'] ?? -1,
        position11: json['position11'] ?? -1,
        position12: json['position12'] ?? -1,
      );

  FinalPredictionModel copyWith({
    int? position1,
    int? position2,
    int? position3,
    int? position4,
    int? position5,
    int? position6,
    int? position7,
    int? position8,
    int? position9,
    int? position10,
    int? position11,
    int? position12,
  }) {
    return FinalPredictionModel(
      position1: position1 ?? this.position1,
      position2: position2 ?? this.position2,
      position3: position3 ?? this.position3,
      position4: position4 ?? this.position4,
      position5: position5 ?? this.position5,
      position6: position6 ?? this.position6,
      position7: position7 ?? this.position7,
      position8: position8 ?? this.position8,
      position9: position9 ?? this.position9,
      position10: position10 ?? this.position10,
      position11: position11 ?? this.position11,
      position12: position12 ?? this.position12,
    );
  }
}

extension FinalPredictionToMap on FinalPredictionModel {
  Map<int, String> toMap() {
    return <int, String>{
      position1!: 'F',
      position2!: 'F',
      position3!: 'F',
      position4!: 'F',
      position5!: 'F',
      position6!: 'F',
      position7!: 'F',
      position8!: 'F',
      position9!: 'F',
      position10!: 'F',
      position11!: 'F',
      position12!: 'F',
    };
  }
}
