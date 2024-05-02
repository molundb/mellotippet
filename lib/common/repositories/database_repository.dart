import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
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

  Future<CompetitionModel> getCompetition(String competitionId);

  Future<List<Song>> getSongs(String heatId);

  Future<String?> getImageDownloadUrl(
    int year,
    String competitionId,
    String? imagePath,
  );

  Future<User> getCurrentUser();

  Future<User?> getUserWithUsername(String username);

  Future<void> createUser(String username);

  Future<void> deleteUserInfoAndAccount(String? uid);
}

class DatabaseRepositoryImpl implements DatabaseRepository {
  FirebaseFirestore db;
  FirebaseStorage storage;
  AuthenticationRepository authRepository;

  DatabaseRepositoryImpl({
    required this.db,
    required this.storage,
    required this.authRepository,
  });

  CollectionReference<Map<String, dynamic>> get _users =>
      db.collection('users');

  CollectionReference<Map<String, dynamic>> get _competitions =>
      db.collection('competitions');

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

  CollectionReference<SemifinalPredictionModel>
      _getPredictionsAndScoresForSemifinal(
    String competitionId,
  ) =>
          _competitions
              .doc(competitionId)
              .collection('predictionsAndScores')
              .withConverter(
                fromFirestore: SemifinalPredictionModel.fromFirestore,
                toFirestore: SemifinalPredictionModel.toFirestore,
              );

  CollectionReference<FinalPredictionModel> _getPredictionsAndScoresForFinal(
    String competitionId,
  ) =>
      _competitions
          .doc(competitionId)
          .collection('predictionsAndScores')
          .withConverter(
            fromFirestore: FinalPredictionModel.fromFirestore,
            toFirestore: FinalPredictionModel.toFirestore,
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
        await _getPredictionsAndScoresForSemifinal(competitionId)
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
  Future<bool> uploadFinalPrediction(
    String competitionId,
    FinalPredictionModel prediction,
  ) async {
    try {
      var uid = authRepository.currentUser?.uid;

      if (uid != null) {
        await _getPredictionsAndScoresForFinal(competitionId)
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
  Future<CompetitionModel> getCompetition(String competitionId) async {
    return (await _competitions
            .withConverter(
              fromFirestore: CompetitionModel.fromFirestore,
              toFirestore: CompetitionModel.toFirestore,
            )
            .doc(competitionId)
            .get())
        .data()!; // TODO: add try-catch and handle error
  }

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
  Future<String?> getImageDownloadUrl(
      int year, String competitionId, String? imagePath) async {
    if (imagePath == null) {
      return null;
    }

    final ref = storage.ref().child("$year/$competitionId/$imagePath");

    try {
      return await ref.getDownloadURL();
    } catch (e) {
      Logger()
          .e("getDownloadURL() failed for image: $imagePath, exception: $e");
    }

    return null;
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
  Future<void> createUser(String username) async {
    final uid = authRepository.currentUser?.uid;

    return _users.doc(uid).set({
      "username": username,
      "totalScore": 0,
    });
  }

  @override
  Future<void> deleteUserInfoAndAccount(String? uid) async {
    try {
      await db.runTransaction((transaction) async {
        await _deletePredictions(uid);
        await _deleteUser(uid);
        await authRepository.deleteUserAccount();
      });

      print('Success deleting user account and info');
      authRepository.signOut();
    } catch (e) {
      print('Error deleting user account and info: $e');
    }
  }

  Future<bool> _deletePredictions(String? uid) async {
    final competitions = await getCompetitions();
    var success = true;

    for (final competition in competitions) {
      await _competitions
          .doc(competition.id)
          .collection('predictionsAndScores')
          .doc(uid)
          .delete()
          .then(
        (doc) => print('Document deleted'),
        onError: (e) {
          success = false;
          print("Error deleting document: $e");
          throw ("error deleting document: $e");
        },
      );
    }

    return success;
  }

  Future<bool> _deleteUser(String? uid) async {
    var success = true;

    _users.doc(uid).delete().then(
      (doc) => print('Document deleted'),
      onError: (e) {
        success = false;
        print("Error deleting user: $e");
        throw ("error deleting user: $e");
      },
    );

    return success;
  }
}
