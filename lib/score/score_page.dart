import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/score/score_controller.dart';
import 'package:melodifestivalen_competition/styles/colors.dart';

class ScorePage extends ConsumerStatefulWidget {
  const ScorePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScorePageState();
}

class _ScorePageState extends ConsumerState<ScorePage> {
  ScoreController get controller => ref.read(ScoreController.provider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUserScores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ScoreController.provider);

    if (state.loading) {
      return const CircularProgressIndicator();
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: const [
              SizedBox(height: 32),
              Text(
                'Highscore',
                style: TextStyle(fontSize: 32, color: melloYellow),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: state.userScores.length,
            (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${index + 1}. ${state.userScores[index].username ?? ''}',
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  '${state.userScores[index].score}',
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
