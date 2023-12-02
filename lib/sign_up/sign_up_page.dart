import 'package:flutter/material.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/common/widgets/old_cta_button.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/mello_bottom_navigation_bar.dart';
import 'package:mellotippet/sign_up/sign_up_controller.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _UsernameInput(
                  controller: controller,
                  usernameController: _usernameController,
                ),
                const SizedBox(height: 30.0),
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
                  formKey: _formKey,
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  final SignUpController controller;
  final TextEditingController usernameController;

  const _UsernameInput({
    required this.controller,
    required this.usernameController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: usernameController,
      decoration: const InputDecoration(hintText: 'Username'),
      onSaved: controller.updateUsername,
    );
  }
}

class _CreateAccountEmail extends StatelessWidget {
  final SignUpController controller;
  final TextEditingController emailController;

  const _CreateAccountEmail({
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

class _CreateAccountPassword extends StatelessWidget {
  final SignUpController controller;
  final TextEditingController passwordController;

  const _CreateAccountPassword({
    required this.controller,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Password'),
      onSaved: controller.updatePassword,
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final SignUpController controller;

  final AuthenticationRepository _authRepository =
      getIt.get<AuthenticationRepository>();

  final DatabaseRepository _databaseRepository =
      getIt.get<DatabaseRepository>();

  _SubmitButton({
    required this.formKey,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return OldCtaButton(
      text: 'Create Account',
      onPressed: () => _submitPressed(context, formKey),
    );
  }

  Future<void> _submitPressed(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    // if (!_validateForm()) return;
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
        email: controller.email,
        password: controller.password,
      );

      final uid = _authRepository.currentUser?.uid;

      _databaseRepository.users.doc(uid).set({
        "username": controller.username,
      });

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
}
