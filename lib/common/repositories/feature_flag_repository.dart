import 'package:firebase_remote_config/firebase_remote_config.dart';

class FeatureFlagRepository {
  final remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 1),
    ));

    await remoteConfig.setDefaults(const {
      'currentCompetition': 'ok',
    });

    await remoteConfig.fetchAndActivate();
  }

  String getCurrentCompetition() =>
      remoteConfig.getString('currentCompetition');
}
