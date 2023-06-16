import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';
import 'package:melodifestivalen_competition/common/widgets/widgets.dart';
import 'package:melodifestivalen_competition/config/config.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/login/login_controller.dart';
import 'package:melodifestivalen_competition/mello_bottom_navigation_bar.dart';
import 'package:melodifestivalen_competition/sign_up/sign_up_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final config = getIt.get<Config>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

    return Scaffold(
      appBar: AppBar(
        title: Text(config.title),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LoginEmail(
                  controller: controller,
                  emailController: _emailController,
                ),
                const SizedBox(height: 30.0),
                _LoginPassword(
                  controller: controller,
                  passwordController: _passwordController,
                ),
                const SizedBox(height: 30.0),
                _SubmitButton(
                  formKey: _formKey,
                  state: state,
                ),
                const SizedBox(height: 30.0),
                const _CreateAccountButton(),
                // const SizedBox(height: 30.0),
                // _ContinueWithoutAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginEmail extends StatelessWidget {
  final LoginController controller;
  final TextEditingController emailController;

  const _LoginEmail({
    required this.controller,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(hintText: 'Email'),
      onSaved: controller.updateEmail,
    );
  }
}

class _LoginPassword extends StatelessWidget {
  final LoginController controller;
  final TextEditingController passwordController;

  const _LoginPassword({
    Key? key,
    required this.controller,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      onSaved: controller.updatePassword,
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final LoginControllerState state;

  final AuthenticationRepository _authRepository =
      getIt.get<AuthenticationRepository>();

  _SubmitButton({
    required this.formKey,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return CtaButton(
      text: 'Login',
      onPressed: () => _loginPressed(
        context,
        formKey,
        state,
      ),
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

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MelloBottomNavigationBar(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      text: 'Create Account',
      onPressed: () => _createAccountPressed(context),
    );
  }

  Future<dynamic> _createAccountPressed(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpPage(),
      ),
    );
  }
}

class _ContinueWithoutAccountButton extends StatelessWidget {
  final AuthenticationRepository _authRepository =
      getIt.get<AuthenticationRepository>();

  _ContinueWithoutAccountButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: () => _continueWithoutAccountPressed(context),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
        ),
        child: const Text('Continue Without Account'),
      ),
    );
  }

  Future<dynamic> _continueWithoutAccountPressed(BuildContext context) async {
    try {
      await _authRepository.signInAnonymously();

      return Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MelloBottomNavigationBar(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
