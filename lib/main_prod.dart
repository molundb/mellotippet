import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';
import 'package:melodifestivalen_competition/config/flavor.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/melodifestivalen_competition_app.dart';
import 'package:melodifestivalen_competition/services/crash_reporting.dart';
import 'package:melodifestivalen_competition/services/mello_predix_package_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpGetIt(Flavor.prod);
  await AuthenticationRepository.initialize();
  await FeatureFlagRepository.initialize();
  await getIt.get<MelloPredixPackageInfo>().initialize();
  CrashReporting.initialize();

  runApp(ProviderScope(child: MelodifestivalenCompetitionApp()));
}
