class ChatMessage {
  final String role;
  final String content;
  final DateTime time;

  ChatMessage({required this.role, required this.content, required this.time});

  Map<String, dynamic> toMap() {
    return {'role': role, 'content': content};
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      role: map['role'],
      content: map['content'],
      time: DateTime.now(), 
    );
  }
}
