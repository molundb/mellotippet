import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mellotippet/common/widgets/login_or_sign_up_page.dart';
import 'package:mellotippet/login/login_controller.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SignUpPageState();
}

class SignUpPageState extends ConsumerState<SignUpPage> {
  LoginController get controller => ref.read(LoginController.provider.notifier);

  @override
  Widget build(BuildContext context) {
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
    if (await controller.isUsernameAlreadyTaken()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username is already taken.'),
          ),
        );
      }
      return;
    }

    try {
      await controller.createUserWithEmailAndPassword();

      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  void _pop(BuildContext context) {
    context.pop();
  }
}
