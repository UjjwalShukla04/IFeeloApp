const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const { createServer } = require("http");
const { Server } = require("socket.io");
const mongoose = require("mongoose");

const connectDB = require("./config/db");
const authRoutes = require("./routes/authRoutes");
const feedRoutes = require("./routes/feedRoutes");
const { protect } = require("./middleware/authMiddleware");

dotenv.config();

// Connect to Database
connectDB();

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: "*", // Allow all for dev, restrict in production
    methods: ["GET", "POST"],
  },
});

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

app.get("/", (req, res) => {
  const dbConnected = mongoose.connection.readyState === 1;
  res.send(
    `Dating App API is running... DB: ${dbConnected ? "connected" : "disabled"}`,
  );
});

app.get("/api/health", (req, res) => {
  const dbConnected = mongoose.connection.readyState === 1;
  res.json({ status: "ok", dbConnected });
});

app.use("/api", (req, res, next) => {
  if (req.path === "/health") return next();
  if (mongoose.connection.readyState === 1) return next();
  return res.status(503).json({
    message: "Database is not connected. Set MONGO_URI to enable API routes.",
  });
});

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/feed", feedRoutes);

// Socket.io Logic
io.on("connection", (socket) => {
  console.log("New client connected:", socket.id);

  // Join a personal room for notifications
  socket.on("join_user", (userId) => {
    socket.join(userId);
    console.log(`User ${userId} joined their personal room`);
  });

  // Join a chat room
  socket.on("join_chat", (matchId) => {
    socket.join(matchId);
    console.log(`Socket ${socket.id} joined chat: ${matchId}`);
  });

  // Send Message
  socket.on("send_message", (data) => {
    // data: { matchId, senderId, text }
    // Save to DB (Controller logic usually)
    // Emit to room
    io.to(data.matchId).emit("receive_message", data);

    // Notify other user if not in chat (Push Notif logic here)
  });

  socket.on("typing", (data) => {
    socket.to(data.matchId).emit("user_typing", data);
  });

  socket.on("disconnect", () => {
    console.log("Client disconnected");
  });
});

const PORT = process.env.PORT || 5000;

httpServer.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
