import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/service_location/get_it.dart';

part 'score_controller.freezed.dart';

class ScoreController extends StateNotifier<ScoreControllerState> {
  ScoreController({
    required DatabaseRepositoryImpl databaseRepository,
    ScoreControllerState? state,
  })  : _databaseRepository = databaseRepository,
        super(state ?? const ScoreControllerState());

  final DatabaseRepositoryImpl _databaseRepository;

  static final provider =
      StateNotifierProvider<ScoreController, ScoreControllerState>(
          (ref) => ScoreController(
                databaseRepository: getIt.get<DatabaseRepositoryImpl>(),
              ));

  Future<void> getUserScore() async {
    final userScore = await _getUserScore();
    state = state.copyWith(loading: false, userScore: userScore);
  }

  Future<num> _getUserScore() async {
    final user = await _databaseRepository.getCurrentUser();
    return user.totalScore;
  }
}

@freezed
class ScoreControllerState with _$ScoreControllerState {
  const factory ScoreControllerState({
    @Default(true) bool loading,
    num? userScore,
  }) = _ScoreControllerState;
}
