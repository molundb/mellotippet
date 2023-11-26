import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      () => AuthenticationRepository(
            firebaseAuth: FirebaseAuth.instance,
          ));

  getIt.registerLazySingleton<DatabaseRepository>(() => DatabaseRepository(
        db: FirebaseFirestore.instance,
        authRepository: getIt.get<AuthenticationRepository>(),
      ));

  getIt.registerLazySingleton<FeatureFlagRepository>(
      () => FeatureFlagRepository());

  getIt.registerSingleton<SnackbarHandler>(
    SnackbarHandler(
      getIt.get<GlobalKey<ScaffoldMessengerState>>(),
      getIt.get<Logger>(),
    ),
  );

  getIt.registerSingleton<MellotippetPackageInfo>(MellotippetPackageInfo());

  return getIt.allReady();
}