class PredictionModel {
  PredictionModel({
    this.name,
    this.finalist1,
    this.finalist2,
    this.semifinalist1,
    this.semifinalist2,
    this.fifthPlace,
  });

  String? name;
  String? finalist1;
  String? finalist2;
  String? semifinalist1;
  String? semifinalist2;
  String? fifthPlace;

  PredictionModel copyWith({
    String? name,
    String? finalist1,
    String? finalist2,
    String? semifinalist1,
    String? semifinalist2,
    String? fifthPlace,
  }) {
    return PredictionModel(
      name: name ?? this.name,
      finalist1: finalist1 ?? this.finalist1,
      finalist2: finalist2 ?? this.finalist2,
      semifinalist1: semifinalist1 ?? this.semifinalist1,
      semifinalist2: semifinalist2 ?? this.semifinalist2,
      fifthPlace: fifthPlace ?? this.fifthPlace,
    );
  }
}
