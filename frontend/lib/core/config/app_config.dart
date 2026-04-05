import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // ─── Backend URL ───────────────────────────────────────────────────────────
  static String get baseUrl => 
      const String.fromEnvironment('BACKEND_URL').isNotEmpty 
      ? const String.fromEnvironment('BACKEND_URL')
      : dotenv.env['BACKEND_URL'] ?? 'http://localhost:8085/api';

  static const String tokenKey = 'jwt_token';
  static const String userKey = 'CACHED_USER';

  // ─── OpenRouter AI ────────────────────────────────────────────────────────
  // Priority: 1. Build Argument (--dart-define) 2. .env file 3. Empty string
  static String get openRouterApiKey => 
      const String.fromEnvironment('OPENROUTER_API_KEY').isNotEmpty
      ? const String.fromEnvironment('OPENROUTER_API_KEY')
      : dotenv.env['OPENROUTER_API_KEY'] ?? '';

  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';

  static String get aiModel => 
      const String.fromEnvironment('AI_MODEL').isNotEmpty
      ? const String.fromEnvironment('AI_MODEL')
      : dotenv.env['AI_MODEL'] ?? 'stepfun/step-3.5-flash:free';
}
