import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mellotippet/common/widgets/login_or_sign_up_page.dart';
import 'package:mellotippet/login/login_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  LoginController get controller => ref.read(LoginController.provider.notifier);

  @override
  Widget build(BuildContext context) {
    return LoginOrSignUpPage(
      ctaText: 'Logga in',
      ctaAction: _loginPressed,
      bottomText: 'Inget konto? Registrera dig här',
      bottomAction: _createAccountPressed,
    );
  }

  Future<void> _loginPressed(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    try {
      await controller.signInWithEmailAndPassword();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void _createAccountPressed(BuildContext context) {
    context.push('/signUp');
  }
}
