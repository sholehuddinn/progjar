// import express from "express";
// import cors from "cors";
// import { AccessToken } from "livekit-server-sdk";
// const app = express();
// app.use(cors());

// const apikey ="APIRTctLTWJDKWt";
// const apiSecret ="iF3IoEaMihZNzd6FB8L6XDzxuiO2BUSihPLdGh02IhJ";

// const PORT = 3000;

// // Route
// app.get("/", (req, res) => {
//   res.send("Hello from Express!");
// });

// app.get("/token", (req, res) => {

//   const identity = req.query.user ?? `user-test`

//   const token = new AccessToken(apikey, apiSecret, {identity,});

//   token.addGrant({
//     roomJoin: true,
//     room : "voice-room",
//     canPublish: true,
//     canSubscribe: true,
//   })

//   res.send(token.toJwt())
// });

// // Start server
// app.listen(PORT, () => {
//   console.log(`Server running at http://localhost:${PORT}`);
// });


// server.js
import express from 'express';
import { AccessToken } from 'livekit-server-sdk';
import { cors } from 'cors';

const createToken = async () => {
  // If this room doesn't exist, it'll be automatically created when the first
  // participant joins
  const roomName = 'quickstart-room';
  // Identifier to be used for participant.
  // It's available as LocalParticipant.identity with livekit-client SDK
  const participantName = 'quickstart-username'+ Math.floor(Math.random() * 10000);

  const apikey ="APIRTctLTWJDKWt";
  const apiSecret ="iF3IoEaMihZNzd6FB8L6XDzxuiO2BUSihPLdGh02IhJ";

  const at = new AccessToken(apikey, apiSecret, {
    identity: participantName,
    // Token to expire after 10 minutes
    ttl: '10m',
  });
  at.addGrant({ roomJoin: true, room: roomName, canPublish:true, canSubscribe: true, });

  return await at.toJwt();
};

const app = express();
const port = 5173;

app.use(cors())

app.get('/getToken', async (req, res) => {
  res.send(await createToken());
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});