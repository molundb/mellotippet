import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/cta_button.dart';
import 'package:mellotippet/config/config.dart';
import 'package:mellotippet/login/login_controller.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/styles/colors.dart';

class LoginOrSignUpPage extends ConsumerStatefulWidget {
  final String ctaText;
  final Function(
    BuildContext context,
    GlobalKey<FormState> formKey,
    LoginControllerState state,
  ) ctaAction;
  final String bottomText;
  final Function(BuildContext context) bottomAction;
  final bool showUsernameField;

  const LoginOrSignUpPage({
    super.key,
    required this.ctaText,
    required this.ctaAction,
    required this.bottomText,
    required this.bottomAction,
    this.showUsernameField = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginOrSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final config = getIt.get<Config>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginController get controller => ref.read(LoginController.provider.notifier);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(LoginController.provider);

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
                if (widget.showUsernameField) ...[
                  _InputField(
                    label: 'Användarnamn',
                    onSaved: controller.updateUsername,
                    textEditingController: _usernameController,
                  ),
                  const SizedBox(height: 24.0),
                ],
                _InputField(
                  label: 'Email',
                  onSaved: controller.updateEmail,
                  textEditingController: _emailController,
                ),
                const SizedBox(height: 24.0),
                _InputField(
                  label: 'Lösenord',
                  obscureText: true,
                  onSaved: controller.updatePassword,
                  textEditingController: _passwordController,
                ),
                const SizedBox(height: 84.0),
                _SubmitButton(
                  formKey: _formKey,
                  state: state,
                  buttonText: widget.ctaText,
                  buttonAction: widget.ctaAction,
                ),
                const Spacer(),
                _BottomButton(
                  buttonText: widget.bottomText,
                  buttonAction: widget.bottomAction,
                ),
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
  final bool obscureText;
  final Function(String?)? onSaved;
  final TextEditingController textEditingController;

  const _InputField({
    required this.label,
    this.obscureText = false,
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
          obscureText: obscureText,
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
  final String buttonText;
  final Function(
    BuildContext context,
    GlobalKey<FormState> formKey,
    LoginControllerState state,
  ) buttonAction;

  const _SubmitButton({
    required this.formKey,
    required this.state,
    required this.buttonText,
    required this.buttonAction,
  });

  @override
  Widget build(BuildContext context) {
    return CtaButton(
      text: buttonText,
      onPressed: () => buttonAction(context, formKey, state),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final String buttonText;
  final Function(BuildContext context) buttonAction;

  const _BottomButton({
    required this.buttonText,
    required this.buttonAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        buttonText,
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: () => buttonAction(context),
    );
  }
}
