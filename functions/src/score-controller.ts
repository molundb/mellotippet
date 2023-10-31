import { db } from "./config/firebase";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

import { User, userConverter } from "./models/user";
import HeatResult from "./models/heat-result";
import SemifinalResult from "./models/semifinal-result";
import FinalResult from "./models/final-result";
import { heatPredictionAndScoreConverter } from "./models/heat-prediction-and-score";
import { semifinalPredictionAndScoreConverter } from "./models/semifinal-prediction-and-score";
import { finalPredictionAndScoreConverter } from "./models/final-prediction-and-score";

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
              FinalResult.fromJson(result)
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
    .withConverter(heatPredictionAndScoreConverter)
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
        .withConverter(heatPredictionAndScoreConverter)
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
  const predictionAndScoresSnapshot = await db
    .collection(`competitions/${competition}/predictionsAndScores`)
    .doc(userSnapshot.id)
    .withConverter(semifinalPredictionAndScoreConverter)
    .get();

  const prediction = predictionAndScoresSnapshot.data();
  if (prediction !== undefined) {
    let semifinalPredictionAndscore = scoreCalculator.calculateSemifinalScore(
      result,
      prediction
    );

    await db
        .collection(`competitions/${competition}/predictionsAndScores`)
        .doc(userSnapshot.id)
        .withConverter(semifinalPredictionAndScoreConverter)
        .set(semifinalPredictionAndscore);

    let user = userSnapshot.data();
    user.totalScore += semifinalPredictionAndscore.totalScore();
    return userSnapshot.ref.set(user);
  }

  return Promise.resolve();
}

async function calculateScoreForFinalAndUpdateTotalScore(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator,
  result: FinalResult
) {
  const snapshot = await db
    .collection(`competitions/${competition}/predictionsAndScores`)
    .doc(userSnapshot.id)
    .withConverter(finalPredictionAndScoreConverter)
    .get();

  const prediction = snapshot.data();
  if (prediction !== undefined && prediction.placement1 !== undefined) {
    let finalPredictionAndScore = scoreCalculator.calculateFinalScore(result, prediction);

    await db
        .collection(`competitions/${competition}/predictionsAndScores`)
        .doc(userSnapshot.id)
        .withConverter(finalPredictionAndScoreConverter)
        .set(finalPredictionAndScore);

    let user = userSnapshot.data();
    user.totalScore += finalPredictionAndScore.totalScore();
    return userSnapshot.ref.set(user);
  }

  return Promise.resolve();
}

export { calculateTotalScores };
