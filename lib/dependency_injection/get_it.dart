import 'package:get_it/get_it.dart';
import 'package:melodifestivalen_competition/repositories/authentication_repository.dart';
import 'package:melodifestivalen_competition/repositories/database_repository.dart';

final getIt = GetIt.instance;

Future<void> setUpGetIt() async {
  getIt.registerSingleton<DatabaseRepository>(DatabaseRepository());
  getIt.registerSingleton<AuthenticationRepository>(AuthenticationRepository());

  return getIt.allReady();
}