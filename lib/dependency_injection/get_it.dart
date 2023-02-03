import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:melodifestivalen_competition/common/repositories/authentication/firebase_authentication.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';

final getIt = GetIt.instance;

Future<void> setUpGetIt() async {
  getIt.registerSingleton<DatabaseRepository>(DatabaseRepository());
  getIt.registerSingleton<AuthenticationRepository>(FirebaseAuthentication(
    firebaseAuth: FirebaseAuth.instance,
  ));

  return getIt.allReady();
}
