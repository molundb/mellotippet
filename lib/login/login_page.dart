import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/common/widgets/login_or_sign_up_page.dart';
import 'package:mellotippet/config/config.dart';
import 'package:mellotippet/login/login_controller.dart';
import 'package:mellotippet/mello_bottom_navigation_bar.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/sign_up/sign_up_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final AuthenticationRepository _authRepository =
      getIt.get<AuthenticationRepository>();

  final config = getIt.get<Config>();

  LoginController get controller => ref.read(LoginController.provider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.restoreSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(LoginController.provider);

    ref.listen<LoginControllerState>(LoginController.provider,
        (previous, next) {
      if (next.loggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MelloBottomNavigationBar(),
          ),
        );
      }
    });

    if (state.loading) {
      return const CircularProgressIndicator();
    }

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
    LoginControllerState state,
  ) async {
    final FormState? form = formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();
    FocusScope.of(context).unfocus();

    {
      try {
        await _authRepository.signInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );

        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MelloBottomNavigationBar(),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  void _createAccountPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      ),
    );
  }
}
