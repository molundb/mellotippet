import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/repositories/feature_flag_repository.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/force_upgrade/force_upgrade_controller.dart';
import 'package:melodifestivalen_competition/login/login_page.dart';
import 'package:melodifestivalen_competition/services/mello_tippet_package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpgradePage extends ConsumerStatefulWidget {
  const ForceUpgradePage({super.key});

  @override
  ConsumerState<ForceUpgradePage> createState() => _ForceUpgradeState();
}

class _ForceUpgradeState extends ConsumerState<ForceUpgradePage> {
  ForceUpgradeController get controller =>
      ref.read(ForceUpgradeController.provider.notifier);

  final packageInfo = getIt.get<MellotippetPackageInfo>();
  final featureFlagRepository = getIt.get<FeatureFlagRepository>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.checkIfUpdateRequiredOrRecommended();
      var appVersion = _getExtendedVersionNumber(packageInfo.version);
      var requiredMinVersion = _getExtendedVersionNumber(
          featureFlagRepository.getRequiredMinimumVersion());
      var recommendedMinVersion = _getExtendedVersionNumber(
          featureFlagRepository.getRecommendedMinimumVersion());

      if (appVersion < requiredMinVersion) {
        _showMyDialog(context, false);
      } else if (appVersion < recommendedMinVersion) {
        _showMyDialog(context, true);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  Future<void> _showMyDialog(BuildContext context, bool isSkippable) async {
    String store;

    if (Platform.isAndroid) {
      store = "Google Play Console";
    } else {
      store = "App Store";
    }

    String text =
        "Det finns en ny version tillgänglig i $store. Ladda ned den nu!";

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ny version tillgänglig"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            isSkippable
                ? TextButton(
                    child: const Text('Inte än'),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  )
                : Container(),
            TextButton(
              child: const Text('Uppdatera'),
              onPressed: () {
                if (Platform.isAndroid || Platform.isIOS) {
                  // TODO: Add appIDs and enable
                  // final appId = Platform.isAndroid
                  //     ? 'com.molundb.melodifestivalen_competition'
                  //     : 'com.molundb.melodifestivalen-competition';

                  // final appId = Platform.isAndroid
                  //     ? 'com.instagram.android'
                  //     : '389801252';
                  //
                  // final url = Uri.parse(
                  //   Platform.isAndroid
                  //       ? "https://play.google.com/store/apps/details?id=$appId"
                  //       : "https://apps.apple.com/app/id$appId",

                  final url = Uri.parse(
                    Platform.isAndroid
                        ? "https://play.google.com/store/apps"
                        : "https://apps.apple.com/",
                  );
                  launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

int _getExtendedVersionNumber(String version) {
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
}
