# Database Setup

This project uses **MySQL 8**. The schema is managed automatically by Hibernate (`ddl-auto=update`) — you only need to create the empty database.

---

## 1. Install MySQL (Windows)

Download **MySQL Installer** from:
```
https://dev.mysql.com/downloads/installer/
```

Run the installer and choose **Developer Default**. Set a root password during setup — you'll need it later.

---

## 2. Find your MySQL service name

MySQL installs a Windows service with a version number in the name. It varies by installation:

```powershell
Get-Service -Name "MySQL*"
```

Common names: `MySQL80`, `MySQL95`, `MySQL`. Note which one shows up.

---

## 3. Start the MySQL service

Replace `MySQL80` with your actual service name. This requires **Administrator** PowerShell:

```powershell
net start MySQL80
```

To verify it's running:
```powershell
Get-Service -Name "MySQL*"
# Should show Status: Running
```

To stop it later:
```powershell
net stop MySQL80
```

---

## 4. Create the database

Connect to MySQL:
```powershell
mysql -u root -p
```

Enter your password, then run:
```sql
CREATE DATABASE IF NOT EXISTS tourist_guide_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Verify it was created
SHOW DATABASES;

EXIT;
```

Or as a one-liner without entering the MySQL shell:
```powershell
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS tourist_guide_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

---

## 5. (Optional) Create a dedicated user

Instead of using `root`, create a dedicated app user:

```sql
CREATE USER 'guideme'@'localhost' IDENTIFIED BY 'choose_a_password';
GRANT ALL PRIVILEGES ON tourist_guide_db.* TO 'guideme'@'localhost';
FLUSH PRIVILEGES;
```

Then update `backend/.env`:
```
DB_USERNAME=guideme
DB_PASSWORD=choose_a_password
```

---

## 6. Verify the connection

Test before starting the backend:
```powershell
mysql -u root -p -e "USE tourist_guide_db; SELECT 'Connection OK';"
```

---

## 7. What Hibernate creates automatically

On first backend startup, Hibernate creates all tables from entity classes:

| Table | Description |
|---|---|
| `app_user` | Tourist and guide accounts |
| `guide` | Guide profiles (linked to app_user) |
| `guide_languages` | Join table for guide language list |
| `booking` | Booking records between tourists and guides |
| `payment` | Payment records linked to bookings |
| `review` | Reviews left by tourists after completed tours |

No SQL migration scripts are needed.

---

## 8. Demo data (DataSeeder)

`DataSeeder.java` runs automatically on every backend startup. It inserts sample guides into the database **only if the guide table is empty**:

- **First run:** 5–6 sample guides are created automatically
- **Subsequent runs:** existing data is preserved — no duplicates

---

## 9. Reset the database (start fresh)

If you want to wipe all data and recreate everything from scratch:

```powershell
mysql -u root -p -e "DROP DATABASE tourist_guide_db; CREATE DATABASE tourist_guide_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

Then restart the backend — tables and demo data will be recreated automatically.

---

## 10. Browse the data (GUI tools)

- **MySQL Workbench** — bundled with MySQL Installer, full GUI
- **DBeaver** — free universal DB client, recommended
- **IntelliJ IDEA** — built-in Database panel

Connection settings for any tool:
```
Host:     localhost
Port:     3306
Database: tourist_guide_db
User:     root
Password: <your root password>
```
