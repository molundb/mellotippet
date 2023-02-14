import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';
import 'package:melodifestivalen_competition/config/flavor.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/melodifestivalen_competition_app.dart';
import 'package:melodifestivalen_competition/services/crash_reporting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpGetIt(Flavor.stage);
  await AuthenticationRepository.initialize();
  await FeatureFlagRepository.initialize();
  CrashReporting.init();

  runApp(ProviderScope(child: MelodifestivalenCompetitionApp()));
}
