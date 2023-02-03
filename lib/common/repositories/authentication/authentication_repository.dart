import 'package:melodifestivalen_competition/common/models/models.dart';

abstract class AuthenticationRepository {
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });
}