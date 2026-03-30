# Troubleshooting

Solutions to errors encountered when running this project on Windows. These are all real errors that occurred during development and testing.

---

## Backend issues

### HikariCP database connection failure

**Error:**
```
com.zaxxer.hikari.pool.HikariPool$PoolInitializationException:
Failed to initialize pool: Connection refused
```

**Causes and fixes:**

**1. MySQL is not running.**
First find your MySQL service name, then start it (requires Administrator PowerShell):
```powershell
# Find service name
Get-Service -Name "MySQL*"

# Start it (replace MySQL80 with your actual name, e.g. MySQL95)
net start MySQL80
```

**2. Wrong password.**
Check `backend/.env`:
```
DB_PASSWORD=your_actual_mysql_password
```

**3. Environment variables not loaded.**
You must set them in the same terminal session before running Maven:
```powershell
$env:DB_PASSWORD="your_password"
mvn spring-boot:run
```

**4. Database doesn't exist.**
```powershell
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS tourist_guide_db;"
```

---

### `DB_PASSWORD` placeholder not resolved

**Error:**
```
Could not resolve placeholder 'DB_PASSWORD' in value "${DB_PASSWORD}"
```

**Fix:** `DB_PASSWORD` has no default value and must always be set. Run:
```powershell
$env:DB_PASSWORD="your_password"
mvn spring-boot:run
```

---

### MySQL service name not found / access denied

**Error:**
```
The service name is invalid.
```
or
```
System error 5 has occurred. Access is denied.
```

**Fix for wrong name:** Find the correct name first:
```powershell
Get-Service -Name "MySQL*"
```
Use the exact name shown (e.g. `MySQL95`, not `MySQL80`).

**Fix for access denied:** You must run PowerShell as Administrator:
- Right-click PowerShell in Start → **Run as administrator**
- Then: `net start MySQL95`

---

### `.\mvnw.cmd` not recognized / not found

**Error:**
```
The term '.\mvnw.cmd' is not recognized
```
or Maven wrapper `.cmd` file is missing.

**Fix:** Use your global Maven installation directly:
```powershell
mvn spring-boot:run
```

If `mvn` is also not recognized, add Maven to your PATH or install it from https://maven.apache.org/download.cgi.

---

### Port 8085 already in use

**Error:**
```
Web server failed to start. Port 8085 was already in use.
```

**Fix — kill the process using the port:**
```powershell
netstat -ano | findstr :8085
# Note the PID in the last column
taskkill /PID <PID_NUMBER> /F
```

**Fix — change the port (if you prefer):**
In `backend/src/main/resources/application.properties`:
```properties
server.port=8086
```
Then update `frontend/lib/core/config/app_config.dart` to match.

---

### Java not found

**Error:**
```
'java' is not recognized as an internal or external command
```

**Fix:** Install Java 17+ from https://adoptium.net. During install, check the option to set `JAVA_HOME` automatically. Or set it manually:
```powershell
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Eclipse Adoptium\jdk-17.x.x", "Machine")
$env:PATH += ";$env:JAVA_HOME\bin"
```
Restart PowerShell after.

---

### Dates serialized as arrays in JSON

**Symptom:** Backend returns dates as arrays like `[2026, 4, 10]` instead of `"2026-04-10"`. The frontend fails to parse bookings.

**Fix:** Add to `application.properties`:
```properties
spring.jackson.serialization.write-dates-as-timestamps=false
```
This is already included in the project. If you're seeing this issue, make sure your `application.properties` is up to date.

---

### 401 Unauthorized on all requests after login

**Cause:** JWT token expired (tokens last 24 hours), or the `Authorization` header isn't being sent.

**Fix:**
1. Log out and log back in to get a fresh token
2. If the issue persists on web: clear `localStorage` in browser DevTools → Application → Local Storage
3. Check that `DioInterceptor` is attaching the token (look at `frontend/lib/core/network/app_network.dart`)

---

## Frontend issues

### `flutter` is not recognized

**Error:**
```
The term 'flutter' is not recognized as the name of a cmdlet...
```

**Fix — permanent (recommended):**
1. Search "Environment Variables" in Windows Start
2. Edit `Path` system variable → add your Flutter `bin` path (e.g. `C:\flutter\bin` or `C:\src\flutter\bin`)
3. Restart PowerShell

**Fix — temporary (current session only):**
```powershell
$env:PATH += ";C:\flutter\bin"
```

---

### How to run Flutter on Chrome

```powershell
cd frontend
flutter run -d chrome --web-port 3000
```

The app opens at `http://localhost:3000`. The `--web-port 3000` prevents the port from changing on every reload.

If Chrome is not available as a device:
```powershell
flutter devices        # list available devices
flutter config --enable-web
flutter run -d chrome
```

---

### App stuck on loading spinner (splash screen never navigates)

