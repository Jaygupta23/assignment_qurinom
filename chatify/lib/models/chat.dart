class Chat {
  final String id;
  final List participants;
  final Map<String, dynamic>? lastMessage;

  Chat({
    required this.id,
    required this.participants,
    this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'] ?? json['id'] ?? '',
      participants: List.from(json['participants'] ?? []),
      lastMessage: json['lastMessage'] != null
          ? Map<String, dynamic>.from(json['lastMessage'])
          : null,
    );
  }
}
