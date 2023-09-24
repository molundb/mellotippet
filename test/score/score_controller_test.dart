import 'package:flutter_test/flutter_test.dart';
import 'package:melodifestivalen_competition/common/models/all_models.dart';
import 'package:melodifestivalen_competition/common/repositories/database_repository.dart';

import 'package:melodifestivalen_competition/score/score_controller.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../common/fakes.dart';
import 'score_controller_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DatabaseRepository>(),
])
void main() {
  late MockDatabaseRepository mockDatabaseRepo;
  late ScoreController scoreController;

  setUp(() {
    mockDatabaseRepo = MockDatabaseRepository();
  });

  test('given two users, when getting user scores, then there are two user scores', () async {
    // Given
    scoreController = ScoreController(databaseRepository: mockDatabaseRepo);

    when(mockDatabaseRepo.getUsers())
        .thenAnswer((_) => Future(() => fakeUsers));
    when(mockDatabaseRepo.getCompetitions())
        .thenAnswer((_) => Future(() => fakeCompetitions));

    for (var user in fakeUsers) {
      for (var competition in fakeCompetitions) {
        switch (competition.type) {
          case CompetitionType.heat:
            when(mockDatabaseRepo.getPredictionsForHeatForUser(
              competition.id,
              user.id,
            )).thenAnswer((_) => Future(() => fakeHeatPrediction));
            break;
          case CompetitionType.semifinal:
            when(mockDatabaseRepo.getPredictionsForSemifinalForUser(
              competition.id,
              user.id,
            )).thenAnswer((_) => Future(() => fakeSemifinalPrediction));
            break;
          case CompetitionType.theFinal:
            when(mockDatabaseRepo.getPredictionsForFinalForUser(
              competition.id,
              user.id,
            )).thenAnswer((_) => Future(() => fakeFinalPrediction));
            break;
        }
      }
    }

    // When
    await scoreController.getUserScores();

    // Then
    expect(scoreController.state.userScores.length, fakeUsers.length);
  });
}
