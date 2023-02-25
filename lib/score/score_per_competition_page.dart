import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/config/config.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/score/score_controller.dart';
import 'package:melodifestivalen_competition/score/score_for_competition_page.dart';
import 'package:melodifestivalen_competition/styles/colors.dart';

class ScorePerCompetitionPage extends ConsumerStatefulWidget {
  final UserScoreEntity userEntity;

  const ScorePerCompetitionPage({required this.userEntity, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScorePerCompetitionPageState();
}

class _ScorePerCompetitionPageState
    extends ConsumerState<ScorePerCompetitionPage> {
  ScoreController get controller => ref.read(ScoreController.provider.notifier);
  final config = getIt.get<Config>();

  @override
  Widget build(BuildContext context) {
    var competitionIdsToScore = widget.userEntity.competitionToScore;
    var competitionToPrediction = widget.userEntity.competitionToPrediction;

    if (competitionIdsToScore == null || competitionIdsToScore.isEmpty ||
        competitionToPrediction == null || competitionToPrediction.isEmpty) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Scores',
          style: TextStyle(
            color: MelloPredixColors.melloYellow,
            fontSize: 32,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    widget.userEntity.username ?? '',
                    style: const TextStyle(
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                competitionIdsToScore.entries.map((competitionIdToScore) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute<bool>(
                          builder: (BuildContext context) {
                            // Get result
                            // get prediction
                            // get score per prediction

                            final competition = competitionToPrediction.keys.firstWhere((e) =>
                            e.id == competitionIdToScore.key);
                            final result = competition.result;
                            final prediction = competitionToPrediction[competition];

                            return ScoreForCompetitionPage(
                              result: result,
                              prediction: prediction,
                            );
                          },
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: MelloPredixColors.melloOrange),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                5.0,
                              ), //
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                competitionIdToScore.key,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const Spacer(),
                              Text(
                                '${competitionIdToScore.value.toString()}p',
                                style: const TextStyle(fontSize: 24),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
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
