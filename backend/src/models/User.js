const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },
    passwordHash: {
      type: String,
      required: true,
    },
    dob: {
      type: Date,
    },
    gender: {
      type: String,
      enum: ['male', 'female', 'other'],
    },
    bio: {
      type: String,
      maxlength: 500,
    },
    photos: [
      {
        type: String, // URL
      },
    ],
    interests: [
      {
        type: String,
      },
    ],
    jobTitle: String,
    company: String,
    
    // Geospatial Data
    location: {
      type: {
        type: String,
        enum: ['Point'],
        default: 'Point',
      },
      coordinates: {
        type: [Number], // [Longitude, Latitude]
        index: '2dsphere',
      },
    },

    // Preferences for Matching
    preferences: {
      gender: {
        type: String,
        enum: ['male', 'female', 'everyone'],
        default: 'everyone',
      },
      minAge: {
        type: Number,
        default: 18,
      },
      maxAge: {
        type: Number,
        default: 50,
      },
      maxDistance: {
        type: Number, // In Kilometers
        default: 50,
      },
    },
    
    status: {
      isOnline: {
        type: Boolean,
        default: false,
      },
      lastSeen: {
        type: Date,
        default: Date.now,
      },
    },
    fcmToken: String, // For Push Notifications
    has_completed_assessment: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

// Encrypt password before saving
userSchema.pre('save', async function (next) {
  if (!this.isModified('passwordHash')) {
    next();
  }
  const salt = await bcrypt.genSalt(10);
  this.passwordHash = await bcrypt.hash(this.passwordHash, salt);
});

// Match user entered password to hashed password in database
userSchema.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.passwordHash);
};

module.exports = mongoose.model('User', userSchema);
