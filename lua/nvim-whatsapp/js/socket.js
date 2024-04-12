const { io } = require("socket.io-client");

const token = process.argv[2];

const socket = io("wss://api.podeorganizar.com.br");
socket.auth = { token };

console.log("connecting");
socket.connect();

socket.on("connect", () => {
  console.log("connected");
});

socket.onAny((event, payload) => {
  if (payload?.ticketId) {
    console.log(`ticket:${payload.ticketId}:updated`);
  } else if (event === "ticket:updated") {
    console.log(event);
  } else {
    console.log("nothing");
  }
});
