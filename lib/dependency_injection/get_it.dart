import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';
import 'package:melodifestivalen_competition/config/config.dart';
import 'package:melodifestivalen_competition/config/flavor.dart';
import 'package:melodifestivalen_competition/secrets.dart';

final getIt = GetIt.instance;

Future<void> setUpGetIt(Flavor flavor) async {
  getIt.registerSingleton<Config>(Config(flavor));
  getIt.registerSingleton<Secrets>(Secrets());

  getIt.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepository(
            firebaseAuth: FirebaseAuth.instance,
          ));

  getIt.registerLazySingleton<DatabaseRepository>(() => DatabaseRepository(
        authRepository: getIt.get<AuthenticationRepository>(),
      ));

  getIt.registerLazySingleton<FeatureFlagRepository>(
      () => FeatureFlagRepository());

  return getIt.allReady();
}
