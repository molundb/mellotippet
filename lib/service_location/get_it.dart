import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/config/config.dart';
import 'package:mellotippet/config/flavor.dart';
import 'package:mellotippet/firebase_environment.dart';
import 'package:mellotippet/services/mello_tippet_package_info.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';

final getIt = GetIt.instance;

Future<void> setUpGetIt(Flavor flavor) async {
  getIt.registerSingleton<Config>(Config(flavor));
  getIt.registerSingleton<FirebaseEnvironment>(FirebaseEnvironment());

  getIt.registerSingleton<Logger>(Logger());

  getIt.registerSingleton<GlobalKey<ScaffoldMessengerState>>(
    GlobalKey<ScaffoldMessengerState>(),
  );

  getIt.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
            auth: FirebaseAuth.instance,
          ));

  getIt.registerLazySingleton<DatabaseRepository>(() => DatabaseRepositoryImpl(
        db: FirebaseFirestore.instance,
        storage: FirebaseStorage.instance,
        authRepository: getIt.get<AuthenticationRepository>(),
      ));

  getIt.registerLazySingleton<FeatureFlagRepository>(
      () => FeatureFlagRepositoryImpl());

  getIt.registerSingleton<SnackbarHandler>(
    SnackbarHandler(
      getIt.get<GlobalKey<ScaffoldMessengerState>>(),
      getIt.get<Logger>(),
    ),
  );

  getIt.registerSingleton<MellotippetPackageInfo>(
      MellotippetPackageInfoImplementation());

  return getIt.allReady();
}

Future<void> setUpGetItForTest({
  required DatabaseRepository databaseRepository,
  FeatureFlagRepository? featureFlagRepository,
  required AuthenticationRepository authenticationRepository,
  MellotippetPackageInfo? mellotippetPackageInfo,
}) {
  // getIt.registerSingleton<Config>(Config(flavor));
  // getIt.registerSingleton<FirebaseEnvironment>(FirebaseEnvironment());

  getIt.registerSingleton<Logger>(Logger());

  getIt.registerSingleton<GlobalKey<ScaffoldMessengerState>>(
    GlobalKey<ScaffoldMessengerState>(),
  );

  getIt.registerLazySingleton<AuthenticationRepository>(
      () => authenticationRepository);

  getIt.registerLazySingleton<DatabaseRepository>(() => databaseRepository);

  getIt.registerLazySingleton<FeatureFlagRepository>(
      () => featureFlagRepository ?? FeatureFlagRepositoryImpl());

  getIt.registerSingleton<SnackbarHandler>(
    SnackbarHandler(
      getIt.get<GlobalKey<ScaffoldMessengerState>>(),
      getIt.get<Logger>(),
    ),
  );

  getIt.registerSingleton<MellotippetPackageInfo>(
      mellotippetPackageInfo ?? MellotippetPackageInfoImplementation());

  return getIt.allReady();
}
