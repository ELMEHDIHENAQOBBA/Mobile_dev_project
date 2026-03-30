import 'package:guideme/features/ai_chat/data/datasources/ai_chat_data_source.dart';
import 'package:guideme/features/ai_chat/providers/ai_chat_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiChatDataSourceProvider = Provider<AiChatDataSource>(
  (_) => AiChatDataSource(),
);

final aiChatNotifierProvider =
    StateNotifierProvider<AiChatNotifier, AiChatState>(
  (ref) => AiChatNotifier(ref.watch(aiChatDataSourceProvider)),
);
