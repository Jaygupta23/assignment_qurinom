class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final String fileUrl;
  final DateTime createdAt;
  Message({
    required this.id, required this.chatId, required this.senderId,
    required this.content, required this.messageType, required this.fileUrl, required this.createdAt
  });
  factory Message.fromJson(Map<String,dynamic> json) => Message(
      id: json['_id'] ?? json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      content: json['content'],
      messageType: json['messageType'] ?? 'text',
      fileUrl: json['fileUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String())
  );
}
