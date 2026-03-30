import 'package:guideme/features/ai_chat/data/datasources/ai_chat_data_source.dart';
import 'package:guideme/features/ai_chat/domain/entities/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) =>
      AiChatState(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
      );
}

class AiChatNotifier extends StateNotifier<AiChatState> {
  AiChatNotifier(this._dataSource) : super(const AiChatState());

  final AiChatDataSource _dataSource;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      role: 'user',
      content: text.trim(),
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      clearError: true,
    );

    try {
      final reply = await _dataSource.sendMessages(state.messages);
      final assistantMessage = ChatMessage(
        role: 'assistant',
        content: reply,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e),
      );
    }
  }

  void clearChat() => state = const AiChatState();

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('401')) return 'Invalid API key. Check your OPENROUTER_API_KEY.';
    if (msg.contains('429')) return 'Rate limit reached. Wait a moment and try again.';
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'No internet connection.';
    }
    return 'Something went wrong. Please try again.';
  }
}
