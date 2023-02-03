import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';

class DatabaseRepository {
  AuthenticationRepository authRepository;

  DatabaseRepository({
    required this.authRepository
  });

  FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get users => db.collection('users');

  CollectionReference<Map<String, dynamic>> get predictions =>
      db.collection('predictions');

  CollectionReference<Map<String, dynamic>> get competitions =>
      db.collection('competitions');

  // TODO: Change type String to int for predictions and add input validation
  void uploadPrediction(PredictionModel prediction) async {
    var uid = authRepository.currentUser?.uid;

    if (uid != null) {
      competitions.doc('heat1').collection('predictions').doc(uid).set({
        "name": prediction.name,
        "finalist1": prediction.finalist1,
        "finalist2": prediction.finalist2,
        "semifinalist3": prediction.semifinalist1,
        "semifinalist4": prediction.semifinalist2,
        "fifthPlace": prediction.fifthPlace,
      });
    }
  }

  Future<List<CompetitionModel>> getUpcomingCompetitions() async {
    final competitionCollectionSnap = await db
        .collection('competitions')
        .withConverter(
          fromFirestore: CompetitionModel.fromFirestore,
          toFirestore: (CompetitionModel competition, _) =>
              competition.toFirestore(),
        )
        .get();

    return competitionCollectionSnap.docs.map((e) => e.data()).toList();
  }

  Future<String> getCurrentUsername() async {
    var uid = authRepository.currentUser?.uid;

    final String username = await users.doc(uid).get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        return data["username"];
      },
      onError: (e) => print("Error getting document: $e"),
    );

     return username;
  }
}
