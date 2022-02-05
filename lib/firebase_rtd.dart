import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRtd {
  FirebaseDatabase? database;

  FirebaseRtd(FirebaseApp firebaseApp) {
    database = FirebaseDatabase.instanceFor(
        app: firebaseApp,
        databaseURL:
            "https://melodifestivalen-competition-default-rtdb.europe-west1.firebasedatabase.app");
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
      DatabaseReference ref = database!.ref().child('predictions').child(uid);

      await ref.set({
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
