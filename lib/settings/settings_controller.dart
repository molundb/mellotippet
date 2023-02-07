import 'package:melodifestivalen_competition/common/repositories/firebase_authentication.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';

class SettingsController {
  final AuthenticationRepository authRepository =
      getIt.get<AuthenticationRepository>();

  Future<void> signOut() => authRepository.firebaseAuth.signOut();
}
