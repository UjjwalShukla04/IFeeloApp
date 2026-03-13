const mongoose = require('mongoose');

const matchSchema = new mongoose.Schema(
  {
    users: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
      },
    ],
    lastMessage: {
      text: String,
      sender: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
      },
      timestamp: Date,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Match', matchSchema);
