import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/service_location/get_it.dart';

part 'score_controller.freezed.dart';

class ScoreController extends StateNotifier<ScoreControllerState> {
  ScoreController({
    required this.authRepository,
    required this.databaseRepository,
    ScoreControllerState? state,
  }) : super(state ?? const ScoreControllerState());

  final AuthenticationRepository authRepository;
  final DatabaseRepository databaseRepository;

  static final provider =
      StateNotifierProvider<ScoreController, ScoreControllerState>(
          (ref) => ScoreController(
                authRepository: getIt.get<AuthenticationRepository>(),
                databaseRepository: getIt.get<DatabaseRepository>(),
              ));

  Future<void> getUserScore() async {
    final userScore = await _getUserScore();
    state = state.copyWith(loading: false, userScore: userScore);
  }

  Future<num> _getUserScore() async {
    final user = await databaseRepository.getCurrentUser();
    return user.totalScore;
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }
}

@freezed
class ScoreControllerState with _$ScoreControllerState {
  const factory ScoreControllerState({
    @Default(true) bool loading,
    num? userScore,
  }) = _ScoreControllerState;
}
