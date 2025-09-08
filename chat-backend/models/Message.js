const mongoose = require('mongoose');
const messageSchema = new mongoose.Schema({
  chatId: { type: mongoose.Schema.Types.ObjectId, ref: 'Chat' },
  senderId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  content: String,
  messageType: { type: String, default: 'text' },
  fileUrl: String
}, { timestamps: true });
module.exports = mongoose.model('Message', messageSchema);
