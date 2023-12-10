import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/score/score_controller.dart';
import 'package:mellotippet/styles/colors.dart';

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
      controller.getUserScore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ScoreController.provider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        centerTitle: true,
        title: const Text(
          'Poäng',
          style: TextStyle(
            color: Colors.white,
            fontSize: 64,
            fontFamily: 'Lalezar',
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/score_page_background.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(),
          ),
          Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: 0.6,
                  child: Container(
                    width: 253,
                    decoration: const BoxDecoration(
                      color: MellotippetColors.melloBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Center(
                child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    width: 282,
                    decoration: const BoxDecoration(
                      color: MellotippetColors.scorePageBorder,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  state.loading ? '0 p' : '${state.userScore} p',
                  style: const TextStyle(
                      fontSize: 92,
                      fontFamily: 'Lalezar',
                      color: MellotippetColors.melloLightOrange),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
