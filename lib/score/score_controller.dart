import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/common/widgets/reusable_app_bar/reusable_app_bar_controller.dart';
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
      StateNotifierProvider<ScoreController, ScoreControllerState>((ref) {
    final appBarState = ref.watch(ReusableAppBarController.provider);
    var first = true;
    final scoreController = ScoreController(
      authRepository: getIt.get<AuthenticationRepository>(),
      databaseRepository: getIt.get<DatabaseRepository>(),
      state: ScoreControllerState(
          loading: first ||
              appBarState
                  .loading), // TODO: Confirm this doesn't work and fix it
    );
    first = false;
    return scoreController;
  });

  Future<void> getUserScore() async {
    final userScore = (await databaseRepository.getCurrentUser()).totalScore;
    state = state.copyWith(loading: false, userScore: userScore);
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
