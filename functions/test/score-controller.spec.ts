import { db } from "../src/config/firebase";
import { calculateScores } from "../src/index";
import functions from "firebase-functions-test";
import { expect } from "chai";
import { User, userConverter } from "../src/models/user";
import {
  HeatPredictionAndScore,
  heatPredictionAndScoreConverter,
} from "../src/models/heat-prediction-and-score";
import {
  SemifinalPredictionAndScore,
  semifinalPredictionAndScoreConverter,
} from "../src/models/semifinal-prediction-and-score";
import {
  FinalPredictionAndScore,
  finalPredictionAndScoreConverter,
} from "../src/models/final-prediction-and-score";
import { HeatResult } from "../src/models/heat-result";
import { SemifinalResult } from "../src/models/semifinal-result";
import { FinalResult } from "../src/models/final-result";
import { Change } from "firebase-functions/v1";
import { PredictionAndScore } from "../src/models/prediction-and-score";

const test = functions(
  {
    projectId: "mellotippet-test",
  },
  ".firebase/service-account-test.json"
);

describe("calculateScores when adding heat result", function () {
  afterEach(async function () {
    await resetEntireDatabase();
    test.cleanup();
  });

  const heats = ["heat1", "heat2", "heat3", "heat4", "heat5"];

  heats.forEach((heat) => {
    it(`heat: should calculate perfect score correctly for ${heat}`, async function () {
      // Given
      const competition = heat;
      const competitionPath = `competitions/${competition}`;

      const user = new User("user1", "testUser1", 0);
      const prediction = new HeatPredictionAndScore({
        finalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
        finalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
        semifinalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
        semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
        fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
      });
      const expectedScore = 14;

      const result = new HeatResult({
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
      }).toResult();

      await addUserToDatabase(user);
      await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
      await addResultToDatabase(competitionPath, result);

      const change = createChange(competitionPath, result);
      const event = createEvent(change, competition);

      // When
      const wrappedCalculateScores = test.wrap(calculateScores);
      await wrappedCalculateScores(event);
      await wrappedCalculateScores(event);

      // Then
      const userAfter = await getUserFromDatabase(user.id);
      expect(userAfter?.totalScore).to.equal(expectedScore);

      const expectedHeatPredictionAndScore = new HeatPredictionAndScore({
        finalist1: new PredictionAndScore({ prediction: 1, score: 5 }),
        finalist2: new PredictionAndScore({ prediction: 2, score: 5 }),
        semifinalist1: new PredictionAndScore({ prediction: 3, score: 2 }),
        semifinalist2: new PredictionAndScore({ prediction: 4, score: 2 }),
        fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
      });

      const predictionAndScoreAfter =
        await getHeatPredictionAndScoreFromDatabase(competitionPath, user.id);
      expect(predictionAndScoreAfter).to.deep.equal(
        expectedHeatPredictionAndScore
      );
    });
  });

  it("heat: should calculate score correctly when one finalist on semifinal", async function () {
    // Given
    const competition = "heat1";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
      finalist2: new PredictionAndScore({ prediction: 3, score: 0 }),
      semifinalist1: new PredictionAndScore({ prediction: 2, score: 0 }),
      semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
      fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
    });
    const expectedScore = 11;

    const result = new HeatResult({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
    }).toResult();

    await addUserToDatabase(user);
    await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedHeatPredictionAndScore = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 1, score: 5 }),
      finalist2: new PredictionAndScore({ prediction: 3, score: 1 }),
      semifinalist1: new PredictionAndScore({ prediction: 2, score: 3 }),
      semifinalist2: new PredictionAndScore({ prediction: 4, score: 2 }),
      fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
    });

    const predictionAndScoreAfter = await getHeatPredictionAndScoreFromDatabase(
      competitionPath,
      user.id
    );
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedHeatPredictionAndScore
    );
  });

  it("heat: should calculate score correctly when two finalists on semifinal", async function () {
    // Given
    const competition = "heat1";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
      finalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
      semifinalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
      semifinalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
      fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
    });
    const expectedScore = 8;

    const result = new HeatResult({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
    }).toResult();

    await addUserToDatabase(user);
    await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedHeatPredictionAndScore = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 3, score: 1 }),
      finalist2: new PredictionAndScore({ prediction: 4, score: 1 }),
      semifinalist1: new PredictionAndScore({ prediction: 1, score: 3 }),
      semifinalist2: new PredictionAndScore({ prediction: 2, score: 3 }),
      fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
    });

    const predictionAndScoreAfter = await getHeatPredictionAndScoreFromDatabase(
      competitionPath,
      user.id
    );
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedHeatPredictionAndScore
    );
  });

  it("heat: should calculate score correctly when finalist on fifth place", async function () {
    // Given
    const competition = "heat1";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
      finalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
      semifinalist1: new PredictionAndScore({ prediction: 6, score: 0 }),
      semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
      fifthPlace: new PredictionAndScore({ prediction: 1, score: 0 }),
    });
    const expectedScore = 3;

    const result = new HeatResult({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
    }).toResult();

    await addUserToDatabase(user);
    await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedHeatPredictionAndScore = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 3, score: 1 }),
      finalist2: new PredictionAndScore({ prediction: 4, score: 1 }),
      semifinalist1: new PredictionAndScore({ prediction: 6, score: 0 }),
      semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
      fifthPlace: new PredictionAndScore({ prediction: 1, score: 1 }),
    });

    const predictionAndScoreAfter = await getHeatPredictionAndScoreFromDatabase(
      competitionPath,
      user.id
    );
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedHeatPredictionAndScore
    );
  });

  it("heat: should calculate score correctly when semifinalist on fifth place", async function () {
    // Given
    const competition = "heat1";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
      finalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
      semifinalist1: new PredictionAndScore({ prediction: 6, score: 0 }),
      semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
      fifthPlace: new PredictionAndScore({ prediction: 1, score: 0 }),
    });
    const expectedScore = 11;

    const result = new HeatResult({
      finalist1: 3,
      finalist2: 4,
      semifinalist1: 2,
      semifinalist2: 1,
    }).toResult();

    await addUserToDatabase(user);
    await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedHeatPredictionAndScore = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 3, score: 5 }),
      finalist2: new PredictionAndScore({ prediction: 4, score: 5 }),
      semifinalist1: new PredictionAndScore({ prediction: 6, score: 0 }),
      semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
      fifthPlace: new PredictionAndScore({ prediction: 1, score: 1 }),
    });

    const predictionAndScoreAfter = await getHeatPredictionAndScoreFromDatabase(
      competitionPath,
      user.id
    );
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedHeatPredictionAndScore
    );
  });

  it("heat: should calculate score correctly for multiple users", async function () {
    // Given
    const competition = "heat1";
    const competitionPath = `competitions/${competition}`;

    const usersWithPredictionAndExpectedScore = [
      {
        user: new User("user1", "testUser1", 0),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 1, score: 0 }),
        }),
        expectedTotalScore: 3,
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 1 }),
          finalist2: new PredictionAndScore({ prediction: 4, score: 1 }),
          semifinalist1: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 1, score: 1 }),
        }),
      },
      {
        user: new User("user2", "funny username", 0),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
        expectedTotalScore: 14,
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 1, score: 5 }),
          finalist2: new PredictionAndScore({ prediction: 2, score: 5 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 2 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 2 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
      },
      {
        user: new User("user3", "good name", 0),
        prediction: undefined,
        expectedTotalScore: 0,
        expectedHeatPredictionAndScore: undefined,
      },
    ];

    const result = new HeatResult({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
    }).toResult();

    for (const { user, prediction } of usersWithPredictionAndExpectedScore) {
      await addUserToDatabase(user);
      await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
    }
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    for (const {
      user,
      expectedTotalScore,
      expectedHeatPredictionAndScore,
    } of usersWithPredictionAndExpectedScore) {
      const userAfter = await getUserFromDatabase(user.id);
      expect(userAfter?.totalScore).to.equal(expectedTotalScore);

      const predictionAndScoreAfter =
        await getHeatPredictionAndScoreFromDatabase(competitionPath, user.id);
      expect(predictionAndScoreAfter).to.deep.equal(
        expectedHeatPredictionAndScore
      );
    }
  });

  it("heat: should not change score when no prediction", async function () {
    // Given
    const competition = "heat1";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = undefined;
    const expectedScore = 0;

    const result = new HeatResult({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
    }).toResult();

    await addUserToDatabase(user);
    await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedHeatPredictionAndScore = undefined;
    const predictionAndScoreAfter = await getHeatPredictionAndScoreFromDatabase(
      competitionPath,
      user.id
    );
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedHeatPredictionAndScore
    );
  });

  it("heat: should calculate score correctly when multiple competitions", async function () {
    // Given
    const competition = "heat4";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
      finalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
      semifinalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
      semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
      fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
    });
    const expectedScore = 56;

    const result = new HeatResult({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
    }).toResult();

    await addUserToDatabase(user);
    await addHeatPredictionToDatabase(
      "competitions/heat1",
      user.id,
      prediction
    );
    await addHeatPredictionToDatabase(
      "competitions/heat2",
      user.id,
      prediction
    );
    await addHeatPredictionToDatabase(
      "competitions/heat3",
      user.id,
      prediction
    );
    await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase("competitions/heat1", result);
    await addResultToDatabase("competitions/heat2", result);
    await addResultToDatabase("competitions/heat3", result);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedHeatPredictionAndScore = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 1, score: 5 }),
      finalist2: new PredictionAndScore({ prediction: 2, score: 5 }),
      semifinalist1: new PredictionAndScore({ prediction: 3, score: 2 }),
      semifinalist2: new PredictionAndScore({ prediction: 4, score: 2 }),
      fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
    });

    const predictionAndScoreAfter = await getHeatPredictionAndScoreFromDatabase(
      competitionPath,
      user.id
    );
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedHeatPredictionAndScore
    );
  });

  it("heat: should calculate perfect score correctly when called twice", async function () {
    // Given
    const competition = "heat4";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
      finalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
      semifinalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
      semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
      fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
    });
    const expectedScore = 14;

    const result = new HeatResult({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
    }).toResult();

    await addUserToDatabase(user);
    await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedHeatPredictionAndScore = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 1, score: 5 }),
      finalist2: new PredictionAndScore({ prediction: 2, score: 5 }),
      semifinalist1: new PredictionAndScore({ prediction: 3, score: 2 }),
      semifinalist2: new PredictionAndScore({ prediction: 4, score: 2 }),
      fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
    });

    const predictionAndScoreAfter = await getHeatPredictionAndScoreFromDatabase(
      competitionPath,
      user.id
    );
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedHeatPredictionAndScore
    );
  });

  it("heat: should calculate score correctly when multiple users and multiple competitions", async function () {
    // Given
    const competition = "heat4";
    const competitionPath = `competitions/${competition}`;

    const users = [
      new User("user1", "testUser1", 0),
      new User("user2", "testUser2", 0),
      new User("user3", "testUser3", 0),
      new User("user4", "testUser3", 0),
      new User("user5", "testUser3", 0),
      new User("user6", "testUser3", 0),
      new User("user7", "testUser3", 0),
      new User("user8", "testUser3", 0),
      new User("user9", "testUser3", 0),
      new User("user10", "testUser3", 0),
      new User("user11", "testUser3", 0),
    ];
    const prediction = new HeatPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
      finalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
      semifinalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
      semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
      fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
    });
    const expectedScore = 56;

    const result = new HeatResult({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
    }).toResult();

    for (const user of users) {
      await addUserToDatabase(user);

      await addHeatPredictionToDatabase(
        "competitions/heat1",
        user.id,
        prediction
      );
      await addHeatPredictionToDatabase(
        "competitions/heat2",
        user.id,
        prediction
      );
      await addHeatPredictionToDatabase(
        "competitions/heat3",
        user.id,
        prediction
      );
      await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
    }
    await addResultToDatabase("competitions/heat1", result);
    await addResultToDatabase("competitions/heat2", result);
    await addResultToDatabase("competitions/heat3", result);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    for (const user of users) {
      const userAfter = await getUserFromDatabase(user.id);
      expect(userAfter?.totalScore).to.equal(expectedScore);

      const expectedHeatPredictionAndScore = new HeatPredictionAndScore({
        finalist1: new PredictionAndScore({ prediction: 1, score: 5 }),
        finalist2: new PredictionAndScore({ prediction: 2, score: 5 }),
        semifinalist1: new PredictionAndScore({ prediction: 3, score: 2 }),
        semifinalist2: new PredictionAndScore({ prediction: 4, score: 2 }),
        fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
      });

      const predictionAndScoreAfter =
        await getHeatPredictionAndScoreFromDatabase(competitionPath, user.id);
      expect(predictionAndScoreAfter).to.deep.equal(
        expectedHeatPredictionAndScore
      );
    }
  });
});

