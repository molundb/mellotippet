import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';

class DatabaseRepository {
  AuthenticationRepository authRepository;

  DatabaseRepository({required this.authRepository});

  FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get users => db.collection('users');

  CollectionReference<Map<String, dynamic>> get predictions =>
      db.collection('predictions');

  CollectionReference<Map<String, dynamic>> get competitions =>
      db.collection('competitions');

  Future<bool> uploadPrediction(
      String competition, PredictionModel prediction) async {
    try {
      var uid = authRepository.currentUser?.uid;

      if (uid != null) {
        await competitions
            .doc(competition)
            .collection('predictions')
            .doc(uid)
            .set({
          "finalist1": prediction.finalist1,
          "finalist2": prediction.finalist2,
          "semifinalist1": prediction.semifinalist1,
          "semifinalist2": prediction.semifinalist2,
          "fifthPlace": prediction.fifthPlace,
        });

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String> getCurrentUsername() async {
    var uid = authRepository.currentUser?.uid;
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

  Future<List<UserEntity>> getUserScores() async {
    final users = await this.users.get();

    final userScores = await Future.wait(users.docs.map((user) async {
      final username = user.data()["username"];
      final score = await _getUserScore(user.id);
      return UserEntity(username: username, score: score);
    }));

    final filteredUserScores = userScores.where((userScore) {
      if (userScore.username == null) {
        return false;
      }
      return !userScore.username!.contains('appletester');
    }).toList();

    filteredUserScores.sort((a, b) {
      if (a.score == null || b.score == null) {
        return 0;
      }
      return int.parse(
              b.score!.substring(b.score!.length - 3, b.score!.length - 1)) -
          int.parse(
              a.score!.substring(a.score!.length - 3, a.score!.length - 1));
    });

    return filteredUserScores;
  }

  Future<String> _getUserScore(String? uid) async {
    final competitions = await getCompetitions();

    var totalScore = 0;
    var scoreS = '';

    for (var competition in competitions) {
      totalScore += await this
          .competitions
          .doc(competition.id)
          .collection('predictions')
          .doc(uid)
          .get()
          .then(
        (DocumentSnapshot doc) {
          var data = doc.data();
          int score;
          if (data == null) {
            score = competition.lowestScore - 1;
          } else {
            final prediction =
                PredictionModel.fromJson(data as Map<String, dynamic>);
            var result = PredictionModel.fromJson(competition.result);
            score = _calculateScore(result, prediction);
          }
          if (score < 10) {
            scoreS += ' ';
          }
          scoreS += '$score+';
          return score;
        },
        onError: (e) => print("Error getting document: $e"),
      );
    }

    scoreS = '${scoreS.substring(0, scoreS.length - 1)}=${totalScore}p';

    return scoreS;
  }

  int _calculateScore(PredictionModel result, PredictionModel prediction) {
    var score = 0;

    score += _calculateFinalistScore(result.finalist1, prediction);
    score += _calculateFinalistScore(result.finalist2, prediction);
    score += _calculateSemifinalistScore(result.semifinalist1, prediction);
    score += _calculateSemifinalistScore(result.semifinalist2, prediction);

    return score;
  }

  int _calculateFinalistScore(
    int? finalist,
    PredictionModel prediction,
  ) {
    var score = 0;

    if (finalist == prediction.finalist1 || finalist == prediction.finalist2) {
      score = 5;
    } else if (finalist == prediction.semifinalist1 ||
        finalist == prediction.semifinalist2) {
      score = 3;
    } else if (finalist == prediction.fifthPlace) {
      score = 1;
    }
    return score;
  }

  int _calculateSemifinalistScore(
    int? semifinalist,
    PredictionModel prediction,
  ) {
    var score = 0;

    if (semifinalist == prediction.finalist1 ||
        semifinalist == prediction.finalist2) {
      score = 1;
    } else if (semifinalist == prediction.semifinalist1 ||
        semifinalist == prediction.semifinalist2) {
      score = 2;
    } else if (semifinalist == prediction.fifthPlace) {
      score = 1;
    }
    return score;
  }

  Future<List<CompetitionModel>> getCompetitions() async {
    final competitionCollectionSnap = await competitions
        .withConverter(
          fromFirestore: CompetitionModel.fromFirestore,
          toFirestore: (CompetitionModel competition, _) =>
              competition.toFirestore(),
        )
        .get();

    return competitionCollectionSnap.docs.map((e) => e.data()).toList();
  }
}
