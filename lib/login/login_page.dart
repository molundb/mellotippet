import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/common/repositories/authentication/authentication_repository.dart';
import 'package:melodifestivalen_competition/config/config.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/login/login_controller.dart';
import 'package:melodifestivalen_competition/mello_bottom_navigation_bar.dart';
import 'package:melodifestivalen_competition/sign_up/sign_up_page.dart';

final _formKey = GlobalKey<FormState>();

class LoginPage extends StatelessWidget {
  final config = getIt.get<Config>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController controller = LoginController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  controller: controller,
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
    super.key,
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
  final LoginController controller;

  final AuthenticationRepository _authRepository =
      getIt.get<AuthenticationRepository>();

  _SubmitButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: () => _loginPressed(context),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
        ),
        child: const Text('Login'),
      ),
    );
  }

  Future<void> _loginPressed(BuildContext context) async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();

    FocusScope.of(context).unfocus();

    {
      try {
        await _authRepository.signInWithEmailAndPassword(
          email: controller.email,
          password: controller.password,
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
  const _CreateAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: () => _createAccountPressed(context),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
        ),
        child: const Text('Create Account'),
      ),
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

  _ContinueWithoutAccountButton({super.key});

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
      final user = await _authRepository.signInAnonymously();

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