**Cause:** The splash screen listens to auth state. If the auth state never changes (e.g. the `checkAuthStatus()` call fails silently), the spinner stays forever.

**What to check:**
1. Is the backend running? The splash screen calls the backend to check if the stored token is still valid.
2. Check `frontend/lib/features/auth/providers/auth_notifier.dart` — the `checkAuthStatus` method must set `AuthState.authenticated(user)` on success (not `unauthenticated()`).
3. Check the Flutter logs in the terminal for any Dio errors.

---

### Bookings / guides list stuck on spinner

**Cause 1 — Backend not running.** Check the backend terminal.

**Cause 2 — CORS preflight blocked.** Spring Security was blocking `OPTIONS` requests to authenticated endpoints. This is fixed in `SecurityConfig.java`:
```java
.requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
```
Make sure this line is present.

**Cause 3 — Network URL wrong.** Check `frontend/lib/core/config/app_config.dart`:
- Chrome/Web: `http://localhost:8085/api`
- Android emulator: `http://10.0.2.2:8085/api`
- Physical device: `http://YOUR_PC_IP:8085/api`

---

### CORS errors for images (i.pravatar.cc blocked)

**Error in Chrome DevTools:**
```
Access to image at 'https://i.pravatar.cc/...' from origin 'http://localhost:3000' has been blocked by CORS policy
```

**Fix:** The `DataSeeder.java` sets all `profileImage` fields to `""` (empty string). Empty profile images show a person icon instead of loading a URL. If you're seeing this error, your database has old data with `pravatar.cc` URLs.

Reset the database:
```powershell
mysql -u root -p -e "DROP DATABASE tourist_guide_db; CREATE DATABASE tourist_guide_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```
Then restart the backend to reseed.

---

### "Tried to modify a provider while the widget tree was building"

**Error:**
```
Tried to modify a provider while the widget tree was building.
If you are encountering this error, please post a reproduction on GitHub.
```

**Cause:** Calling a Riverpod provider's method directly in `initState()` while the widget tree is still building.

**Fix:** Wrap the call in `Future.microtask()` to defer it until after the build:
```dart
@override
void initState() {
  super.initState();
  Future.microtask(() => ref.read(myProvider.notifier).loadSomething());
}
```

---

### Cancel booking shows blank white page / "popped last page off stack"

**Error in logs:**
```
The navigator on MyBookingsPage tried to push a new route, but the navigator received a
'popUntil' after that...
```
or the whole page disappears after cancelling.

**Cause:** Using the outer page's `BuildContext` to call `Navigator.pop()` inside a dialog. In GoRouter, `Navigator.pop(context)` where `context` is the page's context removes the entire page from the navigation stack.

**Fix:** Always use the dialog's own `BuildContext` for `Navigator.pop()`:
```dart
showDialog(
  context: context,
  builder: (dialogCtx) => AlertDialog(  // <-- dialogCtx, not context
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(dialogCtx),  // correct: closes dialog
        child: const Text('Cancel'),
      ),
    ],
  ),
);
```

---

### "Duplicate GlobalKey detected in widget tree"

**Error:**
```
Another exception was thrown: Duplicate GlobalKey detected in widget tree.
```

**Cause:** `AppRouter.router` was implemented as a getter (`get router => GoRouter(...)`), which creates a new `GoRouter` instance on every widget rebuild while reusing the same `_rootNavigatorKey` (static final). Flutter detects the same key used in two different navigator instances.

**Fix:** `AppRouter.router` must be a `static final` field, not a getter:
```dart
// WRONG — creates new GoRouter on every rebuild:
static GoRouter get router => GoRouter(navigatorKey: _rootNavigatorKey, ...);

// CORRECT — created once:
static final GoRouter router = GoRouter(navigatorKey: _rootNavigatorKey, ...);
```
After this change, press `R` in the Flutter terminal for a full hot restart.

---

### `flutter pub get` fails — package not found

```powershell
flutter pub cache repair
flutter pub get
```

---

### Missing `.freezed.dart` or `.g.dart` files

**Error:** Import errors about undefined classes that come from code generation.

**Fix:**
```powershell
cd frontend
dart run build_runner build --delete-conflicting-outputs
```

---

### Android emulator can't reach backend

Make sure:
1. `baseUrl` in `app_config.dart` is `http://10.0.2.2:8085/api` (not `localhost`)
2. Backend is running on your PC
3. Windows Firewall allows the port:
   ```powershell
   netsh advfirewall firewall add rule name="GuideMe Backend" dir=in action=allow protocol=TCP localport=8085
   ```

---

## Still stuck?

1. Read the backend logs in the terminal where you ran `mvn spring-boot:run`
2. Read the Flutter logs in the terminal where you ran `flutter run`
3. Open Chrome DevTools (F12) → Console and Network tabs to see request details
4. For verbose backend logs:
   ```powershell
   $env:DB_PASSWORD="your_password"
   mvn spring-boot:run -X
   ```
