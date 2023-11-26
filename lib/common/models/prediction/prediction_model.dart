import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PredictionModel {
  PredictionModel();

  PredictionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  );

  PredictionModel.fromJson(Map<String, dynamic> json);
}
