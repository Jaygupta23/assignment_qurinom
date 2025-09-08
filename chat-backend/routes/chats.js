const express = require('express');
const router = express.Router();
const Chat = require('../models/Chat');

router.get('/user-chats/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const chats = await Chat.find({ participants: userId }).populate('lastMessage').populate('participants', 'name email');
    res.json({ chats });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;