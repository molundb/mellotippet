import { db } from "../src/config/firebase";
import { calculateTotalScores } from "../src/index";
import functions from "firebase-functions-test";
import { expect } from "chai";
import { User, userConverter } from "../src/models/user";

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

  it("should calculate score correctly for heat", async function () {
    // Given:
    // Create user
    const uid = "user1";
    const username = "testUser1";
    const totalScore = 0;
    await db
      .doc(`users/${uid}`)
      .set(Object.assign({}, new User(uid, username, totalScore)));

    // Create prediction
    await db.doc(`competitions/heat1/predictions/${uid}`).set({
      finalist1: 1,
      finalist2: 2,
      semifinalist1: 3,
      semifinalist2: 4,
      fifthPlace: 5,
    });

    // Create result
    const beforeSnap = test.firestore.makeDocumentSnapshot(
      {},
      "competitions/heat1"
    );

    const result = {
      result: {
        finalist1: 1,
        finalist2: 2,
        semifinalist1: 3,
        semifinalist2: 4,
        fifthPlace: 5,
      },
    };
    await db.doc("competitions/heat1").set(result);

    const afterSnap = test.firestore.makeDocumentSnapshot(
      result,
      "competitions/heat1"
    );

    const change = test.makeChange(beforeSnap, afterSnap);

    // Have to create an object because of issues with firebase-functions-test & firebase-functions/v2/firestore, see:
    // https://github.com/firebase/firebase-functions-test/issues/205
    // https://github.com/firebase/firebase-functions-test/issues/10
    const event = { data: change, params: { competition: "heat1" } };

    // When: Trigger calculate total scores
    const wrappedCalculateTotalScores = test.wrap(calculateTotalScores);
    await wrappedCalculateTotalScores(event);

    // Then: Check that scores are correct
    const userAfter = await db
      .doc(`users/${uid}`)
      .withConverter(userConverter)
      .get();

    const data = userAfter.data();

    expect(data?.totalScore).to.equal(14);
  });

  it("should calculate score correctly for semifinal", async function () {
    // Given:
    // Create user
    const uid = "user1";
    const username = "testUser1";
    const totalScore = 0;
    await db
      .doc(`users/${uid}`)
      .set(Object.assign({}, new User(uid, username, totalScore)));

    // Create prediction
    await db.doc(`competitions/semifinal/predictions/${uid}`).set({
      finalist1: 1,
      finalist2: 2,
    });

    // Create result
    const beforeSnap = test.firestore.makeDocumentSnapshot(
      {},
      "competitions/semifinal"
    );

    const result = {
      result: {
        finalist1: 1,
        finalist2: 2,
      },
    };
    await db.doc("competitions/semifinal").set(result);

    const afterSnap = test.firestore.makeDocumentSnapshot(
      result,
      "competitions/semifinal"
    );

    const change = test.makeChange(beforeSnap, afterSnap);

    // Have to create an object because of issues with firebase-functions-test & firebase-functions/v2/firestore, see:
    // https://github.com/firebase/firebase-functions-test/issues/205
    // https://github.com/firebase/firebase-functions-test/issues/10
    const event = { data: change, params: { competition: "semifinal" } };

    // When: Trigger calculate total scores
    const wrappedCalculateTotalScores = test.wrap(calculateTotalScores);
    await wrappedCalculateTotalScores(event);

    // Then: Check that scores are correct
    const userAfter = await db
      .doc(`users/${uid}`)
      .withConverter(userConverter)
      .get();

    const data = userAfter.data();

    expect(data?.totalScore).to.equal(6);
  });

  it("should calculate score correctly for final", async function () {
    // Given:
    // Create user
    const uid = "user1";
    const username = "testUser1";
    const totalScore = 0;
    await db
      .doc(`users/${uid}`)
      .set(Object.assign({}, new User(uid, username, totalScore)));

    // Create prediction
    await db.doc(`competitions/final/predictions/${uid}`).set({
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

    // Create result
    const beforeSnap = test.firestore.makeDocumentSnapshot(
      {},
      "competitions/final"
    );

    const result = {
      result: {
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
      },
    };
    await db.doc("competitions/semifinal").set(result);

    const afterSnap = test.firestore.makeDocumentSnapshot(
      result,
      "competitions/final"
    );

    const change = test.makeChange(beforeSnap, afterSnap);

    // Have to create an object because of issues with firebase-functions-test & firebase-functions/v2/firestore, see:
    // https://github.com/firebase/firebase-functions-test/issues/205
    // https://github.com/firebase/firebase-functions-test/issues/10
    const event = { data: change, params: { competition: "final" } };

    // When: Trigger calculate total scores
    const wrappedCalculateTotalScores = test.wrap(calculateTotalScores);
    await wrappedCalculateTotalScores(event);

    // Then: Check that scores are correct
    const userAfter = await db
      .doc(`users/${uid}`)
      .withConverter(userConverter)
      .get();

    const data = userAfter.data();

    expect(data?.totalScore).to.equal(40);
  });
});
