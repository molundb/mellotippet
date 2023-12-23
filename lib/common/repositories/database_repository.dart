import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/song.dart';
import 'package:mellotippet/common/repositories/repositories.dart';

abstract class DatabaseRepository {
  Future<bool> uploadHeatPrediction(
    String competitionId,
    HeatPredictionModel prediction,
  );

  Future<bool> uploadSemifinalPrediction(
    String competitionId,
    SemifinalPredictionModel prediction,
  );

  Future<bool> uploadFinalPrediction(
    String competitionId,
    FinalPredictionModel prediction,
  );

  Future<String> getCurrentUsername();

  Future<List<CompetitionModel>> getCompetitions();

  Future<List<Song>> getSongs(String heatId);

  Future<User> getCurrentUser();

  Future<User?> getUserWithUsername(String username);

  void setUsername(String username);
}

class DatabaseRepositoryImpl implements DatabaseRepository {
  FirebaseFirestore db;
  AuthenticationRepository authRepository;

  DatabaseRepositoryImpl({
    required this.db,
    required this.authRepository,
  });

  CollectionReference<Map<String, dynamic>> get _users =>
      db.collection('users');

  CollectionReference<Map<String, dynamic>> get _competitions =>
      db.collection('competitions');

  CollectionReference<Map<String, dynamic>> _predictionsForCompetition(
    String competitionId,
  ) =>
      _competitions.doc(competitionId).collection('predictionsAndScores');

  CollectionReference<HeatPredictionModel> _getPredictionsAndScoresForHeat(
    String competitionId,
  ) =>
      _competitions
          .doc(competitionId)
          .collection('predictionsAndScores')
          .withConverter(
            fromFirestore: HeatPredictionModel.fromFirestore,
            toFirestore: HeatPredictionModel.toFirestore,
          );

  @override
  Future<bool> uploadHeatPrediction(
    String competitionId,
    HeatPredictionModel prediction,
  ) async {
    try {
      var uid = authRepository.currentUser?.uid;

      if (uid != null) {
        await _getPredictionsAndScoresForHeat(competitionId)
            .doc(uid)
            .set(prediction);

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> uploadSemifinalPrediction(
    String competitionId,
    SemifinalPredictionModel prediction,
  ) async {
    try {
      var uid = authRepository.currentUser?.uid;

      if (uid != null) {
        await _predictionsForCompetition(competitionId).doc(uid).set({
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

  @override
  Future<bool> uploadFinalPrediction(
    String competitionId,
    FinalPredictionModel prediction,
  ) async {
    try {
      var uid = authRepository.currentUser?.uid;

      if (uid != null) {
        await _predictionsForCompetition(competitionId).doc(uid).set({
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

  @override
  Future<String> getCurrentUsername() async {
    final uid = authRepository.currentUser?.uid;
    return await _getUsername(uid);
  }

  Future<String> _getUsername(String? uid) async {
    return await _users.doc(uid).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        return data["username"];
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Future<List<CompetitionModel>> getCompetitions() async => (await _competitions
          .withConverter(
            fromFirestore: CompetitionModel.fromFirestore,
            toFirestore: CompetitionModel.toFirestore,
          )
          .get())
      .docs
      .map((e) => e.data())
      .toList();

  @override
  Future<List<Song>> getSongs(String heatId) async {
    return (await _competitions
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

  @override
  Future<User> getCurrentUser() async {
    final uid = authRepository.currentUser?.uid;
    return (await _users
            .doc(uid)
            .withConverter(
              fromFirestore: User.fromFirestore,
              toFirestore: User.toFirestore,
            )
            .get())
        .data()!; // TODO: add try-catch and handle error
  }

  @override
  Future<User?> getUserWithUsername(String username) async {
    final querySnapshot = await _users
        .where('username', isEqualTo: username)
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: User.toFirestore,
        )
        .get();

    return querySnapshot.docs.firstOrNull?.data();
  }

  @override
  void setUsername(String username) async {
    final uid = authRepository.currentUser?.uid;

    _users.doc(uid).set({
      "username": username,
    });
  }
}
