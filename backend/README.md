# GuideMe — Backend

Spring Boot REST API for the GuideMe tourist guide platform.

> The AI Assistant feature calls **OpenRouter** directly from the Flutter frontend — no backend changes needed for AI.

## Requirements

- Java 17+
- Maven 3.8+
- MySQL 8+

## Setup & Run

### 1. Create the database

```powershell
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS tourist_guide_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

### 2. Create your `.env` file

```powershell
copy .env.example .env
```

Edit `.env` and fill in your MySQL password:
```
DB_URL=jdbc:mysql://localhost:3306/tourist_guide_db?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
DB_USERNAME=root
DB_PASSWORD=your_mysql_password
JWT_SECRET=any_random_string_at_least_32_characters
```

### 3. Run the backend

```powershell
# Set environment variables, then start
$env:DB_PASSWORD="your_mysql_password"
$env:DB_USERNAME="root"
mvn spring-boot:run
```

Wait for:
```
Started TouristGuideApplication in X.XXX seconds
```

API is available at `http://localhost:8085/api`.

> **Tables are created automatically** by Hibernate on first start. Sample guides are seeded automatically — no manual SQL needed.

> Use `mvn spring-boot:run` (not `.\mvnw.cmd`) — the Maven wrapper `.cmd` file may not exist on your machine.

---

## Project Structure

```
src/main/java/com/touristguide/
├── TouristGuideApplication.java         # Entry point
├── config/
│   ├── SecurityConfig.java              # Spring Security + CORS configuration
│   └── DataSeeder.java                  # Seeds sample guides on first startup
├── features/
│   ├── auth/                            # Register, login → returns JWT
│   │   ├── controller/AuthController
│   │   ├── service/AuthService
│   │   ├── model/AppUser, UserRole
│   │   └── dto/LoginRequest, RegisterRequest, AuthResponse
│   ├── guides/                          # Guide listing, search, dashboard
│   │   ├── controller/GuideController, GuideDashboardController
│   │   ├── service/GuideService, GuideDashboardService
│   │   ├── model/Guide
│   │   └── dto/GuideDto, GuideDashboardDto
│   ├── booking/                         # Create, list, update booking status
│   │   ├── controller/BookingController
│   │   ├── service/BookingService
│   │   ├── model/Booking, BookingStatus
│   │   └── dto/BookingDto, CreateBookingRequest, UpdateBookingStatusRequest
│   ├── payment/                         # Payment simulation
│   │   ├── controller/PaymentController
│   │   ├── service/PaymentService
│   │   └── model/Payment, PaymentStatus
│   └── reviews/                         # Reviews for completed bookings
│       ├── controller/ReviewController
│       ├── service/ReviewService
│       └── model/Review
├── security/
│   ├── jwt/JwtService.java              # Token generation & validation
│   └── filters/JwtAuthenticationFilter # Authenticates each request via JWT
└── shared/
    ├── response/ApiResponse.java        # Unified JSON response wrapper
    └── exception/                       # Global error handling
```

Each feature follows: `controller → service → repository → model/dto`

---

## API Endpoints

### Auth (no authentication required)

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/auth/register` | Register as tourist |
| POST | `/api/auth/register/guide` | Register as guide |
| POST | `/api/auth/login` | Login → returns JWT token |

### Guides

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/api/guides` | Yes | List all guides (supports filters) |
| GET | `/api/guides/{id}` | Yes | Get guide details |
| GET | `/api/guide/dashboard` | Guide only | Guide's own stats, profile & bookings |

**Search filter query params:** `city`, `minBudget`, `maxBudget`, `language`, `transportAvailable`, `minRating`

Example: `GET /api/guides?city=Marrakech&minRating=4.0`

### Bookings

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/api/bookings` | Tourist | Create a booking |
| GET | `/api/bookings/me` | Tourist | Get my bookings |
| GET | `/api/bookings/incoming` | Guide | Bookings assigned to this guide |
| PATCH | `/api/bookings/{id}/status` | Guide | Update booking status |

**Booking status flow:** `PENDING` → `CONFIRMED` → `COMPLETED` or `CANCELLED`

### Payments & Reviews

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/api/payments` | Tourist | Simulate payment for a confirmed booking |
| POST | `/api/reviews` | Tourist | Leave a review for a completed booking |

---

## Authentication

All protected endpoints require a Bearer token in the `Authorization` header:

```
Authorization: Bearer <jwt_token>
```

Tokens are returned by `/api/auth/login` and expire after **24 hours**.

---

## Response Format

All endpoints return a unified response wrapper:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

Errors follow the same structure with `"success": false`:
```json
{
  "success": false,
  "message": "Email already exists",
  "data": null
}
```

---

## Environment Variables

| Variable | Default | Required | Description |
|---|---|---|---|
| `DB_URL` | `jdbc:mysql://localhost:3306/tourist_guide_db?...` | No | Full JDBC connection URL |
| `DB_USERNAME` | `root` | No | MySQL username |
| `DB_PASSWORD` | *(none)* | **Yes** | MySQL password — must be set |
| `JWT_SECRET` | built-in default | No | JWT signing key (change in production) |

---

## Demo Data

On startup, `DataSeeder` automatically inserts sample guides **only if the guide table is empty**:
- First run: 5–6 sample guides created (names, cities, languages, prices)
- Subsequent runs: existing data preserved — no duplicates
- Profile images are intentionally left empty to avoid external image CORS issues on web

To reseed from scratch, reset the database (see [docs/DATABASE_SETUP.md](../docs/DATABASE_SETUP.md)).
