import 'package:melodifestivalen_competition/common/models/models.dart';

abstract class AuthenticationRepository {
  void signInAnonymously(){}

  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}