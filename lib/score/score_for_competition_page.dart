import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/config/config.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/score/score_calculator.dart';
import 'package:melodifestivalen_competition/score/score_controller.dart';
import 'package:melodifestivalen_competition/styles/colors.dart';

class ScoreForCompetitionPage extends ConsumerStatefulWidget {
  final PredictionModel result;
  final PredictionModel? prediction;

  // Result
  // User prediction
  // User Score?

  const ScoreForCompetitionPage({
    required this.result,
    required this.prediction,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreForCompetitionPageState();
}

class _ScoreForCompetitionPageState
    extends ConsumerState<ScoreForCompetitionPage> {
  ScoreController get controller => ref.read(ScoreController.provider.notifier);
  final config = getIt.get<Config>();

  @override
  Widget build(BuildContext context) {
    final predictionMap = widget.prediction!.toMap();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Score Detail',
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
            // SliverToBoxAdapter(
            //   child: Center(
            //     child: Padding(
            //       padding: const EdgeInsets.only(bottom: 16.0),
            //       child: Text(
            //         widget.userEntity.username ?? '',
            //         style: const TextStyle(
            //           fontSize: 32,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('                    '),
                      Text('Result'),
                      Text('Predix'),
                      Text('Points'),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: MelloPredixColors.melloOrange),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          5.0,
                        ), //
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Final       '),
                        Text(widget.result.finalist1.toString()),
                        Text(predictionMap[widget.result.finalist1] ?? '-'),
                        Text(
                            '${calculateFinalistScore(widget.result.finalist1, widget.prediction!)}p'),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: MelloPredixColors.melloOrange),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          5.0,
                        ), //
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Final       '),
                        Text(widget.result.finalist2.toString()),
                        Text(predictionMap[widget.result.finalist2] ?? '-'),
                        Text(
                            '${calculateFinalistScore(widget.result.finalist2, widget.prediction!)}p'),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: MelloPredixColors.melloOrange),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          5.0,
                        ), //
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Semifinal'),
                        Text(widget.result.semifinalist1.toString()),
                        Text(predictionMap[widget.result.semifinalist1] ?? '-'),
                        Text(
                            '${calculateSemifinalistScore(widget.result.semifinalist1, widget.prediction!)}p'),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: MelloPredixColors.melloOrange),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          5.0,
                        ), //
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Semifinal'),
                        Text(widget.result.semifinalist2.toString()),
                        Text(predictionMap[widget.result.semifinalist2] ?? '-'),
                        Text(
                            '${calculateSemifinalistScore(widget.result.semifinalist2, widget.prediction!)}p'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
