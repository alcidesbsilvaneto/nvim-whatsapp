const { io } = require("socket.io-client");

var running = true;

function killProcess() {
  running = false;
}

process.on("SIGTERM", killProcess);
process.on("SIGINT", killProcess);
process.on("uncaughtException", function (e) {
  console.log("[uncaughtException] app will be terminated: ", e.stack);
  killProcess();
});

function run() {
  setTimeout(function () {
    if (running) run();
  }, 10);
}

run();

const token = process.argv[2];

const socket = io("wss://api.podeorganizar.com.br");
socket.auth = { token };

socket.connect();

socket.on("connect", () => {
  console.log("connected");
});

socket.onAny((event) => {
  console.log(event);
});
