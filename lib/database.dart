import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:melodifestivalen_competition/prediction_model.dart';

class Database {
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
}
