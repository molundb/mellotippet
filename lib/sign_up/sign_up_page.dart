import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mellotippet/common/widgets/login_or_sign_up_page.dart';
import 'package:mellotippet/login/login_controller.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  LoginController get controller => ref.read(loginControllerProvider.notifier);

  @override
  Widget build(BuildContext context) {
    ref.listen(loginControllerProvider, (previous, next) {
      if (previous?.accountCreated == false && next.accountCreated) {
        context.pop();
      }

      if (next.snackBarText != '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.snackBarText),
          ),
        );
        controller.clearSnackBarText();
      }
    });

    return LoginOrSignUpPage(
      ctaText: 'Registrera konto',
      ctaAction: _registerAccount,
      bottomText: 'Tillbaka till login',
      bottomAction: _pop,
      showUsernameField: true,
    );
  }

  Future<void> _registerAccount(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    await controller.createUserWithEmailAndPassword();
  }

  void _pop(BuildContext context) {
    context.pop();
  }
}
