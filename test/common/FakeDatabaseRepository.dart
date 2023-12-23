import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mellotippet/common/models/competition_model.dart';
import 'package:mellotippet/common/models/prediction/final_prediction_model.dart';
import 'package:mellotippet/common/models/prediction/heat_prediction_model.dart';
import 'package:mellotippet/common/models/prediction/semifinal_prediction_model.dart';
import 'package:mellotippet/common/models/song.dart';
import 'package:mellotippet/common/models/user_entity_two.dart';
import 'package:mellotippet/common/repositories/database_repository.dart';

import 'fakes.dart';

class FakeDatabaseRepository implements DatabaseRepository {
  User currentUser;

  FakeDatabaseRepository({User? currentUser})
      : currentUser = currentUser ?? fakeUser;

  @override
  Future<List<CompetitionModel>> getCompetitions() {
    return Future.value([]);
  }

  @override
  Future<User> getCurrentUser() {
    return Future.value(currentUser);
  }

  @override
  Future<String> getCurrentUsername() {
    return Future.value("username");
  }

  @override
  Future<List<Song>> getSongs(String heatId) {
    return Future.value([]);
  }

  @override
  Future<bool> uploadFinalPrediction(
    String competitionId,
    FinalPredictionModel prediction,
  ) {
    return Future.value(true);
  }

  @override
  Future<bool> uploadHeatPrediction(
    String competitionId,
    HeatPredictionModel prediction,
  ) {
    return Future.value(true);
  }

  @override
  Future<bool> uploadSemifinalPrediction(
    String competitionId,
    SemifinalPredictionModel prediction,
  ) {
    return Future.value(true);
  }

  @override
  Future<User?> getUserWithUsername(String username) {
    return Future.value(null);
  }

  @override
  void setUsername(String username) {}
}
