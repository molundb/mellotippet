import 'package:flutter_test/flutter_test.dart';
import 'package:mellotippet/common/repositories/database_repository.dart';
import 'package:mellotippet/score/score_controller.dart';

void main() {
  test('given user, when app is started, then score is displayed', () async {
    // Given
    final scoreController = ScoreController(
        databaseRepository: DatabaseRepositoryImpl())
  });
}