describe("calculateScores when adding semifinal result", function () {
  afterEach(async function () {
    await resetEntireDatabase();
    test.cleanup();
  });
  it("semifinal: should calculate score correctly for perfect prediction", async function () {
    const competition = "semifinal";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new SemifinalPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
      finalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
    });
    const expectedScore = 6;

    const result = new SemifinalResult({
      finalist1: 1,
      finalist2: 2,
    }).toResult();

    await addUserToDatabase(user);
    await addSemifinalPredictionToDatabase(
      competitionPath,
      user.id,
      prediction
    );
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedSemifinalPredictionAndScore = new SemifinalPredictionAndScore(
      {
        finalist1: new PredictionAndScore({ prediction: 1, score: 3 }),
        finalist2: new PredictionAndScore({ prediction: 2, score: 3 }),
      }
    );
    const predictionAndScoreAfter =
      await getSemifinalPredictionAndScoreFromDatabase(
        competitionPath,
        user.id
      );
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedSemifinalPredictionAndScore
    );
  });

  it("semifinal: should calculate score correctly when one finalist correct", async function () {
    const competition = "semifinal";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new SemifinalPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
      finalist2: new PredictionAndScore({ prediction: 3, score: 0 }),
    });
    const expectedScore = 3;

    const result = new SemifinalResult({
      finalist1: 1,
      finalist2: 2,
    }).toResult();

    await addUserToDatabase(user);
    await addSemifinalPredictionToDatabase(
      competitionPath,
      user.id,
      prediction
    );
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedSemifinalPredictionAndScore = new SemifinalPredictionAndScore(
      {
        finalist1: new PredictionAndScore({ prediction: 1, score: 3 }),
        finalist2: new PredictionAndScore({ prediction: 3, score: 0 }),
      }
    );
    const predictionAndScoreAfter =
      await getSemifinalPredictionAndScoreFromDatabase(
        competitionPath,
        user.id
      );
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedSemifinalPredictionAndScore
    );
  });

  it("semifinal: should calculate score correctly when no finalist correct", async function () {
    const competition = "semifinal";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new SemifinalPredictionAndScore({
      finalist1: new PredictionAndScore({ prediction: 2, score: 0 }),
      finalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
    });
    const expectedScore = 0;

    const result = new SemifinalResult({
      finalist1: 4,
      finalist2: 8,
    }).toResult();

    await addUserToDatabase(user);
    await addSemifinalPredictionToDatabase(
      competitionPath,
      user.id,
      prediction
    );
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedSemifinalPredictionAndScore = new SemifinalPredictionAndScore(
      {
        finalist1: new PredictionAndScore({ prediction: 2, score: 0 }),
        finalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
      }
    );
    const predictionAndScoreAfter =
      await getSemifinalPredictionAndScoreFromDatabase(
        competitionPath,
        user.id
      );
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedSemifinalPredictionAndScore
    );
  });

  it("semifinal: should not change score when no prediction", async function () {
    const competition = "semifinal";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = undefined;
    const expectedScore = 0;

    const result = new SemifinalResult({
      finalist1: 1,
      finalist2: 2,
    }).toResult();

    await addUserToDatabase(user);
    await addSemifinalPredictionToDatabase(
      competitionPath,
      user.id,
      prediction
    );
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedSemifinalPredictionAndScore = undefined;
    const predictionAndScoreAfter =
      await getSemifinalPredictionAndScoreFromDatabase(
        competitionPath,
        user.id
      );
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedSemifinalPredictionAndScore
    );
  });

  it("semifinal: should calculate score correctly for multiple users", async function () {
    const competition = "semifinal";
    const competitionPath = `competitions/${competition}`;

    const usersWithPredictionAndExpectedScore = [
      {
        user: new User("user1", "testUser1", 0),
        prediction: new SemifinalPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 2, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 1, score: 0 }),
        }),
        expectedScore: 6,
        expectedSemifinalPredictionAndScore: new SemifinalPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 2, score: 3 }),
          finalist2: new PredictionAndScore({ prediction: 1, score: 3 }),
        }),
      },
      {
        user: new User("user2", "username 2", 0),
        prediction: new SemifinalPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 2, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
        expectedScore: 3,
        expectedSemifinalPredictionAndScore: new SemifinalPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 2, score: 3 }),
          finalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
      },
      {
        user: new User("user3", "third name", 0),
        prediction: undefined,
        expectedScore: 0,
        expectedSemifinalPredictionAndScore: undefined,
      },
    ];

    const result = new SemifinalResult({
      finalist1: 1,
      finalist2: 2,
    }).toResult();

    for (const { user, prediction } of usersWithPredictionAndExpectedScore) {
      await addUserToDatabase(user);
      await addSemifinalPredictionToDatabase(
        competitionPath,
        user.id,
        prediction
      );
    }
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    for (const {
      user,
      expectedScore,
      expectedSemifinalPredictionAndScore,
    } of usersWithPredictionAndExpectedScore) {
      const userAfter = await getUserFromDatabase(user.id);
      expect(userAfter?.totalScore).to.equal(expectedScore);

      const predictionAndScoreAfter =
        await getSemifinalPredictionAndScoreFromDatabase(
          competitionPath,
          user.id
        );
      expect(predictionAndScoreAfter).to.deep.equal(
        expectedSemifinalPredictionAndScore
      );
    }
  });
});

