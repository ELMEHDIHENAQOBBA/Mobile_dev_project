class AppConfig {
  // Émulateur Android  → 10.0.2.2:8081
  // Appareil physique  → IP de ta machine sur le réseau local (ex: 192.168.1.X:8081)
  // Flutter Web (dev)  → localhost:8081
  static const String baseUrl = 'http://localhost:8085/api';
  static const String tokenKey = 'jwt_token';
  static const String userKey = 'CACHED_USER';
}
