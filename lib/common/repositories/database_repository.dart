import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/song.dart';
import 'package:mellotippet/common/repositories/repositories.dart';

// TODO: Create an abstract class
class DatabaseRepository {
  FirebaseFirestore db;
  AuthenticationRepository authRepository;

  DatabaseRepository({
    required this.db,
    required this.authRepository,
  });

  CollectionReference<Map<String, dynamic>> get users => db.collection('users');

  CollectionReference<Map<String, dynamic>> get competitions =>
      db.collection('competitions');

  CollectionReference<Map<String, dynamic>> predictionsForCompetition(
    String competitionId,
  ) =>
      competitions.doc(competitionId).collection('predictionsAndScores');

  CollectionReference<HeatPredictionModel> getPredictionsAndScoresForHeat(
          String competitionId) =>
      competitions
          .doc(competitionId)
          .collection('predictionsAndScores')
          .withConverter(
            fromFirestore: HeatPredictionModel.fromFirestore,
            toFirestore: HeatPredictionModel.toFirestore,
          );

  Future<bool> uploadHeatPrediction(
    String competitionId,
    HeatPredictionModel prediction,
  ) async {
    try {
      var uid = authRepository.currentUser?.uid;

      if (uid != null) {
        await getPredictionsAndScoresForHeat(competitionId)
            .doc(uid)
            .set(prediction);

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

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
          "placement1": prediction.placement1,
          "placement2": prediction.placement2,
          "placement3": prediction.placement3,
          "placement4": prediction.placement4,
          "placement5": prediction.placement5,
          "placement6": prediction.placement6,
          "placement7": prediction.placement7,
          "placement8": prediction.placement8,
          "placement9": prediction.placement9,
          "placement10": prediction.placement10,
          "placement11": prediction.placement11,
          "placement12": prediction.placement12,
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
            toFirestore: User.toFirestore,
          )
          .get())
      .docs
      .map((e) => e.data())
      .toList();

  Future<List<CompetitionModel>> getCompetitions() async => (await competitions
          .withConverter(
            fromFirestore: CompetitionModel.fromFirestore,
            toFirestore: CompetitionModel.toFirestore,
          )
          .get())
      .docs
      .map((e) => e.data())
      .toList();

  Future<List<HeatPredictionModel>> getAllPredictionsForHeat(
    String competitionId,
  ) async {
    final heatPredictionsAndScores =
        getPredictionsAndScoresForHeat(competitionId);
    return (await heatPredictionsAndScores.get())
        .docs
        .map((e) => e.data())
        .toList();
  }

  Future<List<PredictionModel>> getAllPredictionsForSemifinal(
    String competitionId,
  ) async =>
      (await competitions
              .doc(competitionId)
              .collection('predictionsAndScores')
              .withConverter(
                fromFirestore: SemifinalPredictionModel.fromFirestore,
                toFirestore: SemifinalPredictionModel.toFirestore,
              )
              .get())
          .docs
          .map((e) => e.data())
          .toList();

  Future<List<PredictionModel>> getAllPredictionsForFinal(
    String competitionId,
  ) async =>
      (await competitions
              .doc(competitionId)
              .collection('predictionsAndScores')
              .withConverter(
                fromFirestore: FinalPredictionModel.fromFirestore,
                toFirestore: FinalPredictionModel.toFirestore,
              )
              .get())
          .docs
          .map((e) => e.data())
          .toList();

  Future<HeatPredictionModel?> getPredictionsForHeatForUser(
    String heatId,
    String? userId,
  ) async =>
      (await competitions
              .doc(heatId)
              .collection('predictionsAndScores')
              .doc(userId)
              .withConverter(
                fromFirestore: HeatPredictionModel.fromFirestore,
                toFirestore: HeatPredictionModel.toFirestore,
              )
              .get())
          .data();

  Future<SemifinalPredictionModel?> getPredictionsForSemifinalForUser(
    String heatId,
    String? userId,
  ) async =>
      (await competitions
              .doc(heatId)
              .collection('predictionsAndScores')
              .doc(userId)
              .withConverter(
        fromFirestore: SemifinalPredictionModel.fromFirestore,
                toFirestore: SemifinalPredictionModel.toFirestore,
              )
              .get())
          .data();

  Future<FinalPredictionModel?> getPredictionsForFinalForUser(
          String heatId, String? userId) async =>
      (await competitions
              .doc(heatId)
              .collection('predictionsAndScores')
              .doc(userId)
              .withConverter(
                fromFirestore: FinalPredictionModel.fromFirestore,
                toFirestore: FinalPredictionModel.toFirestore,
              )
              .get())
          .data();

  Future<List<Song>> getSongs(String heatId) async {
    return (await competitions
            .doc(heatId)
            .collection('songs')
            .withConverter(
              fromFirestore: Song.fromFirestore,
              toFirestore: Song.toFirestore,
            )
            .get())
        .docs
        .map((e) => e.data())
        .toList();
  }

  Future<User> getCurrentUser() async {
    final uid = authRepository.currentUser?.uid;
    return (await users
            .doc(uid)
            .withConverter(
              fromFirestore: User.fromFirestore,
              toFirestore: User.toFirestore,
            )
            .get())
        .data()!; // TODO: add try-catch and handle error
  }
}
