# 📁 Dokumentasi Struktur Folder `lib` - BeLing App lengkap

## 🏗️ Arsitektur Proyek

Proyek BeLing menggunakan **Feature-First Architecture** yang dikombinasikan dengan **Clean Architecture** untuk memastikan kode yang terorganisir, scalable, dan mudah di-maintain. Setiap feature dipisahkan ke dalam folder tersendiri dengan struktur yang konsisten.

---

## 📋 Struktur Utama

```
lib/
├── main.dart
├── core/
├── router/
├── shared/
├── featureAuthentication/
├── featureDictionary/
├── featureHomeScreen/
├── featureLeaderboard/
├── featureOnBoarding/
├── featurePractice/
├── featureProfile/
└── featureWelcome/
```

---

## 🔍 Penjelasan Detail Struktur

### 📄 `main.dart`
**Peran:** Entry point utama aplikasi Flutter
- Titik awal eksekusi aplikasi
- Mengatur konfigurasi dasar app
- Menginisialisasi routing dan dependency injection
- Mengatur theme dan konfigurasi global

---

### 🏛️ `core/` - Foundation Layer
**Peran:** Menyediakan fungsi-fungsi inti yang digunakan di seluruh aplikasi

#### 📁 `core/constants/`
- **File:** `app_constants.dart`
- **Fungsi:** Menyimpan konstanta global aplikasi
- **Contoh isi:** 
  - URL API endpoints
  - Ukuran dan spacing standar
  - Konfigurasi timeout
  - String constants

#### 📁 `core/services/`
- **File:** `tts_service.dart`
- **Fungsi:** Service layer untuk Text-to-Speech
- **Kegunaan:**
  - Mengatur konfigurasi TTS
  - Menyediakan fungsi speak untuk fitur audio
  - Mengelola state audio playback

#### 📁 `core/theme/`
- **File:** `app_theme.dart`
- **Fungsi:** Konfigurasi tema visual aplikasi
- **Kegunaan:**
  - Mendefinisikan color scheme
  - Mengatur typography styles
  - Konfigurasi component themes
  - Dark/Light theme support

#### 📁 `core/di/`
- **Fungsi:** Dependency Injection container
- **Kegunaan:**
  - Mengatur singleton instances
  - Service registration
  - Repository binding

#### 📄 `core/core.dart`
- **Fungsi:** Barrel file untuk export semua core modules
- **Kegunaan:** Mempermudah import core functionality

---

### 🗺️ `router/` - Navigation Layer
**Peran:** Mengelola navigasi dan routing aplikasi

#### 📄 `route_constants.dart`
- **Fungsi:** Definisi konstanta untuk nama route
- **Kegunaan:**
  - Centralized route naming
  - Mencegah typo pada navigation
  - Type-safe routing

#### 📄 `router.dart`
- **Fungsi:** Konfigurasi utama routing
- **Kegunaan:**
  - Setup GoRouter atau Navigator
  - Route guards dan middleware
  - Deep linking configuration

#### 📄 `router_exports.dart`
- **Fungsi:** Barrel file untuk export router modules
- **Kegunaan:** Simplified imports

---

### 🔗 `shared/` - Shared Components
**Peran:** Komponen yang dapat digunakan kembali di berbagai feature

#### 📁 `shared/widgets/`
- **File:** `global_navbar.dart`
- **Fungsi:** Widget navbar yang digunakan di seluruh app
- **Kegunaan:**
  - Bottom navigation bar
  - Consistent navigation experience
  - Icon dan label management

#### 📄 `shared_exports.dart`
- **Fungsi:** Barrel file untuk shared components
- **Kegunaan:** Centralized shared widget exports

---

## 🎯 Feature Modules

Setiap feature mengikuti **Clean Architecture** dengan pembagian layer:

### 🏗️ Struktur Clean Architecture per Feature

```
featureX/
├── data/          # Data Layer
├── domain/        # Business Logic Layer  
├── presentation/  # UI Layer
└── feature_exports.dart
```

---

### 🔐 `featureAuthentication/` - Modul Autentikasi
**Peran:** Mengelola proses login, register, dan manajemen session

#### 📁 `data/`
- **Subfolder:**
  - `datasources/` - API calls dan local storage
  - `repositories/` - Implementation repository pattern
  - `constants/` - Auth-specific constants
- **File:** `data.dart` - Export barrel file

#### 📁 `domain/`
- **Subfolder:**
  - `models/` - Entity dan model classes
  - `repositories/` - Abstract repository contracts
- **File:** `domain.dart` - Export barrel file

#### 📁 `presentation/`
- **Subfolder:**
  - `screens/` - Login, register, forgot password screens
  - `widgets/` - Auth-specific widgets (form fields, buttons)
- **File:** `presentation.dart` - Export barrel file

#### 📄 `authentication.dart`
- **Fungsi:** Main export file untuk feature authentication

---

### 📚 `featureDictionary/` - Modul Kamus
**Peran:** Fitur pencarian kata dan definisi

