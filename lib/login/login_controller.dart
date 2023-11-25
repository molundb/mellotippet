import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/service_location/get_it.dart';

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
        state = state.copyWith(loading: false, loggedIn: true);
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

@immutable
class LoginControllerState {
  const LoginControllerState({
    this.loading = true,
    this.loggedIn = false,
    this.email = "",
    this.password = "",
  });

  final bool loading;
  final bool loggedIn;
  final String email;
  final String password;

  LoginControllerState copyWith({
    bool? loading,
    bool? loggedIn,
    String? email,
    String? password,
  }) {
    return LoginControllerState(
      loading: loading ?? this.loading,
      loggedIn: loggedIn ?? this.loggedIn,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
