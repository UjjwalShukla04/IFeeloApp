const express = require('express');
const { getFeed, swipeUser } = require('../controllers/feedController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.get('/', protect, getFeed);
router.post('/swipe', protect, swipeUser);

module.exports = router;
