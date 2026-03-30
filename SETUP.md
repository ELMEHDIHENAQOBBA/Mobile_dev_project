# Quick Setup Reference

For full documentation see [README.md](README.md).

---

## 1. Prerequisites

```powershell
java -version    # need 17+
mvn -version     # need 3.8+
mysql --version  # need 8.0+
flutter --version
```

---

## 2. Database

```powershell
# Find service name, then start (as Administrator)
Get-Service -Name "MySQL*"
net start MySQL80   # replace with your name

# Create database
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS tourist_guide_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

---

## 3. Backend

```powershell
copy backend\.env.example backend\.env
# Edit backend\.env — set DB_PASSWORD at minimum

cd backend
$env:DB_PASSWORD="your_password"
mvn spring-boot:run
# Wait for: "Started TouristGuideApplication in X.XXX seconds"
```

---

## 4. Frontend

```powershell
copy frontend\.env.example frontend\.env
# Edit frontend\.env — set OPENROUTER_API_KEY

cd frontend
flutter pub get
flutter run -d chrome --web-port 3000
```

---

## Both running?

- Backend: `http://localhost:8085/api`
- Frontend: `http://localhost:3000`

Test: `curl http://localhost:8085/api/auth/login` should return a 400 (not a connection error).
