import {onRequest} from "firebase-functions/v2/https";
import express from "express";
import {addEntry} from "./entryController";

const app2 = express();

app2.get("/", (req, res) => res.status(200).send("Hey there!"));
app2.post("/entries", addEntry);

exports.app2 = onRequest(app2);
