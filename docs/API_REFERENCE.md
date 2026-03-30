# API Reference

Base URL: `http://localhost:8085/api`

All protected endpoints require a JWT token in the header:
```
Authorization: Bearer <token>
```

Tokens are returned by `/auth/login` and expire after **24 hours**.

---

## Response format

Every endpoint returns the same structure:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

On error:
```json
{
  "success": false,
  "message": "Error description",
  "data": null
}
```

---

## Auth

### Register tourist
```
POST /auth/register
```
Body:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

### Register guide
```
POST /auth/register/guide
```
Body:
```json
{
  "name": "Ahmed Alami",
  "email": "ahmed@example.com",
  "password": "password123",
  "city": "Marrakech",
  "languages": ["Arabic", "French", "English"],
  "pricePerDay": 500,
  "transportAvailable": true,
  "bio": "Local guide with 5 years experience"
}
```

### Login
```
POST /auth/login
```
Body:
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```
Response `data`:
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "role": "TOURIST"
  }
}
```

---

## Guides

### List all guides
```
GET /guides
```
Auth: required

Optional query parameters:

| Param | Type | Example |
|---|---|---|
| `city` | string | `Marrakech` |
| `language` | string | `English` |
| `minBudget` | number | `100` |
| `maxBudget` | number | `500` |
| `transportAvailable` | boolean | `true` |
| `minRating` | number | `4.0` |

Example:
```
GET /guides?city=Marrakech&language=English&maxBudget=400
```

### Get guide by ID
```
GET /guides/{id}
```
Auth: required

### Guide dashboard (guide only)
```
GET /guide/dashboard
```
Auth: Guide role required

Response `data`:
```json
{
  "guideName": "Ahmed Alami",
  "totalEarnings": 2500.0,
  "totalBookings": 8,
  "completedBookings": 5,
  "pendingBookings": 2,
  "cancelledBookings": 1,
  "averageRating": 4.7
}
```

---

## Bookings

### Create booking (tourist)
```
POST /bookings
```
Auth: Tourist role required

Body:
```json
{
  "guideId": 3,
  "startDate": "2026-04-10",
  "endDate": "2026-04-12",
  "numberOfPeople": 2,
  "notes": "We'd like to visit the medina"
}
```

### Get my bookings (tourist)
```
GET /bookings/me
```
Auth: Tourist role required

### Get incoming bookings (guide)
```
GET /bookings/incoming
```
Auth: Guide role required

### Update booking status (guide)
```
PATCH /bookings/{id}/status
```
Auth: Guide role required

Body:
```json
{
  "status": "CONFIRMED"
}
```

Valid status transitions:

```
PENDING → CONFIRMED
PENDING → CANCELLED
CONFIRMED → COMPLETED
CONFIRMED → CANCELLED
```

---

## Payments

### Create payment (tourist)
```
POST /payments
```
Auth: Tourist role required

Body:
```json
{
  "bookingId": 5,
  "amount": 1000.0,
  "method": "CARD"
}
```

> Payment is a simulation — no real payment gateway is integrated.

---

## Reviews

### Create review (tourist)
```
POST /reviews
```
Auth: Tourist role required

Body:
```json
{
  "bookingId": 5,
  "rating": 5,
  "comment": "Excellent guide, very knowledgeable!"
}
```

> A review can only be submitted for a booking with status `COMPLETED`. Each booking can only be reviewed once.

### Get reviews for a guide
```
GET /reviews/guide/{guideId}
```
Auth: required

---

## Testing with curl (PowerShell)

```powershell
# 1. Register
curl -X POST http://localhost:8085/api/auth/register `
  -H "Content-Type: application/json" `
  -d '{"name":"Test","email":"test@mail.com","password":"pass123"}'

# 2. Login and capture token
$response = curl -X POST http://localhost:8085/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{"email":"test@mail.com","password":"pass123"}' | ConvertFrom-Json

$token = $response.data.token

# 3. List guides
curl http://localhost:8085/api/guides `
  -H "Authorization: Bearer $token"
```
