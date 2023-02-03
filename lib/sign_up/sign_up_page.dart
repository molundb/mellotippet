import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/common/repositories/repositories.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/mello_bottom_navigation_bar.dart';
import 'package:melodifestivalen_competition/sign_up/sign_up_controller.dart';

final _formKey = GlobalKey<FormState>();

class SignUpPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SignUpController controller = SignUpController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CreateAccountEmail(
                controller: controller,
                emailController: _emailController,
              ),
              const SizedBox(height: 30.0),
              _CreateAccountPassword(
                controller: controller,
                passwordController: _passwordController,
              ),
              const SizedBox(height: 30.0),
              _SubmitButton(
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateAccountEmail extends StatelessWidget {
  final SignUpController controller;
  final TextEditingController emailController;

  const _CreateAccountEmail({
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

class _CreateAccountPassword extends StatelessWidget {
  final SignUpController controller;
  final TextEditingController passwordController;

  const _CreateAccountPassword({
    super.key,
    required this.controller,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(hintText: 'Password'),
        onSaved: controller.updatePassword,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final SignUpController controller;

  final AuthenticationRepository _authRepository =
      getIt.get<AuthenticationRepository>();

  _SubmitButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _submitPressed(context),
      child: const Text('Create Account'),
    );
  }

  Future<void> _submitPressed(BuildContext context) async {
    // if (!_validateForm()) return;
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();

    FocusScope.of(context).unfocus();

    {
      try {
        await _authRepository.createUserWithEmailAndPassword(
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
