import 'package:dio/dio.dart';
import 'package:guideme/core/config/app_config.dart';
import 'package:guideme/features/ai_chat/domain/entities/chat_message.dart';

class AiChatDataSource {
  late final Dio _dio;

  AiChatDataSource() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.openRouterBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConfig.openRouterApiKey}',
        'HTTP-Referer': 'http://localhost:3000',
        'X-Title': 'GuideMe Tourist App',
      },
    ));
  }

  Future<String> sendMessages(List<ChatMessage> history) async {
    final messages = [
      {
        'role': 'system',
        'content':
            'You are GuideMe AI, a knowledgeable travel assistant specializing in Moroccan cities and tourist experiences. '
                'Help tourists discover cities, neighbourhoods, attractions, culture, food, transport and local tips. '
                'Be concise, friendly and practical. Prices are in MAD (Moroccan Dirham). '
                'When relevant, mention that GuideMe connects tourists with certified local guides who can show them around personally.',
      },
      ...history.where((m) => !m.role.contains('system')).map((m) => m.toJson()),
    ];

    final response = await _dio.post('/chat/completions', data: {
      'model': AppConfig.aiModel,
      'messages': messages,
      'max_tokens': 1024,
    });

    return response.data['choices'][0]['message']['content'] as String;
  }
}
