import { db } from "./config/firebase";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

import { User, userConverter } from "./models/user";
import HeatResult from "./models/heat-result";
import SemifinalResult from "./models/semifinal-result";
import { heatPredictionConverter } from "./models/heat-prediction";
import { semifinalPredictionConverter } from "./models/semifinal-prediction";
import FinalPredictionOrResult, {
  finalPredictionOrResultConverter,
} from "./models/final-prediction-or-result";

import { ScoreCalculator } from "./util/score-calculator";

const calculateTotalScores = onDocumentWritten(
  "competitions/{competition}",
  async (event) => {
    const result = event.data?.after.data()?.result;
    if (result !== undefined) {
      const userSnapshots = await db
        .collection("users")
        .withConverter(userConverter)
        .get();

      const scoreCalculator = new ScoreCalculator();
      const competition = event.params.competition;

      return Promise.all(
        userSnapshots.docs.map(async (userSnapshot) => {
          if (competition === "final") {
            await calculateScoreForFinalAndUpdateTotalScore(
              competition,
              userSnapshot,
              scoreCalculator,
              FinalPredictionOrResult.fromJson(result)
            );
          } else if (competition === "semifinal") {
            await calculateScoreForSemifinalAndUpdateTotalScore(
              competition,
              userSnapshot,
              scoreCalculator,
              SemifinalResult.fromJson(result)
            );
          } else {
            await calculateScoreForHeatAndUpdateTotalScore(
              competition,
              userSnapshot,
              scoreCalculator,
              HeatResult.fromJson(result)
            );
          }
        })
      );
    } else {
      return Promise.reject();
    }
  }
);

async function calculateScoreForHeatAndUpdateTotalScore(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator,
  result: HeatResult
) {
  const predictionAndScoresSnapshot = await db
    .collection(`competitions/${competition}/predictionsAndScores`)
    .doc(userSnapshot.id)
    .withConverter(heatPredictionConverter)
    .get();

  const prediction = predictionAndScoresSnapshot.data();
  if (prediction !== undefined) {
    let heatPredictionAndscore = scoreCalculator.calculateHeatScore(
      result,
      prediction
    );

    await db
        .collection(`competitions/${competition}/predictionsAndScores`)
        .doc(userSnapshot.id)
        .withConverter(heatPredictionConverter)
        .set(heatPredictionAndscore);

    let user = userSnapshot.data();
    user.totalScore += heatPredictionAndscore.totalScore();
    return await userSnapshot.ref.set(user);
  }

  return Promise.resolve();
}

async function calculateScoreForSemifinalAndUpdateTotalScore(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator,
  result: SemifinalResult
) {
  const snapshot = await db
    .collection(`competitions/${competition}/predictionsAndScores`)
    .doc(userSnapshot.id)
    .withConverter(semifinalPredictionConverter)
    .get();

  const prediction = snapshot.data();
  if (prediction !== undefined) {
    let scoreForSemifinal = scoreCalculator.calculateSemifinalScore(
      result,
      prediction
    );

    let user = userSnapshot.data();
    user.totalScore += scoreForSemifinal;
    return userSnapshot.ref.set(user);
  }

  return Promise.resolve();
}

async function calculateScoreForFinalAndUpdateTotalScore(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator,
  result: FinalPredictionOrResult
) {
  const snapshot = await db
    .collection(`competitions/${competition}/predictionsAndScores`)
    .doc(userSnapshot.id)
    .withConverter(finalPredictionOrResultConverter)
    .get();

  const prediction = snapshot.data();
  if (prediction !== undefined && prediction.placement1 !== undefined) {
    let scoreForFinal = scoreCalculator.calculateFinalScore(result, prediction);

    let user = userSnapshot.data();
    user.totalScore += scoreForFinal;
    return userSnapshot.ref.set(user);
  }

  return Promise.resolve();
}

export { calculateTotalScores };
