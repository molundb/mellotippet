import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';

// TODO: Create an abstract class
class DatabaseRepository {
  FirebaseFirestore db;
  AuthenticationRepository authRepository;

  DatabaseRepository({
    required this.db,
    required this.authRepository,
  });

  CollectionReference<Map<String, dynamic>> get users => db.collection('users');

  CollectionReference<Map<String, dynamic>> get predictions =>
      db.collection('predictions');

  CollectionReference<Map<String, dynamic>> get competitions =>
      db.collection('competitions');

  CollectionReference<Map<String, dynamic>> predictionsForCompetition(
    String competitionId,
  ) =>
      competitions.doc(competitionId).collection('predictions');

  Future<bool> uploadSemifinalPrediction(
    String competitionId,
    SemifinalPredictionModel prediction,
  ) async {
    try {
      var uid = authRepository.currentUser?.uid;

      if (uid != null) {
        await predictionsForCompetition(competitionId).doc(uid).set({
          "finalist1": prediction.finalist1,
          "finalist2": prediction.finalist2,
          "finalist3": prediction.finalist3,
          "finalist4": prediction.finalist4,
        });

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> uploadFinalPrediction(
    String competitionId,
    FinalPredictionModel prediction,
  ) async {
    try {
      var uid = authRepository.currentUser?.uid;

      if (uid != null) {
        await predictionsForCompetition(competitionId).doc(uid).set({
          "position1": prediction.position1,
          "position2": prediction.position2,
          "position3": prediction.position3,
          "position4": prediction.position4,
          "position5": prediction.position5,
          "position6": prediction.position6,
          "position7": prediction.position7,
          "position8": prediction.position8,
          "position9": prediction.position9,
          "position10": prediction.position10,
          "position11": prediction.position11,
          "position12": prediction.position12,
        });

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String> getCurrentUsername() async {
    final uid = authRepository.currentUser?.uid;
    return await _getUsername(uid);
  }

  Future<String> _getUsername(String? uid) async {
    return await users.doc(uid).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        return data["username"];
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  Future<List<String>> getUsernames() async => (await users.get())
      .docs
      .map((user) => user.data()["username"] as String)
      .toList();

  Future<List<User>> getUsers() async => (await users
          .withConverter(
            fromFirestore: User.fromFirestore,
            toFirestore: (User user, _) => user.toFirestore(),
          )
          .get())
      .docs
      .map((e) => e.data())
      .toList();

  Future<List<CompetitionModel>> getCompetitions() async => (await competitions
          .withConverter(
            fromFirestore: CompetitionModel.fromFirestore,
            toFirestore: (CompetitionModel competition, _) =>
                competition.toFirestore(),
          )
          .get())
      .docs
      .map((e) => e.data())
      .toList();
}
