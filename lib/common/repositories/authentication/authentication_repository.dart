import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:melodifestivalen_competition/common/models/models.dart';

abstract class AuthenticationRepository {
  auth.User? get currentUser;

  Future<UserEntity> signInAnonymously();

  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}
