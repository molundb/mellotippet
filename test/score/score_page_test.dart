import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mellotippet/score/score_page.dart';
import 'package:mellotippet/service_location/get_it.dart';

import '../common/fake_database_repository.dart';
import '../common/fakes.dart';

void main() {
  testWidgets(
      'given a user with a score, when score page is shown, the score is displayed',
      (tester) async {
    await setUpGetItForTest(
        databaseRepository: FakeDatabaseRepository(
            currentUser: fakeUser.copyWith(totalScore: 5)));

    await tester
        .pumpWidget(const ProviderScope(child: MaterialApp(home: ScorePage())));

    expect(find.text('0 p'), findsOneWidget);

    await tester.pump();

    expect(find.text('5 p'), findsOneWidget);
  });
}
