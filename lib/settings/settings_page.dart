import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/cta_button.dart';
import 'package:mellotippet/login/login_page.dart';
import 'package:mellotippet/settings/settings_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  SettingsController get controller =>
      ref.read(SettingsController.provider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAppVersion();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(SettingsController.provider);

    return Column(
      children: [
        Expanded(
          child: Center(
            child: CtaButton(
              text: 'Sign Out',
              onPressed: () => _logoutPressed(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text("Version: ${state.appVersion}")),
        ),
      ],
    );
  }

  void _logoutPressed() async {
    await controller.signOut();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}
