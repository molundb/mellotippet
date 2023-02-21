import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';

class ScoreController extends StateNotifier<ScoreControllerState> {
  ScoreController({
    required DatabaseRepository databaseRepository,
    ScoreControllerState? state,
  }) : _databaseRepository = databaseRepository, super(state ?? ScoreControllerState.withDefaults());

  final DatabaseRepository _databaseRepository;

  static final provider =
      StateNotifierProvider<ScoreController, ScoreControllerState>(
          (ref) => ScoreController(
                databaseRepository: getIt.get<DatabaseRepository>(),
              ));

  Future<void> getUserScores() async {
    state = state.copyWith(loading: true);
    final userScores = await _databaseRepository.getUserScores();
    state = state.copyWith(loading: false, userScores: userScores);
  }
}

@immutable
class ScoreControllerState {
  const ScoreControllerState({
    this.loading = false,
    required this.userScores,
  });

  final bool loading;
  final List<UserEntity> userScores;

  ScoreControllerState copyWith({
    bool? loading,
    List<UserEntity>? userScores,
  }) {
    return ScoreControllerState(
      loading: loading ?? this.loading,
      userScores: userScores ?? this.userScores,
    );
  }

  factory ScoreControllerState.withDefaults() =>
      const ScoreControllerState(userScores: []);
}