describe("calculateScores when adding final result", function () {
  afterEach(async function () {
    await resetEntireDatabase();
    test.cleanup();
  });
  it("final: should calculate score correctly for perfect prediction", async function () {
    const competition = "final";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new FinalPredictionAndScore({
      placement1: new PredictionAndScore({ prediction: 1, score: 0 }),
      placement2: new PredictionAndScore({ prediction: 2, score: 0 }),
      placement3: new PredictionAndScore({ prediction: 3, score: 0 }),
      placement4: new PredictionAndScore({ prediction: 4, score: 0 }),
      placement5: new PredictionAndScore({ prediction: 5, score: 0 }),
      placement6: new PredictionAndScore({ prediction: 6, score: 0 }),
      placement7: new PredictionAndScore({ prediction: 7, score: 0 }),
      placement8: new PredictionAndScore({ prediction: 8, score: 0 }),
      placement9: new PredictionAndScore({ prediction: 9, score: 0 }),
      placement10: new PredictionAndScore({ prediction: 10, score: 0 }),
      placement11: new PredictionAndScore({ prediction: 11, score: 0 }),
      placement12: new PredictionAndScore({ prediction: 12, score: 0 }),
    });
    const expectedScore = 40;

    const result = new FinalResult({
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

    await addUserToDatabase(user);
    await addFinalPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedFinalPredictionAndScore = new FinalPredictionAndScore({
      placement1: new PredictionAndScore({ prediction: 1, score: 5 }),
      placement2: new PredictionAndScore({ prediction: 2, score: 5 }),
      placement3: new PredictionAndScore({ prediction: 3, score: 5 }),
      placement4: new PredictionAndScore({ prediction: 4, score: 5 }),
      placement5: new PredictionAndScore({ prediction: 5, score: 3 }),
      placement6: new PredictionAndScore({ prediction: 6, score: 3 }),
      placement7: new PredictionAndScore({ prediction: 7, score: 3 }),
      placement8: new PredictionAndScore({ prediction: 8, score: 3 }),
      placement9: new PredictionAndScore({ prediction: 9, score: 2 }),
      placement10: new PredictionAndScore({ prediction: 10, score: 2 }),
      placement11: new PredictionAndScore({ prediction: 11, score: 2 }),
      placement12: new PredictionAndScore({ prediction: 12, score: 2 }),
    });
    const predictionAndScoreAfter =
      await getFinalPredictionAndScoreFromDatabase(competitionPath, user.id);
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedFinalPredictionAndScore
    );
  });

  it("final: should calculate score correctly when result order is different", async function () {
    const competition = "final";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new FinalPredictionAndScore({
      placement1: new PredictionAndScore({ prediction: 8, score: 0 }),
      placement2: new PredictionAndScore({ prediction: 7, score: 0 }),
      placement3: new PredictionAndScore({ prediction: 4, score: 0 }),
      placement4: new PredictionAndScore({ prediction: 5, score: 0 }),
      placement5: new PredictionAndScore({ prediction: 12, score: 0 }),
      placement6: new PredictionAndScore({ prediction: 10, score: 0 }),
      placement7: new PredictionAndScore({ prediction: 3, score: 0 }),
      placement8: new PredictionAndScore({ prediction: 6, score: 0 }),
      placement9: new PredictionAndScore({ prediction: 1, score: 0 }),
      placement10: new PredictionAndScore({ prediction: 11, score: 0 }),
      placement11: new PredictionAndScore({ prediction: 2, score: 0 }),
      placement12: new PredictionAndScore({ prediction: 9, score: 0 }),
    });
    const expectedScore = 40;

    const result = new FinalResult({
      placement1: 8,
      placement2: 7,
      placement3: 4,
      placement4: 5,
      placement5: 12,
      placement6: 10,
      placement7: 3,
      placement8: 6,
      placement9: 1,
      placement10: 11,
      placement11: 2,
      placement12: 9,
    }).toResult();

    await addUserToDatabase(user);
    await addFinalPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedFinalPredictionAndScore = new FinalPredictionAndScore({
      placement1: new PredictionAndScore({ prediction: 8, score: 5 }),
      placement2: new PredictionAndScore({ prediction: 7, score: 5 }),
      placement3: new PredictionAndScore({ prediction: 4, score: 5 }),
      placement4: new PredictionAndScore({ prediction: 5, score: 5 }),
      placement5: new PredictionAndScore({ prediction: 12, score: 3 }),
      placement6: new PredictionAndScore({ prediction: 10, score: 3 }),
      placement7: new PredictionAndScore({ prediction: 3, score: 3 }),
      placement8: new PredictionAndScore({ prediction: 6, score: 3 }),
      placement9: new PredictionAndScore({ prediction: 1, score: 2 }),
      placement10: new PredictionAndScore({ prediction: 11, score: 2 }),
      placement11: new PredictionAndScore({ prediction: 2, score: 2 }),
      placement12: new PredictionAndScore({ prediction: 9, score: 2 }),
    });
    const predictionAndScoreAfter =
      await getFinalPredictionAndScoreFromDatabase(competitionPath, user.id);
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedFinalPredictionAndScore
    );
  });

  it("final: should calculate score correctly when mistakes", async function () {
    const competition = "final";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new FinalPredictionAndScore({
      placement1: new PredictionAndScore({ prediction: 7, score: 0 }),
      placement2: new PredictionAndScore({ prediction: 3, score: 0 }),
      placement3: new PredictionAndScore({ prediction: 8, score: 0 }),
      placement4: new PredictionAndScore({ prediction: 12, score: 0 }),
      placement5: new PredictionAndScore({ prediction: 9, score: 0 }),
      placement6: new PredictionAndScore({ prediction: 4, score: 0 }),
      placement7: new PredictionAndScore({ prediction: 2, score: 0 }),
      placement8: new PredictionAndScore({ prediction: 5, score: 0 }),
      placement9: new PredictionAndScore({ prediction: 1, score: 0 }),
      placement10: new PredictionAndScore({ prediction: 6, score: 0 }),
      placement11: new PredictionAndScore({ prediction: 10, score: 0 }),
      placement12: new PredictionAndScore({ prediction: 11, score: 0 }),
    });
    const expectedScore = 15;

    const result = new FinalResult({
      placement1: 8,
      placement2: 7,
      placement3: 4,
      placement4: 5,
      placement5: 12,
      placement6: 10,
      placement7: 3,
      placement8: 6,
      placement9: 1,
      placement10: 11,
      placement11: 2,
      placement12: 9,
    }).toResult();

    await addUserToDatabase(user);
    await addFinalPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedFinalPredictionAndScore = new FinalPredictionAndScore({
      placement1: new PredictionAndScore({ prediction: 7, score: 4 }),
      placement2: new PredictionAndScore({ prediction: 3, score: 0 }),
      placement3: new PredictionAndScore({ prediction: 8, score: 3 }),
      placement4: new PredictionAndScore({ prediction: 12, score: 2 }),
      placement5: new PredictionAndScore({ prediction: 9, score: 0 }),
      placement6: new PredictionAndScore({ prediction: 4, score: 2 }),
      placement7: new PredictionAndScore({ prediction: 2, score: 0 }),
      placement8: new PredictionAndScore({ prediction: 5, score: 1 }),
      placement9: new PredictionAndScore({ prediction: 1, score: 2 }),
      placement10: new PredictionAndScore({ prediction: 6, score: 1 }),
      placement11: new PredictionAndScore({ prediction: 10, score: 0 }),
      placement12: new PredictionAndScore({ prediction: 11, score: 0 }),
    });
    const predictionAndScoreAfter =
      await getFinalPredictionAndScoreFromDatabase(competitionPath, user.id);
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedFinalPredictionAndScore
    );
  });

  it("final: should calculate score correctly when mistakes 2", async function () {
    const competition = "final";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = new FinalPredictionAndScore({
      placement1: new PredictionAndScore({ prediction: 7, score: 0 }),
      placement2: new PredictionAndScore({ prediction: 3, score: 0 }),
      placement3: new PredictionAndScore({ prediction: 8, score: 0 }),
      placement4: new PredictionAndScore({ prediction: 12, score: 0 }),
      placement5: new PredictionAndScore({ prediction: 9, score: 0 }),
      placement6: new PredictionAndScore({ prediction: 4, score: 0 }),
      placement7: new PredictionAndScore({ prediction: 2, score: 0 }),
      placement8: new PredictionAndScore({ prediction: 5, score: 0 }),
      placement9: new PredictionAndScore({ prediction: 1, score: 0 }),
      placement10: new PredictionAndScore({ prediction: 6, score: 0 }),
      placement11: new PredictionAndScore({ prediction: 10, score: 0 }),
      placement12: new PredictionAndScore({ prediction: 11, score: 0 }),
    });
    const expectedScore = 9;

    const result = new FinalResult({
      placement1: 5,
      placement2: 1,
      placement3: 4,
      placement4: 8,
      placement5: 12,
      placement6: 11,
      placement7: 6,
      placement8: 3,
      placement9: 7,
      placement10: 10,
      placement11: 9,
      placement12: 2,
    }).toResult();

    await addUserToDatabase(user);
    await addFinalPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedFinalPredictionAndScore = new FinalPredictionAndScore({
      placement1: new PredictionAndScore({ prediction: 7, score: 0 }),
      placement2: new PredictionAndScore({ prediction: 3, score: 0 }),
      placement3: new PredictionAndScore({ prediction: 8, score: 4 }),
      placement4: new PredictionAndScore({ prediction: 12, score: 2 }),
      placement5: new PredictionAndScore({ prediction: 9, score: 0 }),
      placement6: new PredictionAndScore({ prediction: 4, score: 2 }),
      placement7: new PredictionAndScore({ prediction: 2, score: 0 }),
      placement8: new PredictionAndScore({ prediction: 5, score: 0 }),
      placement9: new PredictionAndScore({ prediction: 1, score: 0 }),
      placement10: new PredictionAndScore({ prediction: 6, score: 0 }),
      placement11: new PredictionAndScore({ prediction: 10, score: 1 }),
      placement12: new PredictionAndScore({ prediction: 11, score: 0 }),
    });
    const predictionAndScoreAfter =
      await getFinalPredictionAndScoreFromDatabase(competitionPath, user.id);
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedFinalPredictionAndScore
    );
  });

  it("final: should not change score when no prediction", async function () {
    const competition = "final";
    const competitionPath = `competitions/${competition}`;

    const user = new User("user1", "testUser1", 0);
    const prediction = undefined;
    const expectedScore = 0;

    const result = new FinalResult({
      placement1: 8,
      placement2: 7,
      placement3: 4,
      placement4: 5,
      placement5: 12,
      placement6: 10,
      placement7: 3,
      placement8: 6,
      placement9: 1,
      placement10: 11,
      placement11: 2,
      placement12: 9,
    }).toResult();

    await addUserToDatabase(user);
    await addFinalPredictionToDatabase(competitionPath, user.id, prediction);
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    const userAfter = await getUserFromDatabase(user.id);
    expect(userAfter?.totalScore).to.equal(expectedScore);

    const expectedFinalPredictionAndScore = undefined;
    const predictionAndScoreAfter =
      await getFinalPredictionAndScoreFromDatabase(competitionPath, user.id);
    expect(predictionAndScoreAfter).to.deep.equal(
      expectedFinalPredictionAndScore
    );
  });

  it("final: should calculate score correctly for multiple users", async function () {
    const competition = "final";
    const competitionPath = `competitions/${competition}`;

    const usersWithPredictionAndExpectedScore = [
      {
        user: new User("user1", "testUser1", 0),
        prediction: new FinalPredictionAndScore({
          placement1: new PredictionAndScore({ prediction: 7, score: 0 }),
          placement2: new PredictionAndScore({ prediction: 3, score: 0 }),
          placement3: new PredictionAndScore({ prediction: 8, score: 0 }),
          placement4: new PredictionAndScore({ prediction: 11, score: 0 }),
          placement5: new PredictionAndScore({ prediction: 12, score: 0 }),
          placement6: new PredictionAndScore({ prediction: 4, score: 0 }),
          placement7: new PredictionAndScore({ prediction: 10, score: 0 }),
          placement8: new PredictionAndScore({ prediction: 5, score: 0 }),
          placement9: new PredictionAndScore({ prediction: 1, score: 0 }),
          placement10: new PredictionAndScore({ prediction: 6, score: 0 }),
          placement11: new PredictionAndScore({ prediction: 2, score: 0 }),
          placement12: new PredictionAndScore({ prediction: 9, score: 0 }),
        }),
        expectedScore: 22,
        expectedFinalPredictionAndScore: new FinalPredictionAndScore({
          placement1: new PredictionAndScore({ prediction: 7, score: 4 }),
          placement2: new PredictionAndScore({ prediction: 3, score: 0 }),
          placement3: new PredictionAndScore({ prediction: 8, score: 3 }),
          placement4: new PredictionAndScore({ prediction: 11, score: 0 }),
          placement5: new PredictionAndScore({ prediction: 12, score: 3 }),
          placement6: new PredictionAndScore({ prediction: 4, score: 2 }),
          placement7: new PredictionAndScore({ prediction: 10, score: 2 }),
          placement8: new PredictionAndScore({ prediction: 5, score: 1 }),
          placement9: new PredictionAndScore({ prediction: 1, score: 2 }),
          placement10: new PredictionAndScore({ prediction: 6, score: 1 }),
          placement11: new PredictionAndScore({ prediction: 2, score: 2 }),
          placement12: new PredictionAndScore({ prediction: 9, score: 2 }),
        }),
      },
      {
        user: new User("user2", "username 2", 0),
        prediction: new FinalPredictionAndScore({
          placement1: new PredictionAndScore({ prediction: 5, score: 0 }),
          placement2: new PredictionAndScore({ prediction: 3, score: 0 }),
          placement3: new PredictionAndScore({ prediction: 8, score: 0 }),
          placement4: new PredictionAndScore({ prediction: 11, score: 0 }),
          placement5: new PredictionAndScore({ prediction: 12, score: 0 }),
          placement6: new PredictionAndScore({ prediction: 4, score: 0 }),
          placement7: new PredictionAndScore({ prediction: 10, score: 0 }),
          placement8: new PredictionAndScore({ prediction: 7, score: 0 }),
          placement9: new PredictionAndScore({ prediction: 1, score: 0 }),
          placement10: new PredictionAndScore({ prediction: 6, score: 0 }),
          placement11: new PredictionAndScore({ prediction: 9, score: 0 }),
          placement12: new PredictionAndScore({ prediction: 2, score: 0 }),
        }),
        expectedScore: 17,
        expectedFinalPredictionAndScore: new FinalPredictionAndScore({
          placement1: new PredictionAndScore({ prediction: 5, score: 2 }),
          placement2: new PredictionAndScore({ prediction: 3, score: 0 }),
          placement3: new PredictionAndScore({ prediction: 8, score: 3 }),
          placement4: new PredictionAndScore({ prediction: 11, score: 0 }),
          placement5: new PredictionAndScore({ prediction: 12, score: 3 }),
          placement6: new PredictionAndScore({ prediction: 4, score: 2 }),
          placement7: new PredictionAndScore({ prediction: 10, score: 2 }),
          placement8: new PredictionAndScore({ prediction: 7, score: 0 }),
          placement9: new PredictionAndScore({ prediction: 1, score: 2 }),
          placement10: new PredictionAndScore({ prediction: 6, score: 1 }),
          placement11: new PredictionAndScore({ prediction: 9, score: 1 }),
          placement12: new PredictionAndScore({ prediction: 2, score: 1 }),
        }),
      },
      {
        user: new User("user3", "third name", 0),
        prediction: undefined,
        expectedScore: 0,
        expectedFinalPredictionAndScore: undefined,
      },
    ];

    const result = new FinalResult({
      placement1: 8,
      placement2: 7,
      placement3: 4,
      placement4: 5,
      placement5: 12,
      placement6: 10,
      placement7: 3,
      placement8: 6,
      placement9: 1,
      placement10: 11,
      placement11: 2,
      placement12: 9,
    }).toResult();

    for (const { user, prediction } of usersWithPredictionAndExpectedScore) {
      await addUserToDatabase(user);
      await addFinalPredictionToDatabase(competitionPath, user.id, prediction);
    }
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);

    // Then
    for (const {
      user,
      expectedScore,
      expectedFinalPredictionAndScore,
    } of usersWithPredictionAndExpectedScore) {
      const userAfter = await getUserFromDatabase(user.id);
      expect(userAfter?.totalScore).to.equal(expectedScore);

      const predictionAndScoreAfter =
        await getFinalPredictionAndScoreFromDatabase(competitionPath, user.id);
      expect(predictionAndScoreAfter).to.deep.equal(
        expectedFinalPredictionAndScore
      );
    }
  });
});

