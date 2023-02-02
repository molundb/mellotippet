import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/controllers/login_controller.dart';
import 'package:melodifestivalen_competition/mello_bottom_navigation_bar.dart';
import 'package:melodifestivalen_competition/pages/sign_up_page.dart';
import 'package:melodifestivalen_competition/services/auth_service.dart';
import 'package:melodifestivalen_competition/services/firebase_auth_service.dart';

final _formKey = GlobalKey<FormState>();

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginController controller = LoginController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
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
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextFormField(
        controller: emailController,
        decoration: const InputDecoration(hintText: 'Email'),
        onSaved: controller.updateEmail,
      ),
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
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Password',
        ),
        onSaved: controller.updatePassword,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final LoginController controller;

  final AuthService _authService = FirebaseAuthService(
    authService: FirebaseAuth.instance,
  );

  _SubmitButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _loginPressed(context),
      child: const Text('Login'),
    );
  }

  Future<void> _loginPressed(BuildContext context) async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();

    FocusScope.of(context).unfocus();

    {
      try {
        await _authService.signInWithEmailAndPassword(
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
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUpPage(),
          ),
        );
      },
      child: const Text('Create Account'),
    );
  }
}
