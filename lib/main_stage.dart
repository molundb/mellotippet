import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/config/flavor.dart';
import 'package:mellotippet/mellotippet_app.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/services/crash_reporting.dart';
import 'package:mellotippet/services/mello_tippet_package_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpGetIt(Flavor.stage);
  await AuthenticationRepositoryImpl.initialize(name: 'mellotippet-stage');
  await FeatureFlagRepositoryImpl.initialize();
  await getIt.get<MellotippetPackageInfo>().initialize();
  CrashReporting.initialize();

  runApp(ProviderScope(child: MellotippetApp()));
}
