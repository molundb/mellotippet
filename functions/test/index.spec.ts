import { db } from "../src/config/firebase";
import { calculateTotalScores } from "../src/index";
import functions from "firebase-functions-test";
import { expect } from "chai";
import { User, userConverter } from "../src/models/user";
import HeatPrediction from "../src/models/heat-prediction";
import SemifinalPrediction from "../src/models/semifinal-prediction";
import FinalPredictionOrResult from "../src/models/final-prediction-or-result";
import HeatResult from "../src/models/heat-result";
import { Change } from "firebase-functions/v1";
import SemifinalResult from "../src/models/semifinal-result";

const test = functions(
  {
    projectId: "melodifestivalen-comp-test",
  },
  ".firebase/service-account-test.json"
);

describe("calculateTotalScores", function () {
  after(function () {
    // Do cleanup tasks.
    test.cleanup();
    // Reset the database.
    db.doc("users/user1").delete();
    db.doc("competitions/heat1/predictions/user1").delete();
    db.doc("competitions/heat1").delete();
  });

  // const tests = [
  //   {user: new User("user1", "testUser1", 0), competition: "heat1", prediction: new HeatPrediction({
  //     finalist1: 1,
  //     finalist2: 2,
  //     semifinalist1: 3,
  //     semifinalist2: 4,
  //     fifthPlace: 5,
  //   }), result: }
  // ]

  it("should calculate score correctly for heat", async function () {
    // Given
    const uid = "user1";
    const username = "testUser1";
    const totalScore = 0;

    const competition = "heat1";
    const competitionPath = `competitions/${competition}`;

    const prediction = new HeatPrediction({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
      fifthPlace: 5,
    });

    const result = new HeatResult({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
    }).toResult();

    await addUserToDatabase(new User(uid, username, totalScore));
    await addPredictionToDatabase(competitionPath, uid, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When: Trigger calculate total scores
    const wrappedCalculateTotalScores = test.wrap(calculateTotalScores);
    await wrappedCalculateTotalScores(event);

    // Then: Assert that scores are correct
    const user = await getUserFromDatabase(uid);
    expect(user?.totalScore).to.equal(14);
  });

  it("should calculate score correctly for semifinal", async function () {
    // Given
    const uid = "user1";
    const username = "testUser1";
    const totalScore = 0;

    const competition = "semifinal";
    const competitionPath = `competitions/${competition}`;

    const prediction = new SemifinalPrediction({
      finalist1: 1,
      finalist2: 2,
    });

    const result = new SemifinalResult({
      finalist1: 1,
      finalist2: 2,
    }).toResult();

    await addUserToDatabase(new User(uid, username, totalScore));
    await addPredictionToDatabase(competitionPath, uid, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When: Trigger calculate total scores
    const wrappedCalculateTotalScores = test.wrap(calculateTotalScores);
    await wrappedCalculateTotalScores(event);

    // Then: Assert that scores are correct
    const user = await getUserFromDatabase(uid);
    expect(user?.totalScore).to.equal(6);
  });

  it("should calculate score correctly for final", async function () {
    // Given
    const uid = "user1";
    const username = "testUser1";
    const totalScore = 0;

    const competition = "final";
    const competitionPath = `competitions/${competition}`;

    const prediction = new FinalPredictionOrResult({
      placement1: 1,
      placement2: 2,
      placement3: 3,
      placement4: 4,
      placement5: 5,
      placement6: 6,
      placement7: 7,
      placement8: 8,
      placement9: 9,
      placement10: 10,
      placement11: 11,
      placement12: 12,
    });

    const result = new FinalPredictionOrResult({
      placement1: 1,
      placement2: 2,
      placement3: 3,
      placement4: 4,
      placement5: 5,
      placement6: 6,
      placement7: 7,
      placement8: 8,
      placement9: 9,
      placement10: 10,
      placement11: 11,
      placement12: 12,
    }).toResult();

    await addUserToDatabase(new User(uid, username, totalScore));
    await addPredictionToDatabase(competitionPath, uid, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When: Trigger calculate total scores
    const wrappedCalculateTotalScores = test.wrap(calculateTotalScores);
    await wrappedCalculateTotalScores(event);

    // Then: Assert that scores are correct
    const user = await getUserFromDatabase(uid);
    expect(user?.totalScore).to.equal(40);
  });
});

async function addUserToDatabase(user: User) {
  return await db.doc(`users/${user.id}`).set(Object.assign({}, user));
}

async function addPredictionToDatabase(
  competitionPath: string,
  uid: string,
  prediction: any
) {
  return await db
    .doc(`${competitionPath}/predictions/${uid}`)
    .set(Object.assign({}, prediction));
}

async function addResultToDatabase(competitionPath: string, result: any) {
  return await db.doc(competitionPath).set(result);
}

async function getUserFromDatabase(uid: string) {
  return (
    await db.doc(`users/${uid}`).withConverter(userConverter).get()
  ).data();
}

function createChange(competitionPath: string, result: { result: any }) {
  const beforeSnap = test.firestore.makeDocumentSnapshot({}, competitionPath);
  const afterSnap = test.firestore.makeDocumentSnapshot(
    result,
    competitionPath
  );
  const change = test.makeChange(beforeSnap, afterSnap);
  return change;
}

// Have to create an object because of issues with firebase-functions-test & firebase-functions/v2/firestore, see:
// https://github.com/firebase/firebase-functions-test/issues/205
// https://github.com/firebase/firebase-functions-test/issues/10
function createEvent(change: Change<any>, competition: string) {
  return { data: change, params: { competition: competition } };
}
