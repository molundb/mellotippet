import 'package:firebase_remote_config/firebase_remote_config.dart';

class FeatureFlagRepository {
  final remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.setDefaults(const {
      'currentCompetition': 'ok',
      'requiredMinimumVersion': '4.0.0',
      'recommendedMinimumVersion': '4.0.0',
    });

    await remoteConfig.fetchAndActivate();

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
    });
  }

  String getCurrentCompetition() =>
      remoteConfig.getString('currentCompetition');

  String getRequiredMinimumVersion() =>
      remoteConfig.getString('requiredMinimumVersion');

  String getRecommendedMinimumVersion() =>
      remoteConfig.getString('recommendedMinimumVersion');
}
