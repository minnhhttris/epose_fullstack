require("dotenv").config();
const express = require("express");
const http = require("http"); // Sử dụng http để tạo server
const socketIo = require("socket.io"); // Sử dụng socket.io cho WebSocket
const cookieParser = require("cookie-parser");
const cors = require("cors");
const router = require("./src/routers");

const app = express();

// Tạo server HTTP từ ứng dụng Express
const server = http.createServer(app);

// Tạo instance của Socket.IO và gắn nó với server HTTP
const io = socketIo(server, {
  cors: {
    origin: "*", // Điều chỉnh origin nếu cần
    methods: ["GET", "POST"],
  },
});

app.use(cors());
app.use(express.json());
app.use(cookieParser());

// Định nghĩa router
app.use("/api", router);

// Thiết lập kết nối WebSocket
io.on("connection", (socket) => {
  console.log("A user connected");

  // Sự kiện bài viết mới
  socket.on("newPosts", (data) => {
    console.log("New post received:", data);
    io.emit("updatePosts", data);
  });

  // Sự kiện bình luận mới
  socket.on("newComment", (data) => {
    console.log("New comment received:", data);
    io.emit("updateComments", data); 
  });

  // Sự kiện yêu thích
  socket.on("toggleFavorite", (data) => {
    console.log("Favorite toggled:", data);
    io.emit("updateFavorites", data); 
  });


  socket.on("sendMessage", (data) => {
    console.log("New message sent:", data);
    io.emit("updateMessage", data); 
  });

  socket.on("disconnect", () => {
    console.log("User disconnected");
  });
});

// Test API
app.get("/", (req, res) => {
  res.json({
    message: "API is working",
  });
});

const PORT = process.env.PORT || 4000;

// Sử dụng server chung cho cả HTTP và WebSocket
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
