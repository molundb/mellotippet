import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/repositories/authentication/authentication_repository.dart';
import 'package:melodifestivalen_competition/common/repositories/authentication/firebase_authentication.dart';
import 'package:melodifestivalen_competition/config/flavor.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/melodifestivalen_competition_app.dart';
import 'package:melodifestivalen_competition/services/crash_reporting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpGetIt(Flavor.prod);
  await FirebaseAuthentication.initialize();
  CrashReporting.init();

  runApp(const ProviderScope(child: MelodifestivalenCompetitionApp()));
}
