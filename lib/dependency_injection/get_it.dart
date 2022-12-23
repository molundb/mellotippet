import 'package:get_it/get_it.dart';
import 'package:melodifestivalen_competition/authentication.dart';
import 'package:melodifestivalen_competition/database.dart';

final getIt = GetIt.instance;

Future<void> setUpGetIt() async {
  getIt.registerSingleton<Database>(Database());
  getIt.registerSingleton<Authentication>(Authentication());

  return getIt.allReady();
}