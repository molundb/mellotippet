import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/score/score_controller.dart';

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
              Text('Highscore'),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: state.userScores.length,
            (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(state.userScores[index].username ?? ''),
                Text('${state.userScores[index].score}'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
