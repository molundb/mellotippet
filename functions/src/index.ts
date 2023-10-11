import { onRequest } from "firebase-functions/v2/https";
import express from "express";
import {
  addEntry,
  getAllEntries,
  updateEntry,
  deleteEntry,
} from "./entry-controller";

import { calculateTotalScores } from "./score-controller";

const app2 = express();

app2.get("/", (req, res) => res.status(200).send("Hey there!"));
app2.post("/entries", addEntry);
app2.get("/entries", getAllEntries);
app2.patch("/entries/:entryId", updateEntry);
app2.delete("/entries/:entryId", deleteEntry);

exports.app2 = onRequest(app2);

exports.calculateTotalScores = calculateTotalScores;
