# GuideMe — Frontend

Flutter mobile app for the GuideMe tourist guide platform.

## Requirements

- Flutter 3.x (Dart SDK >= 3.2.3)
- Android Studio / VS Code with Flutter extension
- Backend running on port 8085 (see `/backend/README.md`)

## Setup

```bash
flutter pub get
flutter run
```

> Make sure the backend is running before launching the app.

## Connecting to the Backend

The base URL is configured in one place:

**`lib/core/config/app_config.dart`**

```dart
static const String baseUrl = 'http://localhost:8085/api';
```

| Environment | URL to use |
|---|---|
| Flutter Web (dev) | `http://localhost:8085/api` |
| Android Emulator | `http://10.0.2.2:8085/api` |
| Physical device | `http://<your-machine-ip>:8085/api` |

Change the `baseUrl` value to match your environment.

## Project Structure

```
lib/
├── main.dart                    # App entry point — ProviderScope only
├── core/
│   ├── config/app_config.dart   # Base URL, token key
│   ├── network/app_network.dart # Dio setup + JWT interceptor
│   └── theme/app_theme.dart     # Light & dark theme
├── features/
│   ├── auth/                    # Login, Register, Splash
│   ├── guides/                  # Guide list, search, details
│   ├── booking/                 # Create booking, my bookings
│   ├── guide_space/             # Guide dashboard, incoming bookings
│   ├── payment/                 # Payment page
│   ├── reviews/                 # Leave a review
│   ├── home/                    # Home screen
│   └── profile/                 # User profile
├── router/
│   ├── app_router.dart          # GoRouter route definitions
│   ├── guards.dart              # Auth guard (redirects to login if not logged in)
│   └── routes.dart              # Route name constants
└── shared/
    └── widgets/                 # Reusable UI components
```

### Feature structure

Each feature follows Clean Architecture with three layers:

```
features/<name>/
├── data/
│   ├── datasources/   # API calls (Dio)
│   └── repositories/  # Repository implementations
├── domain/
│   ├── entities/      # Pure Dart models (no Flutter dependency)
│   └── repositories/  # Repository interfaces (contracts)
├── presentation/
│   ├── pages/         # Full screens
│   └── widgets/       # Feature-specific UI components
└── providers/
    ├── <name>_notifier.dart   # StateNotifier (state + logic)
    └── <name>_providers.dart  # Riverpod provider declarations
```

## State Management

The app uses **Riverpod** exclusively (`flutter_riverpod`).

| Provider file | Provider | Purpose |
|---|---|---|
| `auth/providers/auth_providers.dart` | `authNotifierProvider` | Login, register, logout. Also exports `dioProvider` |
| `guides/providers/guides_providers.dart` | `guidesNotifierProvider` | Fetch & search guides |
| `booking/providers/booking_providers.dart` | `bookingNotifierProvider` | Create & list bookings |
| `guide_space/providers/guide_dashboard_providers.dart` | `guideDashboardNotifierProvider` | Guide dashboard & incoming bookings |

### Adding a new feature

1. Create `features/<name>/domain/repositories/<name>_repository.dart` (interface)
2. Create `features/<name>/data/repositories/<name>_repository_impl.dart`
3. Create `features/<name>/providers/<name>_notifier.dart` (StateNotifier + State class)
4. Create `features/<name>/providers/<name>_providers.dart` (wire up using `dioProvider` from `auth_providers.dart`)
5. Use `ref.watch(...)` / `ref.read(...).notifier` in your pages (extend `ConsumerWidget` or `ConsumerStatefulWidget`)

## Auth Flow

1. App starts → `SplashScreen` checks for a stored JWT token
2. No token → redirects to `LoginScreen`
3. On login → JWT stored in `SharedPreferences`, user cached locally
4. All API requests → `_AuthInterceptor` in `app_network.dart` automatically adds `Authorization: Bearer <token>`
5. On 401 response → token is cleared, user redirected to login

## Key Dependencies

| Package | Purpose |
|---|---|
| `flutter_riverpod` | State management |
| `go_router` | Declarative navigation |
| `dio` | HTTP client |
| `shared_preferences` | JWT token storage |
| `freezed` | Immutable data classes (auth feature) |
| `dartz` | Functional error handling (`Either`) in auth |
