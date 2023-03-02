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
    var prediction;
    var result;
    final Map<int, String>? predictionMap;

    switch (competition.type) {
      case CompetitionType.theFinal:
        result = competition.result as HeatPredictionModel;
        prediction = widget.prediction as HeatPredictionModel?;
        predictionMap = (prediction as HeatPredictionModel?)?.toMap();
        break;
      case CompetitionType.semifinal:
        result = competition.result as SemifinalPredictionModel;
        prediction = widget.prediction as SemifinalPredictionModel?;
        predictionMap = (prediction as SemifinalPredictionModel?)?.toMap();
        break;
      case CompetitionType.heat:
        result = competition.result as HeatPredictionModel;
        prediction = widget.prediction as HeatPredictionModel?;
        predictionMap = (prediction as HeatPredictionModel?)?.toMap();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          competition.id,
          style: const TextStyle(
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
                  Text('${competition.lowestScore - 1}p',
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 16),
                  Text(
                      'No prediction was made! Therefore, the score is 1 point less than for the person who scored the lowest in this competition, which was ${competition.lowestScore}p.'),
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
                        if (competition.type == CompetitionType.semifinal) ...[
                          _buildRow(
                            position: "Final       ",
                            prediction: predictionMap != null
                                ? predictionMap[result.finalist1]
                                : null,
                            score: _getSemifinalistFinalistScore(
                              competition.lowestScore,
                              result.finalist1!,
                              prediction,
                            ),
                            result: result.finalist1,
                          ),
                          _buildRow(
                            position: "Final       ",
                            prediction: predictionMap != null
                                ? predictionMap[result.finalist2]
                                : null,
                            score: _getSemifinalistFinalistScore(
                              competition.lowestScore,
                              result.finalist2!,
                              prediction,
                            ),
                            result: result.finalist2,
                          ),
                        ] else if (competition.type ==
                            CompetitionType.heat) ...[
                          _buildRow(
                            position: "Final       ",
                            prediction: predictionMap != null
                                ? predictionMap[result.finalist1]
                                : null,
                            score: _getHeatFinalistScore(
                              competition.lowestScore,
                              result.finalist1!,
                              prediction,
                            ),
                            result: result.finalist1,
                          ),
                          _buildRow(
                            position: "Final       ",
                            prediction: predictionMap != null
                                ? predictionMap[result.finalist2]
                                : null,
                            score: _getHeatFinalistScore(
                              competition.lowestScore,
                              result.finalist2!,
                              prediction,
                            ),
                            result: result.finalist2,
                          ),
                          _buildRow(
                            position: "Semifinal",
                            prediction: predictionMap != null
                                ? predictionMap[result.semifinalist1]
                                : null,
                            score: _getHeatSemifinalistScore(
                              competition.lowestScore,
                              result.semifinalist1!,
                              prediction,
                            ),
                            result: result.semifinalist1,
                          ),
                          _buildRow(
                            position: "Semifinal",
                            prediction: predictionMap != null
                                ? predictionMap[result.semifinalist2]
                                : null,
                            score: _getHeatSemifinalistScore(
                              competition.lowestScore,
                              result.semifinalist2!,
                              prediction,
                            ),
                            result: result.semifinalist2,
                          )
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildRow({
    required String position,
    required String? prediction,
    required int score,
    required int? result,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
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
      ),
    );
  }

  int _getHeatSemifinalistScore(
    int lowestScore,
    int semifinalist,
    HeatPredictionModel? prediction,
  ) {
    if (prediction == null) {
      return lowestScore - 1;
    }

    return calculateHeatSemifinalistScore(semifinalist, prediction);
  }

  int _getHeatFinalistScore(
    int lowestScore,
    int finalist,
    HeatPredictionModel? prediction,
  ) {
    if (prediction == null) {
      return lowestScore - 1;
    }

    return calculateHeatFinalistScore(finalist, prediction);
  }

  int _getSemifinalistFinalistScore(
    int lowestScore,
    int finalist,
    SemifinalPredictionModel? prediction,
  ) {
    if (prediction == null) {
      return lowestScore;
    }

    final predictions = [
      prediction.finalist1,
      prediction.finalist2,
      prediction.finalist3,
      prediction.finalist4,
    ];

    return calculateSemifinalFinalistScore(finalist, predictions);
  }
}
