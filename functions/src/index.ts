import { onRequest } from "firebase-functions/v2/https";
import express from "express";
import {
  addEntry,
  getAllEntries,
  updateEntry,
  deleteEntry,
} from "./entry-controller";

import { calculateScores } from "./score-controller";

const expressApp = express();

expressApp.get("/", (req, res) => res.status(200).send("Hey there!"));
expressApp.post("/entries", addEntry);
expressApp.get("/entries", getAllEntries);
expressApp.patch("/entries/:entryId", updateEntry);
expressApp.delete("/entries/:entryId", deleteEntry);

const app = onRequest(expressApp);

export { app, calculateScores };
