import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/service_location/get_it.dart';

part 'login_controller.freezed.dart';

class LoginController extends StateNotifier<LoginControllerState> {
  LoginController({
    required this.authRepository,
    LoginControllerState? state,
  }) : super(state ?? const LoginControllerState());

  final AuthenticationRepository authRepository;

  static final provider =
      StateNotifierProvider<LoginController, LoginControllerState>(
          (ref) => LoginController(
                authRepository: getIt.get<AuthenticationRepository>(),
              ));

  void restoreSession() {
    state = state.copyWith(loading: true);
    authRepository.firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        state = state.copyWith(loading: false, loggedIn: false);
      } else {
        state = state.copyWith(loading: false, loggedIn: false);
      }
    });
  }

  void updateEmail(String? email) {
    if (email == null) return;

    state = state.copyWith(email: email);
  }

  void updatePassword(String? password) {
    if (password == null) return;

    state = state.copyWith(password: password);
  }
}

@freezed
class LoginControllerState with _$LoginControllerState {
  const factory LoginControllerState({
    @Default(true) bool loading,
    @Default(false) bool loggedIn,
    @Default("") String email,
    @Default("") String password,
  }) = _LoginControllerState;
}
