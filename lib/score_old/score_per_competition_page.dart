import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/config/config.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/score_old/score_controller_old.dart';
import 'package:mellotippet/score_old/score_for_competition_page.dart';
import 'package:mellotippet/styles/colors.dart';

class ScorePerCompetitionPage extends ConsumerStatefulWidget {
  final UserScoreEntity userEntity;

  const ScorePerCompetitionPage({required this.userEntity, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScorePerCompetitionPageState();
}

class _ScorePerCompetitionPageState
    extends ConsumerState<ScorePerCompetitionPage> {
  ScoreControllerOld get controller =>
      ref.read(ScoreControllerOld.provider.notifier);
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
        title: Text(
          widget.userEntity.username ?? '',
          style: const TextStyle(
            color: MellotippetColors.melloLightOrange,
            fontSize: 32,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                competitionIdsToScore.entries.map((competitionIdToScore) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute<bool>(
                          builder: (BuildContext context) {
                            final competition = competitionToPrediction.keys.firstWhere((e) =>
                            e.id == competitionIdToScore.key);
                            final prediction = competitionToPrediction[competition];

                            return ScoreForCompetitionPage(
                              competition: competition,
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
                                color: MellotippetColors.melloDarkOrange),
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