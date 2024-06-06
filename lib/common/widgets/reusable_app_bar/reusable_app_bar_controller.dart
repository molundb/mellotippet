import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/authentication_repository.dart';
import 'package:mellotippet/common/repositories/database_repository.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reusable_app_bar_controller.freezed.dart';
part 'reusable_app_bar_controller.g.dart';

@riverpod
class ReusableAppBarController extends _$ReusableAppBarController {
  @override
  ReusableAppBarControllerState build() =>
      const ReusableAppBarControllerState();

  final AuthenticationRepository authRepository =
      getIt.get<AuthenticationRepository>();
  final DatabaseRepository databaseRepository = getIt.get<DatabaseRepository>();

  void signOut() {
    authRepository.signOut();
  }

  void deleteUserInfoAndAccount() async {
    state = state.copyWith(loading: true);
    final result = await databaseRepository
        .deleteUserInfoAndAccount(authRepository.currentUser?.uid);
    if (result.isLeft()) {
      state = state.copyWith(loading: false, snackBarText: "Error");
    } else {
      state = state.copyWith(loading: false);
    }
    // state = result.match(
    //         (error) => AsyncError(error, StackTrace.current),
    //         (r) => r);
  }
}

@freezed
class ReusableAppBarControllerState with _$ReusableAppBarControllerState {
  const factory ReusableAppBarControllerState({
    @Default(false) bool loading,
    @Default("") String snackBarText,
  }) = _ReusableAppBarControllerState;
}
