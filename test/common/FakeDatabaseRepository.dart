import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mellotippet/common/models/competition_model.dart';
import 'package:mellotippet/common/models/prediction/final_prediction_model.dart';
import 'package:mellotippet/common/models/prediction/heat_prediction_model.dart';
import 'package:mellotippet/common/models/prediction/semifinal_prediction_model.dart';
import 'package:mellotippet/common/models/song.dart';
import 'package:mellotippet/common/models/user_entity_two.dart';
import 'package:mellotippet/common/repositories/database_repository.dart';

class FakeDatabaseRepository implements DatabaseRepository {
  @override
  CollectionReference<Map<String, dynamic>> get users =>
      throw UnimplementedError();

  @override
  Future<List<CompetitionModel>> getCompetitions() {
    // TODO: implement getCompetitions
    throw UnimplementedError();
  }

  @override
  Future<User> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<String> getCurrentUsername() {
    // TODO: implement getCurrentUsername
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> getSongs(String heatId) {
    // TODO: implement getSongs
    throw UnimplementedError();
  }

  @override
  Future<bool> uploadFinalPrediction(
      String competitionId, FinalPredictionModel prediction) {
    // TODO: implement uploadFinalPrediction
    throw UnimplementedError();
  }

  @override
  Future<bool> uploadHeatPrediction(
      String competitionId, HeatPredictionModel prediction) {
    // TODO: implement uploadHeatPrediction
    throw UnimplementedError();
  }

  @override
  Future<bool> uploadSemifinalPrediction(
      String competitionId, SemifinalPredictionModel prediction) {
    // TODO: implement uploadSemifinalPrediction
    throw UnimplementedError();
  }
}
