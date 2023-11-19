import { db } from "./config/firebase";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

import { User, userConverter } from "./models/user";
import { HeatResult } from "./models/heat-result";
import { SemifinalResult } from "./models/semifinal-result";
import { FinalResult } from "./models/final-result";
import { heatPredictionAndScoreConverter } from "./models/heat-prediction-and-score";
import { semifinalPredictionAndScoreConverter } from "./models/semifinal-prediction-and-score";
import { finalPredictionAndScoreConverter } from "./models/final-prediction-and-score";

import { ScoreCalculator } from "./util/score-calculator";

const calculateScores = onDocumentWritten(
  {
    document: "competitions/{competition}",
    region: "europe-west1",
  },
  async (event) => {
    const result = event.data?.after.data()?.result;
    if (result !== undefined) {
      const userSnapshots = await db
        .collection("users")
        .withConverter(userConverter)
        .get();

      const competitionSnapshots = await db
        .collection("competitions")
        .listDocuments();

      const scoreCalculator = new ScoreCalculator();

      return Promise.all(
        userSnapshots.docs.map(async (userSnapshot) => {
          let userScore = 0;
          for (const competition of competitionSnapshots) {
            if (competition.id === "final") {
              userScore += await calculateScoreForFinal(
                competition.id,
                userSnapshot,
                scoreCalculator,
                FinalResult.fromJson(result)
              );
            } else if (competition.id === "semifinal") {
              userScore += await calculateScoreForSemifinal(
                competition.id,
                userSnapshot,
                scoreCalculator,
                SemifinalResult.fromJson(result)
              );
            } else {
              userScore += await calculateScoreForHeat(
                competition.id,
                userSnapshot,
                scoreCalculator,
                HeatResult.fromJson(result)
              );
            }
          }
          const user = userSnapshot.data();
          user.totalScore = userScore;
          return userSnapshot.ref.set(user);
        })
      );
    } else {
      return Promise.reject(new Error("result was undefined"));
    }
  }
);

async function calculateScoreForHeat(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator,
  result: HeatResult
): Promise<number> {
  const predictionAndScoresSnapshot = await db
    .collection(`competitions/${competition}/predictionsAndScores`)
    .doc(userSnapshot.id)
    .withConverter(heatPredictionAndScoreConverter)
    .get();

  const prediction = predictionAndScoresSnapshot.data();
  if (prediction !== undefined) {
    const heatPredictionAndscore = scoreCalculator.calculateHeatScore(
      result,
      prediction
    );

    await db
      .collection(`competitions/${competition}/predictionsAndScores`)
      .doc(userSnapshot.id)
      .withConverter(heatPredictionAndScoreConverter)
      .set(heatPredictionAndscore);

    return heatPredictionAndscore.totalScore();
  }

  return Promise.resolve(0);
}

async function calculateScoreForSemifinal(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator,
  result: SemifinalResult
): Promise<number> {
  const predictionAndScoresSnapshot = await db
    .collection(`competitions/${competition}/predictionsAndScores`)
    .doc(userSnapshot.id)
    .withConverter(semifinalPredictionAndScoreConverter)
    .get();

  const prediction = predictionAndScoresSnapshot.data();
  if (prediction !== undefined) {
    const semifinalPredictionAndscore = scoreCalculator.calculateSemifinalScore(
      result,
      prediction
    );

    await db
      .collection(`competitions/${competition}/predictionsAndScores`)
      .doc(userSnapshot.id)
      .withConverter(semifinalPredictionAndScoreConverter)
      .set(semifinalPredictionAndscore);

    return semifinalPredictionAndscore.totalScore();
  }

  return Promise.resolve(0);
}

async function calculateScoreForFinal(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator,
  result: FinalResult
): Promise<number> {
  const snapshot = await db
    .collection(`competitions/${competition}/predictionsAndScores`)
    .doc(userSnapshot.id)
    .withConverter(finalPredictionAndScoreConverter)
    .get();

  const prediction = snapshot.data();
  if (prediction !== undefined && prediction.placement1 !== undefined) {
    const finalPredictionAndScore = scoreCalculator.calculateFinalScore(
      result,
      prediction
    );

    await db
      .collection(`competitions/${competition}/predictionsAndScores`)
      .doc(userSnapshot.id)
      .withConverter(finalPredictionAndScoreConverter)
      .set(finalPredictionAndScore);

    return finalPredictionAndScore.totalScore();
  }

  return Promise.resolve(0);
}

export { calculateScores };
