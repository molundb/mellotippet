import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/score_old/score_calculator.dart';
import 'package:mellotippet/service_location/get_it.dart';

part 'score_controller.freezed.dart';

class ScoreController extends StateNotifier<ScoreControllerState> {
  ScoreController({
    required DatabaseRepository databaseRepository,
    ScoreControllerState? state,
  })  : _databaseRepository = databaseRepository,
        super(state ?? const ScoreControllerState());

  final DatabaseRepository _databaseRepository;

  static final provider =
      StateNotifierProvider<ScoreController, ScoreControllerState>(
          (ref) => ScoreController(
                databaseRepository: getIt.get<DatabaseRepository>(),
              ));

  Future<void> getUserScore() async {
    state = state.copyWith(loading: true);
    final filteredAndSortedUserScores = (await _getUserScores())
        .filterNullsAndTesterAccounts()
        .sortWithNullAsZero();
    state =
        state.copyWith(loading: false, userScores: filteredAndSortedUserScores);
  }

  Future<List<UserScoreEntity>> _getUserScores() async =>
      Future.wait((await _databaseRepository.getUsers()).map((user) async {
        final userPredictionsPerCompetition =
            await _getUserPredictionsPerCompetition(user.id);
        final totalScore = _calculateTotalScore(userPredictionsPerCompetition);
        final competitionToScore =
            _calculateCompetitionToScore(userPredictionsPerCompetition);

        return UserScoreEntity(
          username: user.username,
          competitionToPrediction: userPredictionsPerCompetition,
          totalScore: totalScore,
          competitionToScore: competitionToScore,
        );
      }));

  int _calculateTotalScore(
    Map<CompetitionModel, PredictionModel?> userPredictions,
  ) {
    return userPredictions.entries
        .map((e) => calculateScore(e.key, e.value))
        .sum;
  }

  Map<String, int> _calculateCompetitionToScore(
    Map<CompetitionModel, PredictionModel?> competitionToPrediction,
  ) =>
      competitionToPrediction
          .map((key, value) => MapEntry(key.id, calculateScore(key, value)));

  Future<Map<CompetitionModel, PredictionModel?>>
      _getUserPredictionsPerCompetition(
    String? uid,
  ) async {
    final competitions = await _databaseRepository.getCompetitions();

    final Map<CompetitionModel, PredictionModel?> competitionsToPrediction = {};

    for (var competition in competitions) {
      PredictionModel? prediction;

      switch (competition.type) {
        case CompetitionType.heat:
          prediction = await _databaseRepository.getPredictionsForHeatForUser(
              competition.id, uid);
          break;
        case CompetitionType.semifinal:
          prediction = await _databaseRepository
              .getPredictionsForSemifinalForUser(competition.id, uid);
          break;
        case CompetitionType.theFinal:
          prediction = await _databaseRepository.getPredictionsForFinalForUser(
              competition.id, uid);
          break;
      }

      if (prediction != null) {
        competitionsToPrediction[competition] = prediction;
      }
    }
    return competitionsToPrediction;
  }
}

@freezed
class ScoreControllerState with _$ScoreControllerState {
  const factory ScoreControllerState({
    @Default(true) bool loading,
    num? userScore,
  }) = _ScoreControllerState;
}

extension FilterScores on List<UserScoreEntity> {
  List<UserScoreEntity> filterNullsAndTesterAccounts() {
    return where((userScore) {
      if (userScore.username == null) {
        return false;
      }
      return !userScore.username!.contains('appletester');
    }).toList();
  }
}

extension SortScores on List<UserScoreEntity> {
  List<UserScoreEntity> sortWithNullAsZero() {
    sort((a, b) {
      var aTotalScore = a.totalScore;
      var bTotalScore = b.totalScore;
      if (aTotalScore == null || bTotalScore == null) {
        return 0;
      }
      return bTotalScore - aTotalScore;
    });

    return this;
  }
}
