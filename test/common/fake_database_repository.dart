import 'package:fpdart/fpdart.dart';
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
  Future<CompetitionModel> getCompetition(String competitionId) {
    return Future.value(fakeCompetitions[1]);
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
  Future<void> createUser(String username) async {}

  @override
  Future<String?> getImageDownloadUrl(
    int year,
    String competitionId,
    String? imagePath,
  ) {
    return Future.value(null);
  }

  @override
  Future<Either<Exception, bool>> deleteUserInfoAndAccount(String? uid) async {
    return Either.right(true);
  }
}
