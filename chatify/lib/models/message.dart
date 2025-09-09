class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String? messageType;
  final String? fileUrl;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    this.messageType,
    this.fileUrl,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["_id"] ?? "",
      chatId: json["chatId"] ?? "",
      senderId: json["senderId"] ?? "",
      content: json["content"] ?? "",
      messageType: json["messageType"],
      fileUrl: json["fileUrl"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    );
  }
}
