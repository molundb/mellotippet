import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/mellotippet_app.dart';
import 'package:mellotippet/prediction/heat_prediction_page.dart';
import 'package:mellotippet/service_location/get_it.dart';

import '../common/fake_database_repository.dart';
import '../common/fake_feature_flag_repository.dart';

void main() {
  testWidgets(
      'given start state, when heat prediction page is shown, then tippa button is disabled',
      (tester) async {
    await setUpGetItForTest(
      databaseRepository: FakeDatabaseRepository(),
      featureFlagRepository: FakeFeatureFlagRepository(),
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: EagerSongFetcher(
          currentCompetitionType: CompetitionType.heat,
          child: MaterialApp(
            home: HeatPredictionPage(),
          ),
        ),
      ),
    );

    final button = find.widgetWithText(TextButton, 'Tippa');

    expect(tester.widget<TextButton>(button).enabled, isFalse);
  });
}
