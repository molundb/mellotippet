import 'package:firebase_auth/firebase_auth.dart';
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

  void restoreSession() {
    state = state.copyWith(loading: true);

    authRepository.firebaseAuth.authStateChanges().listen((User? user) {
      var loggedIn = false;
      if (user != null) {
        loggedIn = true;
      }

      state = state.copyWith(loading: false, loggedIn: false);
    });
  }

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
    await authRepository.createUserWithEmailAndPassword(
      email: state.email,
      password: state.password,
    );

    databaseRepository.createUser(state.username);
  }

  signInWithEmailAndPassword() async {
    await authRepository.signInWithEmailAndPassword(
      email: state.email,
      password: state.password,
    );
  }
}

@freezed
class LoginControllerState with _$LoginControllerState {
  const factory LoginControllerState({
    @Default(true) bool loading,
    @Default(false) bool loggedIn,
    @Default("") String username,
    @Default("") String email,
    @Default("") String password,
  }) = _LoginControllerState;
}
