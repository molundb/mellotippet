import { db } from "./config/firebase";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

import { User, userConverter } from "./models/user";
import { heatResultConverter } from "./models/heat-result";
import { finalkvalResultConverter } from "./models/finalkval-result";
import { finalResultConverter } from "./models/final-result";
import { heatPredictionAndScoreConverter } from "./models/heat-prediction-and-score";
import { finalkvalPredictionAndScoreConverter } from "./models/finalkval-prediction-and-score";
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
            if (competition.id === "theFinal") {
              userScore += await calculateScoreForFinal(
                competition.id,
                userSnapshot,
                scoreCalculator
              );
            } else if (competition.id === "finalkval") {
              userScore += await calculateScoreForFinalkval(
                competition.id,
                userSnapshot,
                scoreCalculator
              );
            } else {
              userScore += await calculateScoreForHeat(
                competition.id,
                userSnapshot,
                scoreCalculator
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
  scoreCalculator: ScoreCalculator
): Promise<number> {
  const resultSnapshot = await db
    .collection("competitions")
    .doc(competition)
    .withConverter(heatResultConverter)
    .get();

  const predictionAndScoresSnapshot = await db
    .collection(`competitions/${competition}/predictionsAndScores`)
    .doc(userSnapshot.id)
    .withConverter(heatPredictionAndScoreConverter)
    .get();

  const prediction = predictionAndScoresSnapshot.data();
  const result = resultSnapshot.data();
  if (prediction !== undefined && result !== undefined) {
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

async function calculateScoreForFinalkval(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator
): Promise<number> {
  const resultSnapshot = await db
    .collection("competitions")
    .doc(competition)
    .withConverter(finalkvalResultConverter)
    .get();

  const predictionAndScoresSnapshot = await db
    .collection(`competitions/${competition}/predictionsAndScores`)
    .doc(userSnapshot.id)
    .withConverter(finalkvalPredictionAndScoreConverter)
    .get();

  const prediction = predictionAndScoresSnapshot.data();
  const result = resultSnapshot.data();
  if (prediction !== undefined && result !== undefined) {
    const finalkvalPredictionAndscore = scoreCalculator.calculateFinalkvalScore(
      result,
      prediction
    );

    await db
      .collection(`competitions/${competition}/predictionsAndScores`)
      .doc(userSnapshot.id)
      .withConverter(finalkvalPredictionAndScoreConverter)
      .set(finalkvalPredictionAndscore);

    return finalkvalPredictionAndscore.totalScore();
  }

  return Promise.resolve(0);
}

async function calculateScoreForFinal(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator
): Promise<number> {
  const resultSnapshot = await db
    .collection("competitions")
    .doc(competition)
    .withConverter(finalResultConverter)
    .get();

  const snapshot = await db
    .collection(`competitions/${competition}/predictionsAndScores`)
    .doc(userSnapshot.id)
    .withConverter(finalPredictionAndScoreConverter)
    .get();

  const prediction = snapshot.data();
  const result = resultSnapshot.data();
  if (prediction !== undefined && result !== undefined) {
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
