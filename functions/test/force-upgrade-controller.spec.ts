/* eslint-disable @typescript-eslint/ban-ts-comment */
import { expect } from "chai";
import functions from "firebase-functions-test";
import supertest from "supertest";


const test = functions(
  {
    projectId: "melodifestivalen-comp-test",
  },
  ".firebase/service-account-test.json"
);

import {app2, getMinimumVersionsOnCall} from "../src/index";

describe("Test force upgrade", () => {
  it.only("Returns recommendedMinimumVersion", async () => {
    // Given
    const request = supertest(app2);

    // When
    const actual = await request.get("/getMinimumVersions");
    const { ok, status, body } = actual

    // Then
    expect(ok).to.be.true;
    expect(status).to.be.greaterThanOrEqual(200);
    expect(body.requiredMinimumVersion).to.be.a("string");
    expect(body.recommendedMinimumVersion).to.be.a("string");
  });

  it.only("Returns recommendedMinimumVersionOnCall", async () => {
    // @ts-ignore - wrap doesn't support .onCall v2 yet https://github.com/firebase/firebase-functions-test/issues/163
    const wrapped = test.wrap(getMinimumVersionsOnCall);
    // @ts-ignore - wrap doesn't support .onCall v2 yet https://github.com/firebase/firebase-functions-test/issues/163
    const response = await wrapped();

    // Then
    expect(response.requiredMinimumVersion).to.be.a("string");
    expect(response.recommendedMinimumVersion).to.be.a("string");
  });
});
