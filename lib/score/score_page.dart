import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/score_old/score_controller_old.dart';
import 'package:mellotippet/score_old/score_per_competition_page.dart';
import 'package:mellotippet/styles/colors.dart';

class ScorePage extends ConsumerStatefulWidget {
  const ScorePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScorePageState();
}

class _ScorePageState extends ConsumerState<ScorePage> {
  ScoreControllerOld get controller =>
      ref.read(ScoreControllerOld.provider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUserScore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ScoreControllerOld.provider);

    // TODO: Figure out how to handle loading

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Column(
              children: [
                Text(
                  'Highscore',
                  style: TextStyle(
                    fontSize: 32,
                    color: MellotippetColors.melloLightOrange,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: state.userScores.length,
              (context, index) => Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute<bool>(
                          builder: (BuildContext context) =>
                              ScorePerCompetitionPage(
                                  userEntity: state.userScores[index]),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: MellotippetColors.melloDarkOrange),
                        borderRadius: const BorderRadius.all(Radius.circular(
                                5.0) //                 <--- border radius here
                            ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}. ${state.userScores[index].username ?? ''}',
                              style: const TextStyle(fontSize: 24),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${state.userScores[index].totalScore}p',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
