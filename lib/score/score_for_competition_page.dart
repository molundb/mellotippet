import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/config/config.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/score/score_calculator.dart';
import 'package:melodifestivalen_competition/score/score_controller.dart';
import 'package:melodifestivalen_competition/styles/colors.dart';

class ScoreForCompetitionPage extends ConsumerStatefulWidget {
  final CompetitionModel competition;
  final PredictionModel? prediction;

  // Result
  // User prediction
  // User Score?

  const ScoreForCompetitionPage({
    required this.competition,
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
    final competition = widget.competition;
    final prediction = widget.prediction;
    final predictionMap = prediction?.toMap();

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
        child: prediction == null
            ? Column(
                children: [
                  Text('Your score is ${competition.lowestScore - 1}p',
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 16),
                  const Text(
                      'You did not make a prediction on time! Therefore, your score is 1 point less than the person who scored the lowest.'),
                ],
              )
            : CustomScrollView(
                slivers: [
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
                        _buildRow(
                          position: "Final       ",
                          prediction: predictionMap != null
                              ? predictionMap[competition.result.finalist1]
                              : null,
                          score: _getFinalistScore(
                            competition.lowestScore,
                            competition.result.finalist1!,
                            prediction,
                          ),
                          result: competition.result.finalist1,
                        ),
                        _buildRow(
                          position: "Final       ",
                          prediction: predictionMap != null
                              ? predictionMap[competition.result.finalist1]
                              : null,
                          score: _getFinalistScore(
                            competition.lowestScore,
                            competition.result.finalist2!,
                            prediction,
                          ),
                          result: competition.result.finalist2,
                        ),
                        _buildRow(
                          position: "Semifinal",
                          prediction: predictionMap != null
                              ? predictionMap[competition.result.semifinalist1]
                              : null,
                          score: _getSemifinalistScore(
                            competition.lowestScore,
                            competition.result.semifinalist1!,
                            prediction,
                          ),
                          result: competition.result.semifinalist1,
                        ),
                        _buildRow(
                          position: "Semifinal",
                          prediction: predictionMap != null
                              ? predictionMap[competition.result.semifinalist2]
                              : null,
                          score: _getSemifinalistScore(
                            competition.lowestScore,
                            competition.result.semifinalist2!,
                            prediction,
                          ),
                          result: competition.result.semifinalist2,
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

  Container _buildRow({
    required String position,
    required String? prediction,
    required int score,
    required int? result,
  }) {
    return Container(
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
          Text(position),
          Text(result.toString()),
          Text(prediction ?? '-'),
          Text('${score}p'),
        ],
      ),
    );
  }

  int _getSemifinalistScore(
    int lowestScore,
    int semifinalist,
    PredictionModel? prediction,
  ) {
    if (prediction == null) {
      return lowestScore - 1;
    }

    return calculateSemifinalistScore(semifinalist, prediction);
  }

  int _getFinalistScore(
    int lowestScore,
    int finalist,
    PredictionModel? prediction,
  ) {
    if (prediction == null) {
      return lowestScore - 1;
    }

    return calculateFinalistScore(finalist, prediction);
  }
}
