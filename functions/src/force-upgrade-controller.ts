import { Request, Response } from "express";
import { onCall } from "firebase-functions/v2/https";

const getMinimumVersions = (req: Request, res: Response) => {
  res.json({
    requiredMinimumVersion: "4.0.0",
    recommendedMinimumVersion: "4.0.0",
  });
};

const getMinimumVersionsOnCall = onCall(() => {
  return {
    requiredMinimumVersion: "4.0.0",
    recommendedMinimumVersion: "4.0.0",
  };
});

export { getMinimumVersions, getMinimumVersionsOnCall };
