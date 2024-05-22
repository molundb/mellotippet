import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/old_cta_button.dart';
import 'package:mellotippet/settings/settings_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  SettingsController get controller =>
      ref.read(settingsControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAppVersion();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsControllerProvider);

    return Column(
      children: [
        Expanded(
          child: Center(
            child: OldCtaButton(
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
  }
}
