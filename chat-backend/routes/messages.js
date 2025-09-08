const express = require('express');
const router = express.Router();
const Message = require('../models/Message');
const Chat = require('../models/Chat');
const { emitNewMessage } = require('../index'); // helper

router.post('/sendMessage', async (req, res) => {
  const { chatId, senderId, content, messageType='text', fileUrl='' } = req.body;
  try {
    const msg = await Message.create({ chatId, senderId, content, messageType, fileUrl });
    // update chat.lastMessage
    await Chat.findByIdAndUpdate(chatId, { lastMessage: msg._id });
    // emit
    emitNewMessage(msg);
    res.json({ success: true, message: msg });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// get messages for mobile
router.get('/get-messagesformobile/:chatId', async (req, res) => {
  const { chatId } = req.params;
  // pagination example: ?page=1&limit=50
  const page = parseInt(req.query.page || '1'), limit = parseInt(req.query.limit || '50');
  try {
    const messages = await Message.find({ chatId }).sort({ createdAt: 1 }).skip((page-1)*limit).limit(limit);
    res.json({ messages });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;