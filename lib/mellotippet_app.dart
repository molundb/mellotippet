import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/repositories/feature_flag_repository.dart';
import 'package:mellotippet/config/config.dart';
import 'package:mellotippet/force_upgrade/force_upgrade_page.dart';
import 'package:mellotippet/prediction/final_prediction_controller.dart';
import 'package:mellotippet/prediction/heat_prediction_controller.dart';
import 'package:mellotippet/prediction/semifinal_prediction_controller.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/theme.dart';

import 'prediction/prediction_page/prediction_controller.dart';

class MellotippetApp extends StatelessWidget {
  final config = getIt.get<Config>();
  final snackbarKey = getIt.get<GlobalKey<ScaffoldMessengerState>>();

  MellotippetApp({super.key});

  final CompetitionType? competitionType = CompetitionType.values
      .firstWhereOrNull((element) =>
          element.name ==
          getIt.get<FeatureFlagRepository>().getCurrentCompetition());

  @override
  Widget build(BuildContext context) {
    const theme = MelloTippetTheme();
    return EagerSongFetcher(
      currentCompetitionType: competitionType ?? CompetitionType.heat,
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
  final CompetitionType currentCompetitionType;

  const EagerSongFetcher({
    super.key,
    required this.child,
    required this.currentCompetitionType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EagerSongFetcherState();
}

class _EagerSongFetcherState extends ConsumerState<EagerSongFetcher> {
  @override
  void initState() {
    super.initState();
    getCorrectPredictionController().fetchSongs(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  PredictionController getCorrectPredictionController() {
    switch (widget.currentCompetitionType) {
      case CompetitionType.heat:
        return ref.read(HeatPredictionController.provider.notifier);
      case CompetitionType.semifinal:
        return ref.read(SemifinalPredictionController.provider.notifier);
      case CompetitionType.theFinal:
        return ref.read(FinalPredictionController.provider.notifier);
    }
  }
}