describe("calculateScores in real life scenario", function () {
  beforeEach(async function () {
    await resetEntireDatabase();
    test.cleanup();
  });

  it("given no previous result, when heat1 is added, then calculate the score correctly for multiple users ", async function () {
    // Given
    const competition = "heat1";
    const competitionPath = `competitions/${competition}`;

    const usersWithPredictionAndExpectedScore = [
      {
        user: new User("user1", "testUser1", 0),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 1, score: 0 }),
        }),
        expectedTotalScore: 3,
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 1 }),
          finalist2: new PredictionAndScore({ prediction: 4, score: 1 }),
          semifinalist1: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 1, score: 1 }),
        }),
      },
      {
        user: new User("user2", "funny username", 0),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
        expectedTotalScore: 14,
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 1, score: 5 }),
          finalist2: new PredictionAndScore({ prediction: 2, score: 5 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 2 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 2 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
      },
      {
        user: new User("user3", "good name", 0),
        prediction: undefined,
        expectedTotalScore: 0,
        expectedHeatPredictionAndScore: undefined,
      },
      {
        user: new User("user4", "theking", 0),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 5, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 1, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 6, score: 0 }),
        }),
        expectedTotalScore: 10,
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 5, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 1, score: 5 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 2 }),
          semifinalist2: new PredictionAndScore({ prediction: 2, score: 3 }),
          fifthPlace: new PredictionAndScore({ prediction: 6, score: 0 }),
        }),
      },
      {
        user: new User("user5", "bb47", 0),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
        expectedTotalScore: 6,
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 1 }),
          finalist2: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 1, score: 3 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 2 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
      },
    ];

    const result = new HeatResult({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
    }).toResult();

    for (const { user, prediction } of usersWithPredictionAndExpectedScore) {
      await addUserToDatabase(user);
      await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
    }
    await addResultToDatabase(competitionPath, result);

    const change = createChange(competitionPath, result);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);
    await wrappedCalculateScores(event);
    await wrappedCalculateScores(event);
    await wrappedCalculateScores(event);
    await wrappedCalculateScores(event);

    // Then
    for (const {
      user,
      expectedTotalScore,
      expectedHeatPredictionAndScore,
    } of usersWithPredictionAndExpectedScore) {
      const userAfter = await getUserFromDatabase(user.id);
      expect(userAfter?.totalScore).to.equal(expectedTotalScore);

      const predictionAndScoreAfter =
        await getHeatPredictionAndScoreFromDatabase(competitionPath, user.id);
      expect(predictionAndScoreAfter).to.deep.equal(
        expectedHeatPredictionAndScore
      );
    }
  });

  it.only("given previous heat1 result, when heat2 is added, then calculate the score correctly for multiple users ", async function () {
    // Given
    const competition = "heat2";
    const competitionPath = `competitions/${competition}`;

    const usersWithPredictionAndExpectedScoreHeat1 = [
      {
        user: new User("user1", "testUser1", 0),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 1, score: 0 }),
        }),
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 1 }),
          finalist2: new PredictionAndScore({ prediction: 4, score: 1 }),
          semifinalist1: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 1, score: 1 }),
        }),
      },
      {
        user: new User("user2", "funny username", 0),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 1, score: 5 }),
          finalist2: new PredictionAndScore({ prediction: 2, score: 5 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 2 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 2 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
      },
      {
        user: new User("user3", "good name", 0),
        prediction: undefined,
        expectedHeatPredictionAndScore: undefined,
      },
      {
        user: new User("user4", "theking", 0),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 5, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 1, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 6, score: 0 }),
        }),
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 5, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 1, score: 5 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 2 }),
          semifinalist2: new PredictionAndScore({ prediction: 2, score: 3 }),
          fifthPlace: new PredictionAndScore({ prediction: 6, score: 0 }),
        }),
      },
      {
        user: new User("user5", "bb47", 0),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 1 }),
          finalist2: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 1, score: 3 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 2 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
      },
    ];

    const usersWithPredictionAndExpectedScore = [
      {
        user: new User("user1", "testUser1", 3),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 1, score: 0 }),
        }),
        expectedTotalScore: 13,
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 1 }),
          finalist2: new PredictionAndScore({ prediction: 4, score: 5 }),
          semifinalist1: new PredictionAndScore({ prediction: 6, score: 3 }),
          semifinalist2: new PredictionAndScore({ prediction: 5, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 1, score: 1 }),
        }),
      },
      {
        user: new User("user2", "funny username", 14),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
        expectedTotalScore: 20,
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 1, score: 1 }),
          finalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 2 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 3 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
      },
      {
        user: new User("user3", "good name", 0),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 5, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 1, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 6, score: 0 }),
        }),
        expectedTotalScore: 4,
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 5, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 1, score: 1 }),
          semifinalist1: new PredictionAndScore({ prediction: 3, score: 2 }),
          semifinalist2: new PredictionAndScore({ prediction: 2, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 6, score: 1 }),
        }),
      },

      {
        user: new User("user4", "theking", 10),
        prediction: undefined,
        expectedTotalScore: 10,
        expectedHeatPredictionAndScore: undefined,
      },
      {
        user: new User("user5", "bb47", 6),
        prediction: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 0 }),
          finalist2: new PredictionAndScore({ prediction: 6, score: 0 }),
          semifinalist1: new PredictionAndScore({ prediction: 1, score: 0 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 0 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
        expectedTotalScore: 17,
        expectedHeatPredictionAndScore: new HeatPredictionAndScore({
          finalist1: new PredictionAndScore({ prediction: 3, score: 1 }),
          finalist2: new PredictionAndScore({ prediction: 6, score: 5 }),
          semifinalist1: new PredictionAndScore({ prediction: 1, score: 2 }),
          semifinalist2: new PredictionAndScore({ prediction: 4, score: 3 }),
          fifthPlace: new PredictionAndScore({ prediction: 5, score: 0 }),
        }),
      },
    ];

    const resultHeat1 = new HeatResult({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
    }).toResult();

    const resultHeat2 = new HeatResult({
      finalist1: 6,
      finalist2: 4,
      semifinalist1: 1,
      semifinalist2: 3,
    }).toResult();

    for (const {
      user,
      prediction,
    } of usersWithPredictionAndExpectedScoreHeat1) {
      await addUserToDatabase(user);
      await addHeatPredictionToDatabase(
        "competitions/heat1",
        user.id,
        prediction
      );
    }
    await addResultToDatabase("competitions/heat1", resultHeat1);

    for (const { user, prediction } of usersWithPredictionAndExpectedScore) {
      await addUserToDatabase(user);
      await addHeatPredictionToDatabase(competitionPath, user.id, prediction);
    }
    await addResultToDatabase(competitionPath, resultHeat2);

    const change = createChange(competitionPath, resultHeat2);
    const event = createEvent(change, competition);

    // When
    const wrappedCalculateScores = test.wrap(calculateScores);
    await wrappedCalculateScores(event);
    await wrappedCalculateScores(event);
    await wrappedCalculateScores(event);
    await wrappedCalculateScores(event);
    await wrappedCalculateScores(event);

    // Then
    for (const {
      user,
      expectedHeatPredictionAndScore,
    } of usersWithPredictionAndExpectedScoreHeat1) {
      const predictionAndScoreAfter =
        await getHeatPredictionAndScoreFromDatabase(
          "competitions/heat1",
          user.id
        );
      expect(predictionAndScoreAfter).to.deep.equal(
        expectedHeatPredictionAndScore
      );
    }

    for (const {
      user,
      expectedTotalScore,
      expectedHeatPredictionAndScore,
    } of usersWithPredictionAndExpectedScore) {
      const userAfter = await getUserFromDatabase(user.id);
      expect(userAfter?.totalScore).to.equal(expectedTotalScore);

      const predictionAndScoreAfter =
        await getHeatPredictionAndScoreFromDatabase(competitionPath, user.id);
      expect(predictionAndScoreAfter).to.deep.equal(
        expectedHeatPredictionAndScore
      );
    }
  });
});

