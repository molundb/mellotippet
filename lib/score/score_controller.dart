import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/models/all_models.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/score/score_calculator.dart';

class ScoreController extends StateNotifier<ScoreControllerState> {
  ScoreController({
    required DatabaseRepository databaseRepository,
    ScoreControllerState? state,
  })  : _databaseRepository = databaseRepository,
        super(state ?? ScoreControllerState.withDefaults());

  final DatabaseRepository _databaseRepository;

  static final provider =
      StateNotifierProvider<ScoreController, ScoreControllerState>(
          (ref) => ScoreController(
                databaseRepository: getIt.get<DatabaseRepository>(),
              ));

  Future<void> getUserScores() async {
    state = state.copyWith(loading: true);
    final userEntities = await _getUserEntities();
    state = state.copyWith(loading: false, userScores: userEntities);
  }

  Future<List<UserScoreEntity>> _getUserEntities() async {
    final userScores = await Future.wait(
        (await _databaseRepository.getUsers()).map((user) async {
      final userPredictions = await _getUserPredictions(user.id);
      final totalScore = _calculateTotalScore(userPredictions);
      final competitionToScore = _calculateCompetitionToScore(userPredictions);

      return UserScoreEntity(
        username: user.username,
        competitionToPrediction: userPredictions,
        totalScore: totalScore,
        competitionToScore: competitionToScore,
      );
    }));

    final filteredUserScores = _filterScores(userScores);
    _sortScores(filteredUserScores);

    return filteredUserScores;
  }

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

  List<UserScoreEntity> _filterScores(List<UserScoreEntity> userScores) =>
      userScores.where((userScore) {
        if (userScore.username == null) {
          return false;
        }
        return !userScore.username!.contains('appletester');
      }).toList();

  void _sortScores(List<UserScoreEntity> filteredUserScores) =>
      filteredUserScores.sort((a, b) {
        var aTotalScore = a.totalScore;
        var bTotalScore = b.totalScore;
        if (aTotalScore == null || bTotalScore == null) {
          return 0;
        }
        return bTotalScore - aTotalScore;
      });

  Future<Map<CompetitionModel, PredictionModel?>> _getUserPredictions(
    String? uid,
  ) async {
    final competitions = await _databaseRepository.getCompetitions();

    final Map<CompetitionModel, PredictionModel?> competitionsToPrediction = {};

    for (var competition in competitions) {
      await _databaseRepository
          .predictionsForCompetition(competition.id)
          .doc(uid)
          .get()
          .then(
        (DocumentSnapshot doc) {
          var data = doc.data();

          PredictionModel? prediction;

          if (data != null) {
            switch (competition.type) {
              case CompetitionType.theFinal:
                prediction =
                    FinalPredictionModel.fromJson(data as Map<String, dynamic>);
                break;
              case CompetitionType.semifinal:
                prediction = SemifinalPredictionModel.fromJson(
                    data as Map<String, dynamic>);
                break;
              case CompetitionType.heat:
                prediction =
                    HeatPredictionModel.fromJson(data as Map<String, dynamic>);
                break;
            }
          }
          competitionsToPrediction[competition] = prediction;
        },
        onError: (e) => print("Error getting document: $e"),
      );
    }
    return competitionsToPrediction;
  }
}

@immutable
class ScoreControllerState {
  const ScoreControllerState({
    this.loading = false,
    required this.competitions,
    required this.userScores,
  });

  final bool loading;
  final CompetitionModel? competitions;
  final List<UserScoreEntity> userScores;

  ScoreControllerState copyWith({
    bool? loading,
    CompetitionModel? competitions,
    List<UserScoreEntity>? userScores,
  }) {
    return ScoreControllerState(
      loading: loading ?? this.loading,
      competitions: competitions ?? this.competitions,
      userScores: userScores ?? this.userScores,
    );
  }

  factory ScoreControllerState.withDefaults() =>
      const ScoreControllerState(competitions: null, userScores: []);
}
