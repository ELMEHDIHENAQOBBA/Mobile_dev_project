# Complete Setup Guide

Follow these steps in order to get the full project running locally on Windows.

---

## Prerequisites

Install these before anything else:

| Tool | Minimum version | Download |
|---|---|---|
| Java JDK | 17 | https://adoptium.net |
| Maven | 3.8 | https://maven.apache.org/download.cgi |
| MySQL | 8.0 | https://dev.mysql.com/downloads/installer |
| Flutter | 3.x | https://docs.flutter.dev/get-started/install/windows |
| Git | any | https://git-scm.com |

Verify everything is installed by opening PowerShell and running:

```powershell
java -version
mvn -version
mysql --version
flutter --version
```

If any command is not recognized, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

---

## Step 1 — Clone the project

```powershell
git clone <your-repo-url>
cd Mobile_dev_project
```

---

## Step 2 — Set up MySQL

### 2a. Find your MySQL service name

MySQL installs a Windows service whose name includes the version number. Find yours:

```powershell
Get-Service -Name "MySQL*"
```

Common names: `MySQL80`, `MySQL95`, `MySQL`. Use whatever shows up in your output.

### 2b. Start MySQL

Replace `MySQL80` with your actual service name:

```powershell
# Run as Administrator
net start MySQL80
```

### 2c. Create the database

```powershell
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS tourist_guide_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

Enter your MySQL root password when prompted.

> See the full database guide: [docs/DATABASE_SETUP.md](docs/DATABASE_SETUP.md)

---

## Step 3 — Configure backend credentials

### 3a. Create your `.env` file

```powershell
copy backend\.env.example backend\.env
```

### 3b. Edit `backend\.env`

Open the file and fill in your MySQL password:

```
DB_URL=jdbc:mysql://localhost:3306/tourist_guide_db?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
DB_USERNAME=root
DB_PASSWORD=your_mysql_root_password
JWT_SECRET=any_random_string_at_least_32_characters_long
```

> **Note:** `DB_PASSWORD` has no default — you must set it, otherwise the backend won't start.

---

## Step 4 — Run the backend

Open a PowerShell terminal in the `backend/` folder:

```powershell
cd backend

# Load .env variables and start (Windows PowerShell)
$env:DB_PASSWORD="your_mysql_password"
$env:DB_USERNAME="root"
mvn spring-boot:run
```

Wait for this line in the output:

```
Started TouristGuideApplication in X.XXX seconds
```

The API is now running at `http://localhost:8085/api`.

> Tables are created automatically by Hibernate on first start. Sample guides are seeded automatically — no manual SQL needed.

### Why `mvn` and not `.\mvnw.cmd`?

The project includes a Maven wrapper (`mvnw`) but the `.cmd` version may not exist on your machine. Using `mvn` directly (from your global Maven installation) works just as well.

---

## Step 5 — Configure the frontend

### 5a. Backend URL

Open `frontend/lib/core/config/app_config.dart` and verify the `baseUrl` matches where you're running Flutter:

| Where you run Flutter | `baseUrl` to use |
|---|---|
| Chrome / Web (`flutter run -d chrome`) | `http://localhost:8085/api` |
| Android Emulator | `http://10.0.2.2:8085/api` |
| Physical Android device (same Wi-Fi) | `http://YOUR_PC_IP:8085/api` |

To find your PC's local IP address:
```powershell
ipconfig | findstr "IPv4"
```

### 5b. Frontend `.env` file

```powershell
copy frontend\.env.example frontend\.env
```

Edit `frontend\.env` and fill in your OpenRouter API key:

```env
OPENROUTER_API_KEY=sk-or-your-key-here
AI_MODEL=stepfun/step-3.5-flash:free
```

Get a free key at https://openrouter.ai/keys — no billing required.
Browse other free models at https://openrouter.ai/models?q=free.

> The app works without the key — the AI tab will show an error if the key is missing or invalid.

---

## Step 6 — Run the frontend

Open a **new** PowerShell terminal in the `frontend/` folder:

```powershell
cd frontend
flutter pub get
flutter run -d chrome --web-port 3000
```

This opens the app in Chrome at `http://localhost:3000`.

To run on an Android emulator or device instead, omit `-d chrome --web-port 3000` and choose your device when prompted.

---

## Step 7 — Test that everything works

### Register a tourist account

```powershell
curl -X POST http://localhost:8085/api/auth/register `
  -H "Content-Type: application/json" `
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'
```

Expected response:
```json
{ "success": true, "message": "...", "data": { "token": "eyJ..." } }
```

### Login

```powershell
curl -X POST http://localhost:8085/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{"email":"test@example.com","password":"password123"}'
```

### Register a guide account (to test guide dashboard)

```powershell
curl -X POST http://localhost:8085/api/auth/register/guide `
  -H "Content-Type: application/json" `
  -d '{"name":"Test Guide","email":"guide@example.com","password":"password123","city":"Marrakech","bio":"Experienced local guide","languages":["English","French"],"priceMin":200,"priceMax":500,"transportAvailable":true}'
```

---

## App flows to test

| Flow | Steps |
|---|---|
| Tourist login | Register → Login → see home screen with guide list |
| Book a guide | Click a guide → Book → pick date/duration/people → Confirm Booking |
| View bookings | Home → My Bookings → see PENDING booking |
| Guide confirms | Login as guide → Guide Dashboard → confirm booking |
| Payment | My Bookings → booking turns CONFIRMED → Pay Now |
| Review | After tour COMPLETED → Leave Review |

---

## Common errors

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for solutions to the most common issues including:

- MySQL service not starting
- HikariCP database connection failures
- `DB_PASSWORD` not found
- Port 8085 already in use
- Flutter not recognized
- App stuck on loading spinner
- CORS errors
- Navigation/routing errors
