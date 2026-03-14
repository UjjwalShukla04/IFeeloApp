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
const User = require("./models/User");

dotenv.config();

// Connect to Database
connectDB();

const memoryUsers = new Map();

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

app.post("/auth/register", async (req, res, next) => {
  if (mongoose.connection.readyState === 1) return next();

  const email = (req.body.email ?? req.body.username ?? "").toString().trim();
  const password = (req.body.password ?? "").toString();
  const name = (req.body.name ?? req.body.username ?? email).toString().trim();

  if (!email || !password) {
    return res.status(400).json({ message: "Email and password are required" });
  }

  if (memoryUsers.has(email)) {
    return res.status(400).json({ message: "User already exists" });
  }

  const id = new mongoose.Types.ObjectId().toString();
  const user = {
    _id: id,
    user_id: id,
    name,
    email,
    password,
    has_completed_assessment: false,
  };

  memoryUsers.set(email, user);

  return res.status(201).json({
    user_id: id,
    _id: id,
    name,
    email,
    has_completed_assessment: false,
    token: "mock-token",
    refreshToken: "mock-refresh-token",
  });
});

app.post("/auth/login", async (req, res, next) => {
  if (mongoose.connection.readyState === 1) return next();

  const email = (req.body.email ?? req.body.username ?? "").toString().trim();
  const password = (req.body.password ?? "").toString();

  const user = memoryUsers.get(email);
  if (!user || user.password !== password) {
    return res.status(401).json({ message: "Invalid email or password" });
  }

  return res.json({
    user_id: user._id,
    _id: user._id,
    name: user.name,
    email: user.email,
    has_completed_assessment: user.has_completed_assessment ?? false,
    token: "mock-token",
    refreshToken: "mock-refresh-token",
  });
});

app.use("/auth", authRoutes);

app.post("/assessment/submit", async (req, res) => {
  try {
    const { user_id, responses } = req.body;
    if (!user_id || !Array.isArray(responses)) {
      return res.status(400).json({
        status: "error",
        message: "Invalid payload. user_id and responses array are required.",
      });
    }

    if (mongoose.connection.readyState !== 1) {
      const user = [...memoryUsers.values()].find((u) => u._id === user_id);
      if (!user) {
        return res
          .status(404)
          .json({ status: "error", message: "User not found" });
      }

      user.has_completed_assessment = true;
      memoryUsers.set(user.email, user);

      return res.json({
        status: "success",
        user_id: user._id,
        has_completed_assessment: true,
      });
    }

    const updated = await User.findByIdAndUpdate(
      user_id,
      { $set: { has_completed_assessment: true } },
      { new: true },
    );

    if (!updated) {
      return res
        .status(404)
        .json({ status: "error", message: "User not found" });
    }

    return res.json({
      status: "success",
      user_id: updated._id,
      has_completed_assessment: true,
    });
  } catch (error) {
    return res.status(500).json({
      status: "error",
      message: "Internal server error processing assessment.",
    });
  }
});

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

const PORT = process.env.PORT || 3000;

httpServer.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
