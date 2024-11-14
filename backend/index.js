require("dotenv").config();
const express = require("express");
const http = require("http"); 
const socketIo = require("socket.io"); 
const cookieParser = require("cookie-parser");
const cors = require("cors");
const router = require("./src/routers");
const prisma = require("./src/config/prismaClient");

process.env.NODE_CONFIG_DIR = __dirname + "/src/config";

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

app.use((req, res, next) => {
  req.io = io;
  next();
});

// Định nghĩa router
app.use("/api", router);

// Thiết lập kết nối WebSocket
io.use((socket, next) => {
  console.log("Socket connected:", socket.id);
  const token = socket.handshake.auth.token;
  if (!token) {
    return next(new Error("Authentication token is required."));
  }
  try {
    const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
    socket.idUser = decoded.idUser; 
    console.log("User connected:", decoded.idUser);
    next();
  } catch (err) {
    console.log("Error verifying token:", err);
    return next(new Error("Invalid token."));
  }
});

io.on("connection", (socket) => {
  console.log("New client connected:", socket.id);

  socket.on("join", (idUser) => {
    socket.join(idUser);
  });


  socket.on("sendMessage", async (messageData) => {
    let { senderId, senderType, receiverId, receiverType, message } =
      messageData;

    try {
      // Lưu tin nhắn vào database với Prisma
      const newMessage = await prisma.message.create({
        data: {
          message,
          senderId,
          senderType,
          receiverId,
          receiverType,
          sendAt: new Date(),
        },
      });

      // Gửi tin nhắn tới người nhận và người gửi
      io.to(receiverId).emit("receiveMessage", {
        senderId,
        receiverId,
        message,
        senderType,
        receiverType,
        createdAt: newMessage.sendAt,
      });

      io.to(senderId).emit("receiveMessage", {
        senderId,
        receiverId,
        message,
        senderType,
        receiverType,
        createdAt: newMessage.sendAt,
      });
    } catch (error) {
      console.error("Error saving message:", error);
    }
  });


  //Sự kiện bài viết mới
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

  socket.on("disconnect", () => {
    console.log("Client disconnected:", socket.id);
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
