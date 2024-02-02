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
}
