import 'package:flutter_test/flutter_test.dart';
import 'package:mellotippet/score/score_controller.dart';

import '../common/fake_authentication_repository.dart';
import '../common/fake_database_repository.dart';
import '../common/fakes.dart';

void main() {
  test(
      'given user with totalScore, when getUserScore is called, then state is set with score',
      () async {
    // Given
    final scoreController = ScoreController(
      databaseRepository:
          FakeDatabaseRepository(currentUser: fakeUser.copyWith(totalScore: 7)),
      authRepository: FakeAuthenticationRepository(),
      state: null,
    );

    // When
    await scoreController.getUserScore();

    // Then
    expect(scoreController.state.loading, false);
    expect(scoreController.state.userScore, 7);
  });
}
