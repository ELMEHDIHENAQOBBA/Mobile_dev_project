# GuideMe — Tourist Guide Platform

A full-stack mobile app that connects tourists with local independent guides in Morocco. Tourists search, book and pay guides; guides manage bookings and track earnings. Includes an AI travel assistant powered by OpenRouter.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [1. Clone](#1-clone)
  - [2. Database](#2-database)
  - [3. Backend environment](#3-backend-environment)
  - [4. Run the backend](#4-run-the-backend)
  - [5. Frontend environment](#5-frontend-environment)
  - [6. Run the frontend](#6-run-the-frontend)
- [Environment Variables](#environment-variables)
- [API Reference](#api-reference)
- [App Flows](#app-flows)
- [Troubleshooting](#troubleshooting)

---

## Features

| Feature | Description |
|---|---|
| Guide search | Filter guides by city, language, budget, transport availability |
| Booking | Book a guide with date, duration and group size |
| Payments | Simulate payment for confirmed bookings |
| Reviews | Leave a star review after a completed tour |
| Guide dashboard | Guides view and manage bookings, track earnings |
| AI Assistant | Chat with an AI about Moroccan cities, attractions and travel tips |

---

## Tech Stack

| Layer | Technology | Version |
|---|---|---|
| Mobile | Flutter (Dart) | 3.x |
| State Management | Riverpod (StateNotifier) | 2.5 |
| Navigation | GoRouter | 13.x |
| HTTP Client | Dio | 5.4 |
| Markdown rendering | flutter_markdown | 0.7 |
| Env loading | flutter_dotenv | 5.1 |
| Backend | Spring Boot (Java 17) | 3.2.5 |
| Database | MySQL | 8.0 |
| Auth | JWT (Bearer token) | 24h expiry |
| AI | OpenRouter API | `stepfun/step-3.5-flash:free` |

---

## Project Structure

```
Mobile_dev_project/
├── README.md
├── SETUP.md                        # Quick setup reference
├── .gitignore
├── backend/                        # Spring Boot REST API
│   ├── .env.example
│   ├── README.md
│   └── src/main/java/com/touristguide/
│       ├── config/                 # Security, CORS, DataSeeder
│       ├── features/
│       │   ├── auth/               # Register, login, JWT
│       │   ├── guides/             # Guide listing, search, dashboard
│       │   ├── booking/            # Booking lifecycle
│       │   ├── payment/            # Payment simulation
│       │   └── reviews/            # Post-tour reviews
│       └── security/               # JWT filter & service
└── frontend/                       # Flutter app
    ├── .env.example
    └── lib/
        ├── core/                   # Config, network, theme
        ├── features/
        │   ├── auth/               # Login, register, splash
        │   ├── guides/             # Guide list, search, details
        │   ├── booking/            # Create booking, my bookings
        │   ├── payment/            # Payment page
        │   ├── reviews/            # Review page
        │   ├── guide_space/        # Guide dashboard
        │   ├── profile/            # User profile
        │   └── ai_chat/            # AI travel assistant
        └── router/                 # GoRouter routes & guards
```

---

## Prerequisites

Install all of these before starting:

| Tool | Version | Download |
|---|---|---|
| Java JDK | 17+ | https://adoptium.net |
| Maven | 3.8+ | https://maven.apache.org/download.cgi |
| MySQL | 8.0+ | https://dev.mysql.com/downloads/installer |
| Flutter | 3.x | https://docs.flutter.dev/get-started/install/windows |
| Git | any | https://git-scm.com |

Verify:
```powershell
java -version
mvn -version
mysql --version
flutter --version
```

---

## Installation

### 1. Clone

```powershell
git clone <your-repo-url>
cd Mobile_dev_project
```

### 2. Database

**Find and start your MySQL service** (service name varies by MySQL version):

```powershell
# Find your service name (e.g. MySQL80, MySQL95)
Get-Service -Name "MySQL*"

# Start it (run PowerShell as Administrator)
net start MySQL80
```

**Create the database:**

```powershell
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS tourist_guide_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

> Hibernate creates all tables automatically on first backend startup — no SQL scripts needed.

### 3. Backend environment

```powershell
copy backend\.env.example backend\.env
```

Edit `backend\.env`:

```env
DB_URL=jdbc:mysql://localhost:3306/tourist_guide_db?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
DB_USERNAME=root
DB_PASSWORD=your_mysql_password
JWT_SECRET=any_random_string_at_least_32_characters
```

### 4. Run the backend

```powershell
cd backend
$env:DB_PASSWORD="your_mysql_password"
$env:DB_USERNAME="root"
mvn spring-boot:run
```

Wait for:
```
Started TouristGuideApplication in X.XXX seconds
```

API is running at `http://localhost:8085/api`. Sample guides are seeded automatically on first run.

### 5. Frontend environment

```powershell
copy frontend\.env.example frontend\.env
```

Edit `frontend\.env`:

```env
OPENROUTER_API_KEY=sk-or-your-key-here
AI_MODEL=stepfun/step-3.5-flash:free
```

Get a free OpenRouter key at https://openrouter.ai/keys.
Browse other free models at https://openrouter.ai/models?q=free.

> The app works without the key — only the AI tab will fail.

Also check `frontend/lib/core/config/app_config.dart` and set the correct `baseUrl` for your platform:

| Platform | `baseUrl` |
|---|---|
| Chrome / Web | `http://localhost:8085/api` |
| Android Emulator | `http://10.0.2.2:8085/api` |
| Physical device | `http://YOUR_PC_IP:8085/api` |

Find your PC IP: `ipconfig | findstr "IPv4"`

### 6. Run the frontend

```powershell
cd frontend
flutter pub get
flutter run -d chrome --web-port 3000
```

App opens at `http://localhost:3000`.

---

## Environment Variables

### Backend — `backend/.env`

| Variable | Required | Default | Description |
|---|---|---|---|
| `DB_URL` | No | `jdbc:mysql://localhost:3306/tourist_guide_db?...` | Full JDBC URL |
| `DB_USERNAME` | No | `root` | MySQL username |
| `DB_PASSWORD` | **Yes** | — | MySQL password |
| `JWT_SECRET` | No | built-in default | JWT signing key |

### Frontend — `frontend/.env`

| Variable | Required | Default | Description |
|---|---|---|---|
| `OPENROUTER_API_KEY` | No | `""` | OpenRouter API key for AI chat |
| `AI_MODEL` | No | `stepfun/step-3.5-flash:free` | LLM model to use |

---

## API Reference

Base URL: `http://localhost:8085/api`

All protected endpoints require:
```
Authorization: Bearer <jwt_token>
```

### Response format

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

### Auth

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/auth/register` | No | Register as tourist |
| POST | `/auth/register/guide` | No | Register as guide |
| POST | `/auth/login` | No | Login → returns JWT + user |

**Register tourist body:**
```json
{ "name": "John Doe", "email": "john@example.com", "password": "password123" }
```

**Register guide body:**
```json
{
  "name": "Ahmed Alami", "email": "ahmed@example.com", "password": "password123",
  "city": "Marrakech", "bio": "5 years local experience",
  "languages": ["Arabic", "French", "English"],
  "priceMin": 200, "priceMax": 500, "transportAvailable": true
}
```

**Login response `data`:**
```json
{ "token": "eyJ...", "user": { "id": 1, "name": "John Doe", "role": "TOURIST" } }
```

### Guides

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/guides` | Yes | List all guides (filterable) |
| GET | `/guides/{id}` | Yes | Guide details |
| GET | `/guide/dashboard` | Guide only | Stats, bookings & earnings |

**Guide filter query params:** `city`, `language`, `minBudget`, `maxBudget`, `transportAvailable`, `minRating`

Example: `GET /guides?city=Marrakech&language=English&maxBudget=400`

### Bookings

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/bookings` | Tourist | Create a booking |
| GET | `/bookings/me` | Tourist | My bookings |
| GET | `/bookings/incoming` | Guide | Incoming bookings |
| PATCH | `/bookings/{id}/status` | Guide | Update status |

**Status flow:** `PENDING` → `CONFIRMED` → `COMPLETED` / `CANCELLED`

**Create booking body:**
```json
{
  "guideId": 3,
  "visitDate": "2026-04-10",
  "durationHours": 4,
  "numberOfPeople": 2,
  "specialRequest": "We'd like to visit the medina"
}
```

### Payments

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/payments` | Tourist | Simulate payment for a confirmed booking |

```json
{ "bookingId": 5, "amount": 1000.0, "method": "CARD" }
```

### Reviews

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/reviews` | Tourist | Leave a review (booking must be COMPLETED) |
| GET | `/reviews/guide/{guideId}` | Yes | Get reviews for a guide |

```json
{ "bookingId": 5, "rating": 5, "comment": "Excellent guide!" }
```

### Quick test (PowerShell)

```powershell
# Register
curl -X POST http://localhost:8085/api/auth/register `
  -H "Content-Type: application/json" `
  -d '{"name":"Test","email":"test@mail.com","password":"pass123"}'

# Login and capture token
$res = curl -X POST http://localhost:8085/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{"email":"test@mail.com","password":"pass123"}' | ConvertFrom-Json
$token = $res.data.token

# List guides
curl http://localhost:8085/api/guides -H "Authorization: Bearer $token"
```

---

## App Flows

| Flow | Steps |
|---|---|
| Tourist registration | Splash → Register → Home (guide list) |
| Book a guide | Guide card → Book → pick date/duration/people → Confirm |
| View bookings | Bottom nav "My Bookings" → see PENDING booking |
| Guide confirms | Login as guide → Guide Dashboard → confirm |
| Payment | My Bookings → CONFIRMED booking → Pay Now |
| Review | My Bookings → COMPLETED booking → Leave Review |
| AI Assistant | Bottom nav "AI Guide" → ask about any Moroccan city |

---

## Troubleshooting

### MySQL service not starting

```powershell
# Find your actual service name
Get-Service -Name "MySQL*"
# Start with correct name (run as Administrator)
net start MySQL95   # replace with your name
```

### HikariCP / database connection failed

1. MySQL not running — start it (see above)
2. Wrong password — check `backend/.env`
3. Database missing — `mysql -u root -p -e "CREATE DATABASE tourist_guide_db;"`

### `DB_PASSWORD` not resolved

```powershell
$env:DB_PASSWORD="your_password"
mvn spring-boot:run
```

### Port 8085 already in use

```powershell
netstat -ano | findstr :8085
taskkill /PID <PID> /F
```

### `flutter` not recognized

Add Flutter to PATH permanently:
1. Search "Environment Variables" in Windows Start
2. Edit `Path` → add `C:\flutter\bin`
3. Restart PowerShell

Or for current session: `$env:PATH += ";C:\flutter\bin"`

### App stuck on loading spinner

- Backend not running → start it first
- CORS blocked → `SecurityConfig.java` must have `HttpMethod.OPTIONS, "/**"` in `permitAll()`
- Wrong `baseUrl` → check `app_config.dart` for your platform

### AI tab shows error

- Missing key → add `OPENROUTER_API_KEY` to `frontend/.env`
- Invalid key → get a free one at https://openrouter.ai/keys
- Wrong model name → check https://openrouter.ai/models?q=free for valid IDs

### Cancel booking shows blank page

Use the dialog's own context for `Navigator.pop()`, not the page context:
```dart
showDialog(
  builder: (dialogCtx) => AlertDialog(
    actions: [TextButton(onPressed: () => Navigator.pop(dialogCtx), ...)],
  ),
);
```

### Duplicate GlobalKey error

`AppRouter.router` must be `static final`, not a getter. Already fixed in this project.

### Reset database (start fresh)

```powershell
mysql -u root -p -e "DROP DATABASE tourist_guide_db; CREATE DATABASE tourist_guide_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```
Restart the backend — tables and demo data recreated automatically.
