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
    for (var userId of ["user1", "user2", "user3"]) {
      db.doc(`users/${userId}`).delete();

      for (var competition of [
        "heat1",
        "heat2",
        "heat3",
        "heat4",
        "heat5",
        "semifinal",
      ]) {
        db.doc(`competitions/${competition}/predictions/${userId}`).delete();
        db.doc(`competitions/${competition}`).delete();
      }
    }
  });

  const heatTests = [
    {
      testName: "should calculate score correctly for perfect prediction",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 0),
          prediction: new HeatPrediction({
            finalist1: 1,
            finalist2: 2,
            semifinalist1: 3,
            semifinalist2: 4,
            fifthPlace: 5,
          }),
          expectedScore: 14,
        },
      ],
      competition: "heat1",
      result: new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult(),
    },
    {
      testName: "should calculate score correctly when user has totalScore > 0",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 5),
          prediction: new HeatPrediction({
            finalist1: 1,
            finalist2: 2,
            semifinalist1: 3,
            semifinalist2: 4,
            fifthPlace: 5,
          }),
          expectedScore: 19,
        },
      ],
      competition: "heat1",
      result: new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult(),
    },
    {
      testName:
        "should calculate score correctly when one finalist on semifinal",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 7),
          prediction: new HeatPrediction({
            finalist1: 1,
            finalist2: 3,
            semifinalist1: 2,
            semifinalist2: 4,
            fifthPlace: 5,
          }),
          expectedScore: 18,
        },
      ],
      competition: "heat1",
      result: new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult(),
    },
    {
      testName:
        "should calculate score correctly when two finalists on semifinal",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 2),
          prediction: new HeatPrediction({
            finalist1: 3,
            finalist2: 4,
            semifinalist1: 1,
            semifinalist2: 2,
            fifthPlace: 5,
          }),
          expectedScore: 10,
        },
      ],
      competition: "heat1",
      result: new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult(),
    },
    {
      testName: "should calculate score correctly when finalist on fifth place",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 3),
          prediction: new HeatPrediction({
            finalist1: 3,
            finalist2: 4,
            semifinalist1: 6,
            semifinalist2: 5,
            fifthPlace: 1,
          }),
          expectedScore: 6,
        },
      ],
      competition: "heat1",
      result: new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult(),
    },
    {
      testName:
        "should calculate score correctly when semifinalist on fifth place",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 4),
          prediction: new HeatPrediction({
            finalist1: 3,
            finalist2: 4,
            semifinalist1: 6,
            semifinalist2: 5,
            fifthPlace: 1,
          }),
          expectedScore: 15,
        },
      ],
      competition: "heat1",
      result: new HeatResult({
        finalist1: 3,
        finalist2: 4,
        semifinalist1: 2,
        semifinalist2: 1,
      }).toResult(),
    },
    {
      testName: "should not change score when no prediction",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 6),
          prediction: undefined,
          expectedScore: 6,
        },
      ],
      competition: "heat1",
      result: new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult(),
    },
    {
      testName: "should calculate score correctly for multiple users",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 4),
          prediction: new HeatPrediction({
            finalist1: 3,
            finalist2: 4,
            semifinalist1: 6,
            semifinalist2: 5,
            fifthPlace: 1,
          }),
          expectedScore: 7,
        },
        {
          user: new User("user2", "funny username", 101),
          prediction: new HeatPrediction({
            finalist1: 1,
            finalist2: 2,
            semifinalist1: 3,
            semifinalist2: 4,
            fifthPlace: 5,
          }),
          expectedScore: 115,
        },
        {
          user: new User("user3", "good name", 1),
          prediction: undefined,
          expectedScore: 1,
        },
      ],
      competition: "heat1",
      result: new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult(),
    },
    {
      testName: "should calculate score correctly for heat2",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 0),
          prediction: new HeatPrediction({
            finalist1: 1,
            finalist2: 2,
            semifinalist1: 3,
            semifinalist2: 4,
            fifthPlace: 5,
          }),
          expectedScore: 14,
        },
      ],
      competition: "heat2",
      result: new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult(),
    },
    {
      testName: "should calculate score correctly for heat3",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 0),
          prediction: new HeatPrediction({
            finalist1: 1,
            finalist2: 2,
            semifinalist1: 3,
            semifinalist2: 4,
            fifthPlace: 5,
          }),
          expectedScore: 14,
        },
      ],
      competition: "heat3",
      result: new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult(),
    },
    {
      testName: "should calculate score correctly for heat4",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 0),
          prediction: new HeatPrediction({
            finalist1: 1,
            finalist2: 2,
            semifinalist1: 3,
            semifinalist2: 4,
            fifthPlace: 5,
          }),
          expectedScore: 14,
        },
      ],
      competition: "heat4",
      result: new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult(),
    },
    {
      testName: "should calculate score correctly for heat5",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 0),
          prediction: new HeatPrediction({
            finalist1: 1,
            finalist2: 2,
            semifinalist1: 3,
            semifinalist2: 4,
            fifthPlace: 5,
          }),
          expectedScore: 14,
        },
      ],
      competition: "heat5",
      result: new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult(),
    },
  ];

  heatTests.forEach(
    ({
      testName,
      usersWithPredictionAndExpectedScore,
      competition,
      result,
    }) => {
      it(`heat: ${testName}`, async function () {
        await testCalculateTotalScore(
          competition,
          usersWithPredictionAndExpectedScore,
          result
        );
      });
    }
  );

  const semifinalTests = [
    {
      testName: "should calculate score correctly for perfect prediction",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 0),
          prediction: new SemifinalPrediction({
            finalist1: 1,
            finalist2: 2,
          }),
          expectedScore: 6,
        },
      ],
      result: new SemifinalResult({
        finalist1: 1,
        finalist2: 2,
      }).toResult(),
    },
    {
      testName: "should calculate score correctly when user has totalScore > 0",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 4),
          prediction: new SemifinalPrediction({
            finalist1: 1,
            finalist2: 2,
          }),
          expectedScore: 10,
        },
      ],
      result: new SemifinalResult({
        finalist1: 1,
        finalist2: 2,
      }).toResult(),
    },
    {
      testName: "should calculate score correctly when one finalist correct",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 7),
          prediction: new SemifinalPrediction({
            finalist1: 1,
            finalist2: 3,
          }),
          expectedScore: 10,
        },
      ],
      result: new SemifinalResult({
        finalist1: 1,
        finalist2: 2,
      }).toResult(),
    },
    {
      testName: "should calculate score correctly when no finalist correct",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 99),
          prediction: new SemifinalPrediction({
            finalist1: 2,
            finalist2: 5,
          }),
          expectedScore: 99,
        },
      ],
      result: new SemifinalResult({
        finalist1: 4,
        finalist2: 8,
      }).toResult(),
    },
    {
      testName: "should not change score when no prediction",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 5),
          prediction: undefined,
          expectedScore: 5,
        },
      ],
      result: new SemifinalResult({
        finalist1: 1,
        finalist2: 2,
      }).toResult(),
    },
    {
      testName: "should calculate score correctly for multiple users",
      usersWithPredictionAndExpectedScore: [
        {
          user: new User("user1", "testUser1", 3),
          prediction: new SemifinalPrediction({
            finalist1: 2,
            finalist2: 1,
          }),
          expectedScore: 9,
        },
        {
          user: new User("user2", "username 2", 78),
          prediction: new SemifinalPrediction({
            finalist1: 2,
            finalist2: 5,
          }),
          expectedScore: 81,
        },
        {
          user: new User("user3", "third name", 95),
          prediction: undefined,
          expectedScore: 95,
        },
      ],
      result: new SemifinalResult({
        finalist1: 1,
        finalist2: 2,
      }).toResult(),
    },
  ];

  semifinalTests.forEach(
    ({ testName, usersWithPredictionAndExpectedScore, result }) => {
      it(`semifinal: ${testName}`, async function () {
        await testCalculateTotalScore(
          "semifinal",
          usersWithPredictionAndExpectedScore,
          result
        );
      });
    }
  );

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

async function testCalculateTotalScore(
  competition: string,
  usersWithPredictionAndExpectedScore: (
    | { user: User; prediction: any; expectedScore: number }
    | { user: User; prediction: undefined; expectedScore: number }
  )[],
  result: any
) {
  const competitionPath = `competitions/${competition}`;

  for (var { user, prediction } of usersWithPredictionAndExpectedScore) {
    await addUserToDatabase(user);
    await addPredictionToDatabase(competitionPath, user.id, prediction);
  }
  await addResultToDatabase(competitionPath, result);

  const change = createChange(competitionPath, result);
  const event = createEvent(change, competition);

  // When
  const wrappedCalculateTotalScores = test.wrap(calculateTotalScores);
  await wrappedCalculateTotalScores(event);

  // Then
  for (var { user, expectedScore } of usersWithPredictionAndExpectedScore) {
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);
  }
}

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
