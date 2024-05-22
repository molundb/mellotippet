import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/reusable_app_bar/reusable_app_bar.dart';
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
    controller.getUserScore();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(ScoreController.provider, (previous, next) {
    //   if (next.snackBarText != '') {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(next.snackBarText),
    //       ),
    //     );
    //     controller.clearSnackBarText();
    //   }
    // });

    final state = ref.watch(ScoreController.provider);

    return Stack(
      children: [
        Scaffold(
          appBar: const ReusableAppBar(title: 'Poäng'),
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
                        color: MellotippetColors.melloLightOrange,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        if (state.loading) ...[
          Container(
              color: MellotippetColors.loadingGrayOverlay,
              child: const Center(child: CircularProgressIndicator()))
        ],
      ],
    );
  }
}
