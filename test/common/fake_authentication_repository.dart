import 'package:firebase_auth/firebase_auth.dart';
import 'package:mellotippet/common/repositories/authentication_repository.dart';

class FakeAuthenticationRepository implements AuthenticationRepository {
  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signOut() async {}

  @override
  User? get currentUser => null;

  @override
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @override
  Future<void> deleteUserAccount() async {}
}
