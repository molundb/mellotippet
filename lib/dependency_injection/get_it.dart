import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';

final getIt = GetIt.instance;

Future<void> setUpGetIt() async {
  getIt.registerSingleton<AuthenticationRepository>(FirebaseAuthentication(
    firebaseAuth: FirebaseAuth.instance,
  ));
  getIt.registerSingleton<DatabaseRepository>(DatabaseRepository(
    authRepository: getIt.get<AuthenticationRepository>(),
  ));

  return getIt.allReady();
}
