import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signInAnonymously() async {
    await auth.signInAnonymously();
  }
}