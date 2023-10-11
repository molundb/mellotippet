import { Response } from "express";
import { db } from "./config/firebase";

type EntryType = {
  title: string;
  text: string;
  coverImageUrl: string;
};

type Request = {
  body: EntryType;
  params: { entryId: string };
};

const addEntry = async (req: Request, res: Response) => {
  const { title, text } = req.body;

  try {
    const entry = db.collection("entries").doc();
    const entryObject = {
      id: entry.id,
      title,
      text,
    };

    entry.set(entryObject);

    res.status(200).send({
      status: "success",
      message: "entry added successfully",
      data: entryObject,
    });
  } catch (error) {
    res.status(500).json("There was an error posting your entry.");
  }
};

const getAllEntries = async (req: Request, res: Response) => {
  try {
    const allEntries: EntryType[] = [];

    (await db.collection("entries").get()).forEach((doc: any) =>
      allEntries.push(doc.data())
    );
    return res.status(200).json(allEntries);
  } catch (error) {
    return res.status(500).json("There was an error fetching all entries.");
  }
};

const updateEntry = async (req: Request, res: Response) => {
  const {
    body: { text, title },
    params: { entryId },
  } = req;

  try {
    const entry = db.collection("entries").doc(entryId);
    const currentData = (await entry.get()).data() || {};
    const entryObject = {
      title: title || currentData.title,
      text: text || currentData.text,
    };

    await entry.set(entryObject).catch((error) => {
      return res.status(400).json({
        status: "error",
        message: error.message,
      });
    });

    return res.status(200).json({
      status: "success",
      message: "entry updated successfully",
      data: entryObject,
    });
  } catch (error) {
    return res
      .status(500)
      .json(`There was an error updating the entry: ${error}`);
  }
};

const deleteEntry = async (req: Request, res: Response) => {
  const { entryId } = req.params;

  try {
    const entry = db.collection("entries").doc(entryId);

    await entry.delete().catch((error) => {
      return res.status(400).json({
        status: "error",
        message: error.message,
      });
    });

    return res.status(200).json({
      status: "success",
      message: "entry deleted successfully",
    });
  } catch (error) {
    return res.status(500).json("We found an error deleting an entry");
  }
};

export { addEntry, getAllEntries, updateEntry, deleteEntry };
