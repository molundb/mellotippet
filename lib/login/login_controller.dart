import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/service_location/get_it.dart';

part 'login_controller.freezed.dart';

class LoginController extends StateNotifier<LoginControllerState> {
  LoginController({
    required this.authRepository,
    required this.databaseRepository,
    LoginControllerState? state,
  }) : super(state ?? const LoginControllerState());

  final AuthenticationRepository authRepository;
  final DatabaseRepository databaseRepository;

  static final provider =
      StateNotifierProvider<LoginController, LoginControllerState>(
          (ref) => LoginController(
                authRepository: getIt.get<AuthenticationRepository>(),
                databaseRepository: getIt.get<DatabaseRepository>(),
              ));

  void updateUsername(String? username) {
    if (username == null) return;

    state = state.copyWith(username: username);
  }

  void updateEmail(String? email) {
    if (email == null) return;

    state = state.copyWith(email: email);
  }

  void updatePassword(String? password) {
    if (password == null) return;

    state = state.copyWith(password: password);
  }

  Future<bool> isUsernameAlreadyTaken() async {
    final user = await databaseRepository.getUserWithUsername(state.username);
    return user != null;
  }

  createUserWithEmailAndPassword() async {
    state = state.copyWith(loading: true, accountCreated: false);

    if (await isUsernameAlreadyTaken()) {
      state = state.copyWith(
          loading: false,
          snackBarText: 'Användarnamnet är tyvärr upptaget, prova ett annat.');
      return;
    }

    try {
      await authRepository.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      await databaseRepository.createUser(state.username);
    } catch (e) {
      state =
          state.copyWith(loading: false, snackBarText: 'Något gick fel: $e');
      return;
    }

    state = state.copyWith(loading: false, accountCreated: true);
  }

  signInWithEmailAndPassword() async {
    await authRepository.signInWithEmailAndPassword(
      email: state.email,
      password: state.password,
    );
  }

  clearSnackBarText() {
    state = state.copyWith(snackBarText: '');
  }
}

@freezed
class LoginControllerState with _$LoginControllerState {
  const factory LoginControllerState({
    @Default(false) bool loading,
    @Default(false) bool accountCreated,
    @Default("") String snackBarText,
    @Default("") String username,
    @Default("") String email,
    @Default("") String password,
  }) = _LoginControllerState;
}
