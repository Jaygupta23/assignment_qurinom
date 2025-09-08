class Chat {
  final String id;
  final List participants;
  final Map? lastMessage;
  Chat({required this.id, required this.participants, this.lastMessage});
  factory Chat.fromJson(Map<String,dynamic> json) => Chat(
      id: json['_id'] ?? json['id'],
      participants: json['participants'] ?? [],
      lastMessage: json['lastMessage']
  );
}