#### 📁 `screens/`
- **Kegunaan:** Halaman-halaman dictionary
- **Contoh:** Search screen, word detail, favorites

#### 📁 `widgets/`
- **Kegunaan:** Widget khusus dictionary
- **Contoh:** Search bar, word card, pronunciation button

---

### 🏠 `featureHomeScreen/` - Modul Beranda
**Peran:** Dashboard utama aplikasi

#### 📁 `presentation/`
- **Kegunaan:** UI components untuk home
- **Contoh:** Dashboard widgets, stats cards, quick actions

---

### 🏆 `featureLeaderboard/` - Modul Papan Skor
**Peran:** Sistem ranking dan kompetisi

#### 📁 `data/`
- **Kegunaan:** API calls untuk leaderboard data
- **Contoh:** Fetch rankings, user scores

#### 📁 `domain/`
- **Kegunaan:** Business logic ranking
- **Contoh:** Score calculation, ranking algorithms

#### 📁 `presentation/`
- **Kegunaan:** UI leaderboard
- **Contoh:** Ranking list, user position, filters

#### 📄 `leaderboard_exports.dart`
- **Fungsi:** Export barrel file

---

### 🎯 `featureOnBoarding/` - Modul Pengenalan
**Peran:** Tutorial dan introduction untuk user baru

#### 📁 `data/`
- **Kegunaan:** Onboarding data management
- **Contoh:** Progress tracking, tutorial steps

#### 📁 `domain/`
- **Kegunaan:** Onboarding business logic
- **Contoh:** Step validation, completion tracking

#### 📁 `presentation/`
- **Kegunaan:** Onboarding UI screens
- **Contoh:** Tutorial slides, progress indicators

---

### 💪 `featurePractice/` - Modul Latihan
**Peran:** Sistem latihan dan exercise

#### 📁 `data/`
- **Kegunaan:** Practice data management
- **Contoh:** Exercise API, progress storage

#### 📁 `domain/`
- **Kegunaan:** Practice business logic
- **Contoh:** Score calculation, difficulty adjustment

#### 📁 `presentation/`
- **Kegunaan:** Practice UI components
- **Contoh:** Exercise screens, result dialogs

---

### 👤 `featureProfile/` - Modul Profil
**Peran:** Manajemen profil dan pengaturan user

#### 📁 `data/`
- **Kegunaan:** User data management
- **Contoh:** Profile API, settings storage

#### 📁 `domain/`
- **Kegunaan:** Profile business logic
- **Contoh:** Validation, data transformation

#### 📁 `presentation/`
- **Kegunaan:** Profile UI screens
- **Contoh:** Profile view, edit forms, settings

#### 📄 `profile_exports.dart`
- **Fungsi:** Export barrel file

---

### 🎉 `featureWelcome/` - Modul Selamat Datang
**Peran:** Welcome screen dan initial setup

#### 📁 `presentation/`
- **Kegunaan:** Welcome UI components
- **Contoh:** Splash screen, welcome animations

---

## 💡 Keuntungan Struktur Ini

### ✅ **Modularitas**
- Setiap feature terisolasi dengan baik
- Mudah untuk development paralel
- Reduced merge conflicts

### ✅ **Scalability**
- Mudah menambah feature baru
- Konsisten pattern di seluruh app
- Clean separation of concerns

### ✅ **Maintainability**
- Easy debugging dan testing
- Clear responsibility boundaries
- Reusable components

### ✅ **Team Collaboration**
- Clear ownership per feature
- Standardized structure
- Easy onboarding untuk developer baru

---

## 🎯 Naming Convention

### 📝 **File Naming**
- **Screens:** `login_screen.dart`, `home_screen.dart`
- **Widgets:** `custom_button.dart`, `search_bar.dart`
- **Models:** `user_model.dart`, `exercise_model.dart`
- **Services:** `auth_service.dart`, `api_service.dart`

### 📁 **Folder Naming**
- **Features:** `featureX/` (camelCase dengan prefix 'feature')
- **Layers:** `data/`, `domain/`, `presentation/`
- **Core:** `core/`, `shared/`, `router/`

### 🔗 **Export Files**
- **Pattern:** `feature_name_exports.dart`
- **Purpose:** Centralized exports untuk clean imports
- **Example:** `authentication.dart`, `profile_exports.dart`

---

## 🚀 Best Practices Implementation

### 🏗️ **Clean Architecture Benefits**
- **Separation of Concerns:** Each layer has specific responsibility
- **Dependency Inversion:** High-level modules don't depend on low-level modules
- **Testability:** Easy unit testing dengan clear boundaries
- **Flexibility:** Easy to change implementation tanpa affecting other layers

### 🔄 **Feature-First Approach**
- **Domain-Driven:** Features organized by business domain
- **Encapsulation:** Each feature is self-contained
- **Reusability:** Shared components di folder `shared/`
- **Scalability:** Easy to scale dengan menambah features

---

*Dokumentasi ini dibuat untuk memudahkan understanding dan maintenance proyek BeLing. Struktur ini memungkinkan development yang efficient dan code yang clean.*
