const User = require('../models/User');
const Swipe = require('../models/Swipe');
const Match = require('../models/Match');

// @desc    Get users for feed (Geo-based, excluding swiped)
// @route   GET /api/feed
// @access  Private
const getFeed = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
    
    // Get list of IDs already swiped by current user
    const swipedIds = await Swipe.find({ swiperId: req.user._id }).distinct('swipedId');
    
    // Basic filter logic
    const filter = {
      _id: { $nin: [...swipedIds, req.user._id] }, // Exclude self and swiped
      // Gender preference logic (simplified)
      // gender: user.preferences.gender === 'everyone' ? { $exists: true } : user.preferences.gender,
      
      // Age Logic
      // dob: { $gte: ... } // Calculate dates based on minAge/maxAge
    };

    // Geo-spatial query if user has location
    if (user.location && user.location.coordinates) {
       filter.location = {
         $near: {
           $geometry: user.location,
           $maxDistance: (user.preferences.maxDistance || 50) * 1000 // KM to Meters
         }
       };
    }

    const feed = await User.find(filter).limit(20);
    
    res.json(feed);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Swipe on a user
// @route   POST /api/feed/swipe
// @access  Private
const swipeUser = async (req, res) => {
  const { swipedId, action } = req.body; // action: 'like', 'dislike', 'superlike'

  try {
    // 1. Record the swipe
    await Swipe.create({
      swiperId: req.user._id,
      swipedId,
      action
    });

    let isMatch = false;

    // 2. Check for Match if it's a 'like' or 'superlike'
    if (action === 'like' || action === 'superlike') {
      const otherSwipe = await Swipe.findOne({
        swiperId: swipedId,
        swipedId: req.user._id,
        action: { $in: ['like', 'superlike'] }
      });

      if (otherSwipe) {
        isMatch = true;
        // Create Match Record
        await Match.create({
          users: [req.user._id, swipedId]
        });
        
        // TODO: Send Push Notification to both users
      }
    }

    res.json({ success: true, isMatch });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = { getFeed, swipeUser };
