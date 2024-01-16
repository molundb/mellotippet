import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/common/widgets/login_or_sign_up_page.dart';
import 'package:mellotippet/login/login_controller.dart';
import 'package:mellotippet/mello_bottom_navigation_bar.dart';
import 'package:mellotippet/service_location/get_it.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SignUpPageState();
}

class SignUpPageState extends ConsumerState<SignUpPage> {
  final AuthenticationRepository _authRepository =
      getIt.get<AuthenticationRepository>();

  final DatabaseRepository _databaseRepository =
      getIt.get<DatabaseRepository>();

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
    LoginControllerState state,
  ) async {
    final FormState? form = formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();
    FocusScope.of(context).unfocus();

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
      await _authRepository.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      _databaseRepository.setUsername(state.username);

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MelloBottomNavigationBar(),
          ),
          ModalRoute.withName('/'),
        );
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
    Navigator.pop(context);
  }
}