async function resetEntireDatabase() {
  const users = [
    "user1",
    "user2",
    "user3",
    "user4",
    "user5",
    "user6",
    "user7",
    "user8",
    "user9",
    "user10",
    "user11",
  ];

  await Promise.all(
    users.map(async (user) => {
      await resetDatabase(user, "heat1");
      await resetDatabase(user, "heat2");
      await resetDatabase(user, "heat3");
      await resetDatabase(user, "heat4");
      await resetDatabase(user, "heat5");
      await resetDatabase(user, "semifinal");
      await resetDatabase(user, "final");
    })
  );
}

async function resetDatabase(userId: string, competition: string) {
  await db.doc(`users/${userId}`).delete();
  await db
    .doc(`competitions/${competition}/predictionsAndScores/${userId}`)
    .delete();
  await db.doc(`competitions/${competition}`).delete();
}

async function addUserToDatabase(user: User) {
  return await db
    .doc(`users/${user.id}`)
    .withConverter(userConverter)
    .set(user);
}

async function addHeatPredictionToDatabase(
  competitionPath: string,
  uid: string,
  prediction: HeatPredictionAndScore | undefined
) {
  if (prediction == undefined) {
    return;
  }

  return await db
    .doc(`${competitionPath}/predictionsAndScores/${uid}`)
    .withConverter(heatPredictionAndScoreConverter)
    .set(prediction);
}

