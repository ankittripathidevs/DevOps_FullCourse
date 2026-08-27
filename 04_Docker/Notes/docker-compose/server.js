const express = require("express");
const app = express();
const path = require("path");
const MongoClient = require("mongodb").MongoClient;

const PORT = 5050;

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static("public"));

const MONGO_URL = "mongodb://admin:qwerty@localhost:27017";

// GET all users
app.get("/getUsers", async (req, res) => {
  const client = new MongoClient(MONGO_URL);
  await client.connect();

  const db = client.db("ankit-db");
  const users = await db.collection("users").find({}).toArray();

  await client.close();
  res.send(users);
});

// POST new user
app.post("/addUser", async (req, res) => {
  const userObj = req.body;
  console.log("Received:", userObj);

  const client = new MongoClient(MONGO_URL);
  await client.connect();

  const db = client.db("ankit-db");
  const result = await db.collection("users").insertOne(userObj);

  await client.close();
  res.send({
    success: true,
    message: "User inserted successfully",
    id: result.insertedId,
    email: userObj.email,
    username: userObj.username,
  });
});

app.listen(PORT, () => {
  console.log(`server running on port ${PORT}`);
});