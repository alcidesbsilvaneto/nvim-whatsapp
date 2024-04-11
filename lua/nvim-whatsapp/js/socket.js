const { io } = require("socket.io-client");

const token = process.argv[2];

const socket = io("wss://api.podeorganizar.com.br");
socket.auth = { token };

console.log("connecting");
socket.connect();

socket.on("connect", () => {
  console.log("connected");
});

socket.onAny((event) => {
  console.log(event);
});
