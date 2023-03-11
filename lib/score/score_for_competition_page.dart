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
    List<int>? finalPredictions;
    final Map<int, String>? predictionMap;

    switch (competition.type) {
      case CompetitionType.theFinal:
        result = competition.result as FinalPredictionModel;
        prediction = widget.prediction as FinalPredictionModel?;
        predictionMap = (prediction as FinalPredictionModel?)?.toMap();
        finalPredictions = prediction?.toList();
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
                          children: competition.type == CompetitionType.theFinal ? const [
                            Text(''),
                            Text('        '),
                            Text('Result       Predix'),
                            Text('Points'),
                          ] : const [
                            Text('                    '),
                            Text('Result'),
                            Text('Predix'),
                            Text('Points'),
                          ],
                        ),
                        if (competition.type == CompetitionType.theFinal) ...[
                          _buildRow(
                            position: "1st",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position1!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              5,
                              1,
                              result.position1!,
                              prediction,
                            ),
                            result: result.position1,
                            maxScore: 5,
                          ),
                          _buildRow(
                            position: "2nd",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position2!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              5,
                              2,
                              result.position2!,
                              prediction,
                            ),
                            result: result.position2,
                            maxScore: 5,
                          ),
                          _buildRow(
                            position: "3rd",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position3!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              5,
                              3,
                              result.position3!,
                              prediction,
                            ),
                            result: result.position3,
                            maxScore: 5,
                          ),
                          _buildRow(
                            position: "4th",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position4!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              5,
                              4,
                              result.position4!,
                              prediction,
                            ),
                            result: result.position4,
                            maxScore: 5,
                          ),
                          _buildRow(
                            position: "5th",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position5!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              3,
                              5,
                              result.position5!,
                              prediction,
                            ),
                            result: result.position5,
                            maxScore: 3,
                          ),
                          _buildRow(
                            position: "6th",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position6!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              3,
                              6,
                              result.position6!,
                              prediction,
                            ),
                            result: result.position6,
                            maxScore: 3,
                          ),
                          _buildRow(
                            position: "7th",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position7!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              3,
                              7,
                              result.position7!,
                              prediction,
                            ),
                            result: result.position7,
                            maxScore: 3,
                          ),
                          _buildRow(
                            position: "8th",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position8!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              3,
                              8,
                              result.position8!,
                              prediction,
                            ),
                            result: result.position8,
                            maxScore: 3,
                          ),
                          _buildRow(
                            position: "9th",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position9!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              2,
                              9,
                              result.position9!,
                              prediction,
                            ),
                            result: result.position9,
                            maxScore: 2,
                          ),
                          _buildRow(
                            position: "10th",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position10!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              2,
                              10,
                              result.position10!,
                              prediction,
                            ),
                            result: result.position10,
                            maxScore: 2,
                          ),
                          _buildRow(
                            position: "11th",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position11!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              2,
                              11,
                              result.position11!,
                              prediction,
                            ),
                            result: result.position11,
                            maxScore: 2,
                          ),
                          _buildRow(
                            position: "12th",
                            prediction: finalPredictions != null
                                ? '${finalPredictions.indexOf(result.position12!) + 1}'
                                : null,
                            score: _getFinalistScore(
                              competition.lowestScore,
                              2,
                              12,
                              result.position12!,
                              prediction,
                            ),
                            result: result.position12,
                            maxScore: 2,
                          ),
                        ] else if (competition.type ==
                            CompetitionType.semifinal) ...[
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
                          _buildRow(
                            position: "Final       ",
                            prediction: predictionMap != null
                                ? predictionMap[result.finalist3]
                                : null,
                            score: _getSemifinalistFinalistScore(
                              competition.lowestScore,
                              result.finalist3!,
                              prediction,
                            ),
                            result: result.finalist3,
                          ),
                          _buildRow(
                            position: "Final       ",
                            prediction: predictionMap != null
                                ? predictionMap[result.finalist4]
                                : null,
                            score: _getSemifinalistFinalistScore(
                              competition.lowestScore,
                              result.finalist4!,
                              prediction,
                            ),
                            result: result.finalist4,
                          )
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
    int? maxScore,
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
        child: maxScore != null
            ? _buildFinalRow(
                position,
                result,
                prediction == null ? null : int.parse(prediction),
                score,
                maxScore,
              )
            : _buildNonFinalRow(
                position,
                result,
                prediction,
                score,
              ),
      ),
    );
  }

  Widget _buildNonFinalRow(
    String position,
    int? result,
    String? prediction,
    int score,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(position),
          Text(result.toString()),
          Text(prediction ?? '-'),
          Text('${score}p'),
        ],
      );

  Widget _buildFinalRow(
    String position,
    int? result,
    int? prediction,
    int score,
    int maxScore,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(position),
          Text('${maxScore}p'),
          const Text('- abs ('),
          Text(result.toString()),
          const Text('-'),
          Text(prediction == null ? '-' : '$prediction${toOrdinal(prediction)}'),
          const Text(')'),
          const Text('='),
          Text('${score}p'),
        ],
      );

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

  int _getFinalistScore(
    int lowestScore,
    int maxScore,
    int finalistPosition,
    int finalistStartingNumber,
    FinalPredictionModel? prediction,
  ) {
    if (prediction == null) {
      return lowestScore;
    }

    final predictions = prediction.toList();

    return calculateFinalistScore(
      maxScore,
      finalistPosition,
      finalistStartingNumber,
      predictions,
    );
  }

  String toOrdinal(int number) {
    if(!(number >= 1 && number <= 12)) {//here you change the range
      throw Exception('Invalid number');
    }

    if(number >= 11 && number <= 13) {
      return 'th';
    }

    switch(number % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }
}
