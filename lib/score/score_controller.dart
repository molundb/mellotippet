import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'score_controller.freezed.dart';
part 'score_controller.g.dart';

@riverpod
class ScoreController extends _$ScoreController {
  @override
  ScoreControllerState build() => const ScoreControllerState();

  final AuthenticationRepository authRepository =
      getIt.get<AuthenticationRepository>();

  final DatabaseRepository databaseRepository = getIt.get<DatabaseRepository>();

  // static final provider =
  //     StateNotifierProvider<ScoreController, ScoreControllerState>((ref) {
  //   final appBarState = ref.watch(ReusableAppBarController.provider);
  //   var first = true;
  //   final scoreController = ScoreController(
  //     authRepository: getIt.get<AuthenticationRepository>(),
  //     databaseRepository: getIt.get<DatabaseRepository>(),
  //     state: ScoreControllerState(
  //         loading: first ||
  //             appBarState
  //                 .loading), // TODO: Confirm this doesn't work and fix it
  //   );
  //   first = false;
  //   return scoreController;
  // });

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
