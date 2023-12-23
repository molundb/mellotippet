import 'package:flutter_test/flutter_test.dart';
import 'package:mellotippet/common/repositories/feature_flag_repository.dart';
import 'package:mellotippet/prediction/heat_prediction_controller.dart';

import '../common/fake_database_repository.dart';

void main() {
  test('given a, when b, then c', () async {
    // Given
    final heatPredictionController = HeatPredictionController(
      databaseRepository: FakeDatabaseRepository(),
      featureFlagRepository: FeatureFlagRepositoryImpl(),
      state: const HeatPredictionControllerState(),
    );

    // When
    // heatPredictionController
  });
}
