const User = require("../models/User");
const {
  generateToken,
  generateRefreshToken,
} = require("../utils/generateToken");

// @desc    Register a new user
// @route   POST /api/auth/register
// @access  Public
const registerUser = async (req, res) => {
  const { password } = req.body;
  const email = (req.body.email ?? req.body.username ?? "").toString().trim();
  const name = (req.body.name ?? req.body.username ?? email).toString().trim();

  try {
    const userExists = await User.findOne({ email });

    if (userExists) {
      return res.status(400).json({ message: "User already exists" });
    }

    // Pass password as 'passwordHash' field to match schema, but logic handles hashing
    const user = await User.create({
      name,
      email,
      passwordHash: password, // Will be hashed by pre-save hook
    });

    if (user) {
      res.status(201).json({
        user_id: user._id,
        _id: user._id,
        name: user.name,
        email: user.email,
        has_completed_assessment: user.has_completed_assessment ?? false,
        token: generateToken(user._id),
        refreshToken: generateRefreshToken(user._id),
      });
    } else {
      res.status(400).json({ message: "Invalid user data" });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Auth user & get token
// @route   POST /api/auth/login
// @access  Public
const authUser = async (req, res) => {
  const { password } = req.body;
  const email = (req.body.email ?? req.body.username ?? "").toString().trim();

  try {
    const user = await User.findOne({ email });

    if (user && (await user.matchPassword(password))) {
      res.json({
        user_id: user._id,
        _id: user._id,
        name: user.name,
        email: user.email,
        has_completed_assessment: user.has_completed_assessment ?? false,
        token: generateToken(user._id),
        refreshToken: generateRefreshToken(user._id),
      });
    } else {
      res.status(401).json({ message: "Invalid email or password" });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = { registerUser, authUser };
