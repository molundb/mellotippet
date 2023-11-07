import "dotenv/config";
import { onRequest } from "firebase-functions/v2/https";
import express from "express";
import {
  addEntry,
  getAllEntries,
  updateEntry,
  deleteEntry,
} from "./entry-controller";

import { calculateScores } from "./score-controller";
import {
  getMinimumVersions,
  getMinimumVersionsOnCall,
} from "./force-upgrade-controller";

const app = express();

app.get("/", (req, res) => res.status(200).send("Hey there!"));
app.post("/entries", addEntry);
app.get("/entries", getAllEntries);
app.patch("/entries/:entryId", updateEntry);
app.delete("/entries/:entryId", deleteEntry);
app.get("/getMinimumVersions", getMinimumVersions);

const app2 = onRequest(app);

export { app2, calculateScores, getMinimumVersionsOnCall };
