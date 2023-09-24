import 'package:flutter_test/flutter_test.dart';
import 'package:melodifestivalen_competition/common/repositories/database_repository.dart';

import 'package:melodifestivalen_competition/score/score_controller.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../common/fakes.dart';
import 'score_controller_test.mocks.dart';

@GenerateMocks([
  DatabaseRepository,
])
void main() {
  late MockDatabaseRepository mockDatabaseRepo;
  late ScoreController scoreController;

  setUp(() {
    mockDatabaseRepo = MockDatabaseRepository();
  });

  test('given a, when b, then c', () async {
    // Given
    scoreController = ScoreController(databaseRepository: mockDatabaseRepo);

    when(mockDatabaseRepo.getUsers()).thenAnswer((_) => Future(() => fakeUsers));
    when(mockDatabaseRepo.getCompetitions()).thenAnswer((_) => Future(() => fakeCompetitions));

    // for (var competition in fakeCompetitions) {
    //   when(mockDatabaseRepo.predictionsForCompetition(competition.id)).thenAnswer((_) => Future(() => fakeCompetitions));
    // }

    // When
    await scoreController.getUserScores();

    // Then
    expect(scoreController.state, 1);
  });
}
