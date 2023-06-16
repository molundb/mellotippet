import 'package:melodifestivalen_competition/common/repositories/authentication_repository.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';

class SettingsController {
  final AuthenticationRepository authRepository =
      getIt.get<AuthenticationRepository>();

  Future<void> signOut() => authRepository.firebaseAuth.signOut();
}
