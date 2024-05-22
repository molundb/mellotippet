import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/settings/settings_page.dart';

import '../common/fake_authentication_repository.dart';
import '../common/fake_database_repository.dart';
import '../common/fake_mellotippet_package_info.dart';

void main() {
  testWidgets(
      'given a version number, when SettingsPage is started, then the version number is displayed',
      (tester) async {
    await setUpGetItForTest(
      databaseRepository: FakeDatabaseRepository(),
      authenticationRepository: FakeAuthenticationRepository(),
      mellotippetPackageInfo: FakeMellotippetPackageInfo("1.3.7"),
    );

    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SettingsPage())));

    await tester.pumpAndSettle();

    expect(find.text('Version: 1.3.7'), findsOneWidget);
  });
}
