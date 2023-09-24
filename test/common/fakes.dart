import 'package:melodifestivalen_competition/common/models/all_models.dart';

final fakeHeatPrediction = HeatPredictionModel(
  finalist1: 1,
  finalist2: 2,
  semifinalist1: 3,
  semifinalist2: 4,
  fifthPlace: 5,
);

final fakeSemifinalPrediction = SemifinalPredictionModel(
  finalist1: 1,
  finalist2: 2,
  finalist3: 3,
  finalist4: 4,
);

final fakeFinalPrediction = FinalPredictionModel(
  position1: 1,
  position2: 2,
  position3: 3,
  position4: 4,
  position5: 5,
  position6: 6,
  position7: 7,
  position8: 8,
  position9: 9,
  position10: 10,
  position11: 11,
  position12: 12,
);

final fakeUsers = [
  const User(id: "id1", username: "username1"),
  const User(id: "id2", username: "username2"),
];

final fakeCompetitions = [
  CompetitionModel(id: "heat1",
    type: CompetitionType.heat,
    lowestScore: 4,
    result: fakeHeatPrediction,
  ),
  CompetitionModel(id: "heat2",
    type: CompetitionType.heat,
    lowestScore: 2,
    result: fakeHeatPrediction,
  ),
  CompetitionModel(id: "heat3",
    type: CompetitionType.heat,
    lowestScore: 14,
    result: fakeHeatPrediction,
  ),CompetitionModel(id: "heat4",
    type: CompetitionType.heat,
    lowestScore: 7,
    result: fakeHeatPrediction,
  ),

  CompetitionModel(id: "semifinal",
    type: CompetitionType.semifinal,
    lowestScore: 5,
    result: fakeSemifinalPrediction,
  ),
  CompetitionModel(id: "theFinal",
    type: CompetitionType.theFinal,
    lowestScore: 3,
    result: fakeFinalPrediction,
  ),
];
