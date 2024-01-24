import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/config/config.dart';
import 'package:mellotippet/force_upgrade/force_upgrade_page.dart';
import 'package:mellotippet/prediction/final_prediction_controller.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/theme.dart';

class MellotippetApp extends StatelessWidget {
  final config = getIt.get<Config>();
  final snackbarKey = getIt.get<GlobalKey<ScaffoldMessengerState>>();

  MellotippetApp({super.key});

  @override
  Widget build(BuildContext context) {
    const theme = MelloTippetTheme();
    return EagerSongFetcher(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: MaterialApp(
          title: config.title,
          scaffoldMessengerKey: snackbarKey,
          theme: theme.toThemeData(),
          home: const ForceUpgradePage(),
        ),
      ),
    );
  }
}

class EagerSongFetcher extends ConsumerStatefulWidget {
  final Widget child;

  const EagerSongFetcher({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EagerSongFetcherState();
}

class _EagerSongFetcherState extends ConsumerState<EagerSongFetcher> {
  FinalPredictionController get controller =>
      ref.read(FinalPredictionController.provider.notifier);

  @override
  void initState() {
    super.initState();
    controller.fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
