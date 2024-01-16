import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/common/widgets/cta_button.dart';
import 'package:mellotippet/config/config.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/login/login_controller.dart';
import 'package:mellotippet/mello_bottom_navigation_bar.dart';
import 'package:mellotippet/sign_up/sign_up_page.dart';
import 'package:mellotippet/styles/colors.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MellotippetColors.melloLightPink,
              MellotippetColors.melloPurple
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Spacer(),
                const Text(
                  'Mellotippet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontFamily: 'Lalezar',
                  ),
                ),
                _InputField(
                  label: 'Email',
                  onSaved: controller.updateEmail,
                  textEditingController: _emailController,
                ),
                const SizedBox(height: 24.0),
                _InputField(
                  label: 'Lösenord',
                  onSaved: controller.updatePassword,
                  textEditingController: _passwordController,
                ),
                const SizedBox(height: 84.0),
                _SubmitButton(
                  formKey: _formKey,
                  state: state,
                ),
                const Spacer(),
                const _CreateAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final Function(String?)? onSaved;
  final TextEditingController textEditingController;

  const _InputField({
    required this.label,
    required this.onSaved,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textEditingController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
          onSaved: onSaved,
        ),
      ],
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
      text: 'Logga in',
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
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'Inget konto? Registrera dig här',
        style: TextStyle(color: Colors.white),
      ),
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