async function addSemifinalPredictionToDatabase(
  competitionPath: string,
  uid: string,
  prediction: SemifinalPredictionAndScore | undefined
) {
  if (prediction == undefined) {
    return;
  }

  return await db
    .doc(`${competitionPath}/predictionsAndScores/${uid}`)
    .withConverter(semifinalPredictionAndScoreConverter)
    .set(prediction);
}

async function addFinalPredictionToDatabase(
  competitionPath: string,
  uid: string,
  prediction: FinalPredictionAndScore | undefined
) {
  if (prediction == undefined) {
    return;
  }

  return await db
    .doc(`${competitionPath}/predictionsAndScores/${uid}`)
    .withConverter(finalPredictionAndScoreConverter)
    .set(prediction);
}

async function addResultToDatabase(competitionPath: string, result: any) {
  return await db.doc(competitionPath).set(result);
}

async function getUserFromDatabase(uid: string) {
  return (
    await db.doc(`users/${uid}`).withConverter(userConverter).get()
  ).data();
}

async function getHeatPredictionAndScoreFromDatabase(
  competitionPath: string,
  uid: string
) {
  return (
    await db
      .doc(`${competitionPath}/predictionsAndScores/${uid}`)
      .withConverter(heatPredictionAndScoreConverter)
      .get()
  ).data();
}

async function getSemifinalPredictionAndScoreFromDatabase(
  competitionPath: string,
  uid: string
) {
  return (
    await db
      .doc(`${competitionPath}/predictionsAndScores/${uid}`)
      .withConverter(semifinalPredictionAndScoreConverter)
      .get()
  ).data();
}

async function getFinalPredictionAndScoreFromDatabase(
  competitionPath: string,
  uid: string
) {
  return (
    await db
      .doc(`${competitionPath}/predictionsAndScores/${uid}`)
      .withConverter(finalPredictionAndScoreConverter)
      .get()
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
