import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';

class DatabaseRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // TODO: Change type String to int for predictions and add input validation
  void uploadPrediction(PredictionModel prediction) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      db.collection('predictions').doc(uid).set({
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
}
