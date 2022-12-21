import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  FirebaseFirestore? db;

  Database(FirebaseApp firebaseApp) {
    db = FirebaseFirestore.instance;
  }

  // TODO: Change type String to int for predictions and add input validation
  void storePrediction(
    String name,
    String finalist1,
    String finalist2,
    String semifinalist1,
    String semifinalist2,
    String fifthPlace,
  ) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      db!.collection('predictions').doc(uid).set({
        "name": name,
        "finalist1": finalist1,
        "finalist2": finalist2,
        "semifinalist3": semifinalist1,
        "semifinalist4": semifinalist2,
        "fifthPlace": fifthPlace,
      });
    }
  }
}
