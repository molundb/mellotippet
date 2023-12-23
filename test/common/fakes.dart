import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/common/models/prediction/prediction_and_score.dart';

final fakeHeatPrediction = HeatPredictionModel(
  finalist1: PredictionAndScore(prediction: 1, score: 0),
  finalist2: PredictionAndScore(prediction: 2, score: 0),
  semifinalist1: PredictionAndScore(prediction: 3, score: 0),
  semifinalist2: PredictionAndScore(prediction: 4, score: 0),
  fifthPlace: PredictionAndScore(prediction: 5, score: 0),
);

final fakeSemifinalPrediction = SemifinalPredictionModel(
  finalist1: PredictionAndScore(prediction: 1),
  finalist2: PredictionAndScore(prediction: 2),
);

final fakeFinalPrediction = FinalPredictionModel(
  placement1: PredictionAndScore(prediction: 1),
  placement2: PredictionAndScore(prediction: 2),
  placement3: PredictionAndScore(prediction: 3),
  placement4: PredictionAndScore(prediction: 4),
  placement5: PredictionAndScore(prediction: 5),
  placement6: PredictionAndScore(prediction: 6),
  placement7: PredictionAndScore(prediction: 7),
  placement8: PredictionAndScore(prediction: 8),
  placement9: PredictionAndScore(prediction: 9),
  placement10: PredictionAndScore(prediction: 10),
  placement11: PredictionAndScore(prediction: 11),
  placement12: PredictionAndScore(prediction: 12),
);

final fakeUsers = [
  const User(id: "id1", username: "username1", totalScore: 0),
  const User(id: "id2", username: "username2", totalScore: 0),
];

final fakeCompetitions = [
  CompetitionModel(
    id: "heat1",
    type: CompetitionType.heat,
    lowestScore: 4,
    result: fakeHeatPrediction,
  ),
  CompetitionModel(
    id: "heat2",
    type: CompetitionType.heat,
    lowestScore: 2,
    result: fakeHeatPrediction,
  ),
  CompetitionModel(
    id: "heat3",
    type: CompetitionType.heat,
    lowestScore: 14,
    result: fakeHeatPrediction,
  ),
  CompetitionModel(
    id: "heat4",
    type: CompetitionType.heat,
    lowestScore: 7,
    result: fakeHeatPrediction,
  ),
  CompetitionModel(
    id: "semifinal",
    type: CompetitionType.semifinal,
    lowestScore: 5,
    result: fakeSemifinalPrediction,
  ),
  CompetitionModel(
    id: "theFinal",
    type: CompetitionType.theFinal,
    lowestScore: 3,
    result: fakeFinalPrediction,
  ),
];
