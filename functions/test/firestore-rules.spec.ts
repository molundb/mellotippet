import * as firebase from "@firebase/testing";

const MY_PROJECT_ID = "melodifestivalen-comp-test";

describe("Tests for rules", () => {
  it.skip("Can't write", async () => {
    const db = firebase
      .initializeTestApp({ projectId: MY_PROJECT_ID })
      .firestore();

    const testDoc = db.collection("users").doc("user1");
    await firebase.assertFails(testDoc.set({ foo: "bar" }));
  });
});
