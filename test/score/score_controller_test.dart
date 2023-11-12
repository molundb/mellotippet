import 'package:flutter_test/flutter_test.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/repositories/database_repository.dart';

import 'package:mellotippet/score/score_controller.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../common/fakes.dart';
import 'score_controller_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DatabaseRepository>(),
])
void main() {
  late MockDatabaseRepository mockDatabaseRepo;

  setUp(() {
    mockDatabaseRepo = MockDatabaseRepository();
  });

  test(
      'given no users, when getting user scores, then there are no user scores',
      () async {
    // Given
    final scoreController =
        ScoreController(databaseRepository: mockDatabaseRepo);

    final List<User> fakeUsers = [];

    when(mockDatabaseRepo.getUsers())
        .thenAnswer((_) => Future(() => fakeUsers));
    when(mockDatabaseRepo.getCompetitions())
        .thenAnswer((_) => Future(() => fakeCompetitions));

    mockGetPredictionsCalls(fakeUsers, fakeCompetitions, mockDatabaseRepo);

    // When
    await scoreController.getUserScores();

    // Then
    expect(scoreController.state.userScores.length, 0);
  });

  test('given no competition, when getting user scores, then all scores are 0',
      () async {
    // Given
    final scoreController =
        ScoreController(databaseRepository: mockDatabaseRepo);

    final fakeUsers = [
      const User(id: "id1", username: "username1"),
      const User(id: "id2", username: "username2"),
    ];

    final List<CompetitionModel> fakeCompetitions = [];

    when(mockDatabaseRepo.getUsers())
        .thenAnswer((_) => Future(() => fakeUsers));
    when(mockDatabaseRepo.getCompetitions())
        .thenAnswer((_) => Future(() => fakeCompetitions));

    mockGetPredictionsCalls(fakeUsers, fakeCompetitions, mockDatabaseRepo);

    // When
    await scoreController.getUserScores();

    // Then
    for (final score in scoreController.state.userScores) {
      expect(score.totalScore, 0);
    }
  });

  test(
      'given two users, when getting user scores, then there are two user scores',
      () async {
    // Given
    final scoreController =
        ScoreController(databaseRepository: mockDatabaseRepo);

    final fakeUsers = [
      const User(id: "id1", username: "username1"),
      const User(id: "id2", username: "username2"),
    ];

    when(mockDatabaseRepo.getUsers())
        .thenAnswer((_) => Future(() => fakeUsers));
    when(mockDatabaseRepo.getCompetitions())
        .thenAnswer((_) => Future(() => fakeCompetitions));

    mockGetPredictionsCalls(fakeUsers, fakeCompetitions, mockDatabaseRepo);

    // When
    await scoreController.getUserScores();

    // Then
    expect(scoreController.state.userScores.length, 2);
  });

  test(
      'given user with null username, when getting user scores, then there is no score for that user',
      () async {
    // Given
    final scoreController =
        ScoreController(databaseRepository: mockDatabaseRepo);

    final fakeUsers = [
      const User(id: "id1", username: "username1"),
      const User(id: "id2", username: "username2"),
      const User(id: "id3", username: null),
    ];

    when(mockDatabaseRepo.getUsers())
        .thenAnswer((_) => Future(() => fakeUsers));
    when(mockDatabaseRepo.getCompetitions())
        .thenAnswer((_) => Future(() => fakeCompetitions));

    mockGetPredictionsCalls(fakeUsers, fakeCompetitions, mockDatabaseRepo);

    // When
    await scoreController.getUserScores();

    // Then
    expect(scoreController.state.userScores.length, 2);
  });
}

void mockGetPredictionsCalls(List<User> fakeUsers, List<CompetitionModel> fakeCompetitions, MockDatabaseRepository mockDatabaseRepo) {
  for (final user in fakeUsers) {
    for (final competition in fakeCompetitions) {
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
}
