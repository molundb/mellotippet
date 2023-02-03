class PredictionModel {
  PredictionModel({
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

  factory PredictionModel.fromJson(Map<String, dynamic> json) =>
      PredictionModel(
        finalist1: json['finalist1'] ?? -1,
        finalist2: json['finalist2'] ?? -1,
        semifinalist1: json['semifinalist1'] ?? -1,
        semifinalist2: json['semifinalist2'] ?? -1,
        fifthPlace: json['fifthPlace'] ?? -1,
      );

  PredictionModel copyWith({
    int? finalist1,
    int? finalist2,
    int? semifinalist1,
    int? semifinalist2,
    int? fifthPlace,
  }) {
    return PredictionModel(
      finalist1: finalist1 ?? this.finalist1,
      finalist2: finalist2 ?? this.finalist2,
      semifinalist1: semifinalist1 ?? this.semifinalist1,
      semifinalist2: semifinalist2 ?? this.semifinalist2,
      fifthPlace: fifthPlace ?? this.fifthPlace,
    );
  }
}
