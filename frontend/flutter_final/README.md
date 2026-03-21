# Tourist Guide Uber-Like Mobile Application

A Flutter mobile application that connects tourists with independent local guides.
The platform follows an **Uber-like service model**, allowing tourists to search for guides based on budget and preferences, book a guide, and complete the service lifecycle.

This project was developed as part of a **Mobile Development course project** focused on the *Uberisation of a service*.

---

# 📱 Project Concept

Tourists often struggle to find reliable local guides quickly.
This application provides a digital marketplace where:

* **Tourists (service beneficiaries)** can find and book guides.
* **Guides (service providers)** can offer their services and receive booking requests.

The application demonstrates a **Minimum Viable Product (MVP)** capable of validating the business concept.

---

# 🏗️ Architecture

The application is built with **Flutter** and follows **Clean Architecture principles**.

```text
lib/
├── core/                # Global utilities, configs and services
├── features/
│   ├── auth/            # Authentication feature
│   ├── guides/          # Tourist guide feature
│   │   ├── data/        # Mock data sources
│   │   ├── domain/      # Entities and business models
│   │   └── presentation/# UI pages and widgets
│   ├── booking/         # Guide reservation
│   ├── payment/         # Payment simulation
│   └── reviews/         # Guide rating system
└── shared/              # Shared UI components
```

This layered architecture ensures:

* clear separation of concerns
* maintainable and scalable code
* easier future backend integration

---

# 🚀 MVP Features

The current MVP implements the core workflow of an Uber-like service.

## Tourist (Service Beneficiary)

* Create account / Login
* Search for guides
* Filter by destination, budget, language
* View guide profiles
* Book a guide
* Simulate payment
* Rate the guide after the service

## Guide (Service Provider)

* Login
* Receive booking requests
* Confirm service completion
* View earnings (MVP simulation)

## Administrator (Future extension)

* Manage guides
* View registered tourists
* Monitor system activity

---

# 🔎 Current User Flow

```text
Login
 ↓
Search Guides
 ↓
Guides List
 ↓
Guide Details
 ↓
Book Guide
 ↓
Payment (MVP simulation)
 ↓
Service Completion
 ↓
Leave Review
```

---

# 🧰 Technologies Used

* **Flutter** – Cross-platform mobile development
* **Flutter Bloc** – State management
* **GoRouter** – Navigation and routing
* Mock data sources for MVP validation

---

# ⚙️ Installation

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

# 📦 Deliverables

The final project submission includes:

* Mobile application APK
* Hosted web version (optional)
* Public GitHub repository
* Demonstration video
* Project report explaining design choices

---

# 🎯 Project Goal

The goal of this project is to demonstrate how **digital platforms can "Uberize" traditional services**, in this case **local tourism guiding**, by enabling direct interaction between tourists and independent guides through a centralized mobile application.
