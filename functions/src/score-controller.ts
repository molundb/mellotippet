import { db } from "./config/firebase";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

import { User, userConverter } from "./models/user";
import HeatResult from "./models/heat-result";
import SemifinalResult from "./models/semifinal-result";
import { heatPredictionConverter } from "./models/heat-prediction";
import { semifinalPredictionConverter } from "./models/semifinal-prediction";
import FinalPredictionOrResult, {
  finalPredictionConverter,
} from "./models/final-prediction";

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
      new HeatResult(
        result.finalist1,
        result.finalist2,
        result.semifinalist1,
        result.semifinalist2
      ),
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
      new SemifinalResult(result.finalist1, result.finalist2),
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
      new FinalPredictionOrResult(
        result.placement1,
        result.placement2,
        result.placement3,
        result.placement4,
        result.placement5,
        result.placement6,
        result.placement7,
        result.placement8,
        result.placement9,
        result.placement10,
        result.placement11,
        result.placement12
      ),
      prediction
    );

    let user = userSnapshot.data();
    user.totalScore += scoreForFinal;
    return userSnapshot.ref.set(user);
  }

  return Promise.reject();
}

export { calculateTotalScores };
