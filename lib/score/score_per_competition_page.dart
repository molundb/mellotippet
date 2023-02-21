import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/score/score_controller.dart';

class ScorePerCompetitionPage extends ConsumerStatefulWidget {
  final UserEntity userEntity;

  const ScorePerCompetitionPage({required this.userEntity, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScorePerCompetitionPageState();
}

class _ScorePerCompetitionPageState
    extends ConsumerState<ScorePerCompetitionPage> {
  ScoreController get controller => ref.read(ScoreController.provider.notifier);

  @override
  Widget build(BuildContext context) {
    var competitionToScore = widget.userEntity.competitionToScore;

    if (competitionToScore == null) {
      return Container();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                competitionToScore.entries.map((element) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(element.key),
                      Text(element.value.toString()),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
