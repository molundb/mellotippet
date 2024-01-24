import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class FeatureFlagRepository {
  String getCurrentCompetition();

  String getRequiredMinimumVersion();

  String getRecommendedMinimumVersion();
}

class FeatureFlagRepositoryImpl implements FeatureFlagRepository {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await remoteConfig.setDefaults(const {
      'currentCompetition': 'theFinal',
      'requiredMinimumAppVersion': '4.0.0',
      'recommendedMinimumAppVersion': '4.0.0',
    });

    await remoteConfig.fetchAndActivate();

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
    });
  }

  @override
  String getCurrentCompetition() =>
      _remoteConfig.getString('currentCompetition');

  @override
  String getRequiredMinimumVersion() =>
      _remoteConfig.getString('requiredMinimumAppVersion');

  @override
  String getRecommendedMinimumVersion() =>
      _remoteConfig.getString('recommendedMinimumAppVersion');
}
