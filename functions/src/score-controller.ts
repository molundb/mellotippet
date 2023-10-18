import { db } from "./config/firebase";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

import { User, userConverter } from "./models/user";
import HeatResult from "./models/heat-result";
import SemifinalResult from "./models/semifinal-result";
import { heatPredictionConverter } from "./models/heat-prediction";
import { semifinalPredictionConverter } from "./models/semifinal-prediction";
import FinalPredictionOrResult, {
  finalPredictionConverter,
} from "./models/final-prediction-or-result";

import { ScoreCalculator } from "./util/score-calculation";

const calculateTotalScores = onDocumentWritten(
  "competitions/{competition}",
  async (event) => {
    const result = event.data?.after.data()?.result;
    if (result !== undefined) {
      const usersSnapshot = await db
        .collection("users")
        .withConverter(userConverter)
        .get();

      return new Promise((resolve, _) => {
        usersSnapshot.forEach(async (userSnapshot) => {
          let scoreCalculator = new ScoreCalculator();
          const competition = event.params.competition;

          if (competition === "final") {
            await calculateScoreForFinalAndUpdateTotalScore(
              competition,
              userSnapshot,
              scoreCalculator,
              result
            );
          } else if (competition === "semifinal") {
            await calculateScoreForSemifinalAndUpdateTotalScore(
              competition,
              userSnapshot,
              scoreCalculator,
              result
            );
          } else {
            await calculateScoreForHeatAndUpdateTotalScore(
              competition,
              userSnapshot,
              scoreCalculator,
              result
            );
          }
          resolve(true);
        });
      });
    } else {
      return Promise.reject();
    }
  }
);

async function calculateScoreForHeatAndUpdateTotalScore(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator,
  result: any
) {
  const snapshot = await db
    .collection(`competitions/${competition}/predictions`)
    .doc(userSnapshot.id)
    .withConverter(heatPredictionConverter)
    .get();

  const prediction = snapshot.data();
  if (prediction !== undefined) {
    let scoreForHeat = scoreCalculator.calculateHeatScore(
      new HeatResult({
        finalist1: result.finalist1,
        finalist2: result.finalist2,
        semifinalist1: result.semifinalist1,
        semifinalist2: result.semifinalist2,
      }),
      prediction
    );

    let user = userSnapshot.data();
    user.totalScore += scoreForHeat;
    return await userSnapshot.ref.set(user);
  }

  return Promise.reject();
}

async function calculateScoreForSemifinalAndUpdateTotalScore(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator,
  result: any
) {
  const snapshot = await db
    .collection(`competitions/${competition}/predictions`)
    .doc(userSnapshot.id)
    .withConverter(semifinalPredictionConverter)
    .get();

  const prediction = snapshot.data();
  if (prediction !== undefined) {
    let scoreForSemifinal = scoreCalculator.calculateSemifinalScore(
      new SemifinalResult({
        finalist1: result.finalist1,
        finalist2: result.finalist2,
      }),
      prediction
    );

    let user = userSnapshot.data();
    user.totalScore += scoreForSemifinal;
    return userSnapshot.ref.set(user);
  }

  return Promise.reject();
}

async function calculateScoreForFinalAndUpdateTotalScore(
  competition: string,
  userSnapshot: FirebaseFirestore.QueryDocumentSnapshot<User>,
  scoreCalculator: ScoreCalculator,
  result: any
) {
  const snapshot = await db
    .collection(`competitions/${competition}/predictions`)
    .doc(userSnapshot.id)
    .withConverter(finalPredictionConverter)
    .get();

  const prediction = snapshot.data();
  if (prediction !== undefined) {
    let scoreForFinal = scoreCalculator.calculateFinalScore(
      new FinalPredictionOrResult({
        placement1: prediction.placement1,
        placement2: prediction.placement2,
        placement3: prediction.placement3,
        placement4: prediction.placement4,
        placement5: prediction.placement5,
        placement6: prediction.placement6,
        placement7: prediction.placement7,
        placement8: prediction.placement8,
        placement9: prediction.placement9,
        placement10: prediction.placement10,
        placement11: prediction.placement11,
        placement12: prediction.placement12,
      }),
      prediction
    );

    let user = userSnapshot.data();
    user.totalScore += scoreForFinal;
    return userSnapshot.ref.set(user);
  }

  return Promise.reject();
}

export { calculateTotalScores };
