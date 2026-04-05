import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Émulateur Android  → 10.0.2.2:8081
  // Appareil physique  → IP de ta machine sur le réseau local (ex: 192.168.1.X:8081)
  // Flutter Web (dev)  → localhost:8081
  // Loads from frontend/.env
  static String get baseUrl => dotenv.env['BACKEND_URL'] ?? 'http://localhost:8080/api';
  static const String tokenKey = 'jwt_token';
  static const String userKey = 'CACHED_USER';

  // OpenRouter AI — loaded from frontend/.env
  // Get a free key at https://openrouter.ai/keys
  static String get openRouterApiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static String get aiModel => dotenv.env['AI_MODEL'] ?? 'stepfun/step-3.5-flash:free';
}
