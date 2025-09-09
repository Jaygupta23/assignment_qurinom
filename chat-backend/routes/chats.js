const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const Chat = require('../models/Chat');

router.get('/user-chats/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const chats = await Chat.find({
      participants: new mongoose.Types.ObjectId(userId) // ensure ObjectId
    })
      .populate('lastMessage')
      .populate('participants', 'name email profile role isOnline lastSeen') // populate full user details
      .sort({ updatedAt: -1 }); // latest chats first

    res.json({ chats });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;