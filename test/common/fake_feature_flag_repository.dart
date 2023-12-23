import 'package:mellotippet/common/repositories/feature_flag_repository.dart';

class FakeFeatureFlagRepository implements FeatureFlagRepository {
  @override
  String getCurrentCompetition() {
    return "current competition";
  }

  @override
  String getRecommendedMinimumVersion() {
    return "4.0";
  }

  @override
  String getRequiredMinimumVersion() {
    return "2.0";
  }
}
