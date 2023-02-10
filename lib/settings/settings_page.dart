import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/widgets/cta_button.dart';
import 'package:melodifestivalen_competition/login/login_page.dart';
import 'package:melodifestivalen_competition/settings/settings_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final controller = SettingsController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CtaButton(
        text: 'Sign Out',
        onPressed: () => _logoutPressed(),
      ),
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
