class ChatMessage {
  final String role; // 'user' | 'assistant' | 'system'
  final String content;
  final DateTime timestamp;

  const ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';

  Map<String, String> toJson() => {'role': role, 'content': content};
}
