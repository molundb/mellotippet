import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:mellotippet/common/repositories/feature_flag_repository.dart';
import 'package:mellotippet/dependency_injection/get_it.dart';
import 'package:mellotippet/login/login_page.dart';
import 'package:mellotippet/services/mello_tippet_package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpgradePage extends StatefulWidget {
  const ForceUpgradePage({super.key});

  @override
  State<ForceUpgradePage> createState() => _ForceUpgradeState();
}

class _ForceUpgradeState extends State<ForceUpgradePage> {
  final packageInfo = getIt.get<MellotippetPackageInfo>();
  final featureFlagRepository = getIt.get<FeatureFlagRepository>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var appVersion = _getExtendedVersionNumber(packageInfo.version);
      var requiredMinVersion = _getExtendedVersionNumber(
          featureFlagRepository.getRequiredMinimumVersion());
      var recommendedMinVersion = _getExtendedVersionNumber(
          featureFlagRepository.getRecommendedMinimumVersion());

      if (appVersion < requiredMinVersion) {
        _showUpdateVersionDialog(context, false);
      } else if (appVersion < recommendedMinVersion) {
        _showUpdateVersionDialog(context, true);
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

  Future<void> _showUpdateVersionDialog(
      BuildContext context, bool isSkippable) async {
    String store;

    if (Platform.isAndroid) {
      store = "Google Play Console";
    } else {
      store = "App Store";
    }

    String text;
    if (isSkippable) {
      text = "Det finns en ny version tillgänglig i $store. Uppdatera nu!";
    } else {
      text =
          "Det finns en ny obligatorisk version tillgänglig i $store. Uppdatera för att kunna fortsätta att använda appen!";
    }

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
