import 'package:cloud_firestore/cloud_firestore.dart';

interface class PredictionModel {
  PredictionModel();

  PredictionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  );

  static Map<String, dynamic> toFirestore(
    PredictionModel prediction,
    SetOptions? options,
  ) =>
      {};

  PredictionModel.fromJson(Map<String, dynamic> json);
}
