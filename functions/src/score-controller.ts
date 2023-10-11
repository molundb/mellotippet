import { db } from "./config/firebase";
import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { heatPredictionConverter } from "./models/heat-prediction";
import {
  calculateHeatFinalistScore,
  calculateHeatSemifinalistScore,
} from "./util/score-calculation";

const calculateTotalScores = onDocumentWritten(
  "competitions/heat4",
  (event) => {
    const result = event.data?.after.data()?.result;
    if (result !== undefined) {
      db.collection("users")
        .get()
        .then((usersSnapshot) => {
          usersSnapshot.forEach((user) => {
            db.collection("competitions/heat4/predictions")
              .doc(user.id)
              .withConverter(heatPredictionConverter)
              .get()
              .then((snapshot) => {
                const prediction = snapshot.data();

                if (prediction !== undefined) {
                  var score = 0;

                  score += calculateHeatFinalistScore(
                    result.finalist1,
                    prediction
                  );
                  score += calculateHeatFinalistScore(
                    result.finalist2,
                    prediction
                  );
                  score += calculateHeatSemifinalistScore(
                    result.semifinalist1,
                    prediction
                  );
                  score += calculateHeatSemifinalistScore(
                    result.semifinalist2,
                    prediction
                  );

                  const newScore = user.data().totalScore + score;
                  const userObject = {
                    username: user.data().username,
                    totalScore: newScore,
                  };

                  user.ref.set(userObject);
                }
              });
          });
        });
    }
  }
);

export { calculateTotalScores };
