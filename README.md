# GuideMe — Tourist Guide Platform

A full-stack mobile platform that connects tourists with local independent guides. Tourists search and book guides; guides manage their bookings and track earnings.

## Project Structure

```
Mobile_dev_project/
├── README.md               # This file — project overview
├── SETUP.md                # Complete step-by-step setup guide (start here)
├── frontend/               # Flutter mobile app (Android, iOS, Web)
├── backend/                # Spring Boot REST API
│   ├── README.md           # Backend architecture & endpoints
│   └── .env.example        # Environment variable template
└── docs/
    ├── DATABASE_SETUP.md   # MySQL installation & database setup
    ├── API_REFERENCE.md    # Full API documentation with examples
    └── TROUBLESHOOTING.md  # Common errors & fixes
```

## Two User Roles

| Role | What they do |
|---|---|
| **Tourist** | Search guides by city/budget/language, view profiles, book, pay, leave reviews |
| **Guide** | Receive booking requests, confirm/complete/cancel, view dashboard & earnings |

## Quick Start (Windows — PowerShell)

> Full guide with every detail: [SETUP.md](SETUP.md)

```powershell
# Terminal 1 — Start backend
cd backend
$env:DB_PASSWORD="your_mysql_password"
mvn spring-boot:run
# Wait for: "Started TouristGuideApplication in X.XXX seconds"

# Terminal 2 — Start frontend
cd frontend
copy .env.example .env        # then edit .env with your API keys
flutter pub get
flutter run -d chrome --web-port 3000
```

- Backend API: `http://localhost:8085/api`
- Frontend (web): `http://localhost:3000`

## Features

| Feature | Description |
|---|---|
| Guide search | Filter by city, language, budget, transport |
| Booking | Book a guide with date, duration and group size |
| Payments | Simulate payment for confirmed bookings |
| Reviews | Leave a star review after a completed tour |
| Guide dashboard | Guides manage bookings and track earnings |
| **AI Assistant** | Chat with an AI travel assistant about Moroccan cities and attractions |

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter 3.x (Dart) |
| State Management | Riverpod (StateNotifier) |
| Navigation | GoRouter |
| HTTP Client | Dio (with JWT interceptor) |
| Backend | Spring Boot 3.2.5 (Java 17) |
| Database | MySQL 8 |
| Auth | JWT (Bearer token, 24h expiry) |
| AI | OpenRouter API (`stepfun/step-3.5-flash:free`) |

## Documentation

| Document | Description |
|---|---|
| [SETUP.md](SETUP.md) | Step-by-step guide to run the project from scratch |
| [docs/DATABASE_SETUP.md](docs/DATABASE_SETUP.md) | MySQL setup, database creation, reset |
| [docs/API_REFERENCE.md](docs/API_REFERENCE.md) | All endpoints with request/response examples |
| [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | Common errors and how to fix them |
| [backend/README.md](backend/README.md) | Backend architecture & API reference |
