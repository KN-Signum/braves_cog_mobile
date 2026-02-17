# Braves Cog 

A Flutter application built with **Riverpod** state management, featuring authentication, theme management, and a multi-page navigation structure.

## Features

- **Authentication System** - Login/Register
- **Theme Management** - Different themes for specific groups of users for accessablity
- **Multi-Page Navigation** - 5 main sections with bottom navigation (Home, Lifestyle module, Cognitive games, Surveys and Profile settings)
- **Cognitive games** - used carp cognition package: https://pub.dev/packages/cognition_package
- **Riverpod State Management** - Clean, scalable architecture
- **Responsive UI** - Material 3 design

## Quick Start

### Prerequisites

- Flutter SDK (^3.8.1 or higher)
- Dart SDK (^3.8.1 or higher)
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. **Clone the repository**:

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure environment**:
   - Copy `env.example` → `.env`
   - Set `USE_MOCK_DATA=true` to use mock authentication / data sources

4. **Run the app**:
   ```bash
   flutter run
   ```

### Demo Credentials

For testing the authentication (mock mode):
- **Password**: `password`
- **Emails**:
  - `normalcog@test.pl`
  - `vascog@test.pl`
  - `neurocog@test.pl`
  - `covidcog@test.pl`
  - `scccog@test.pl`


## 📂 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_assets.dart           # Asset path constants
│   ├── models/
│   │   └── user.dart                 # User model with JSON serialization
│   ├── providers/
│   │   ├── auth_provider.dart        # Auth state management
│   │   └── theme_provider.dart       # Theme mode management
│   ├── services/
│   │   ├── api_client.dart           # HTTP client wrapper
│   │   └── mock_auth_service.dart    # Mock authentication service
│   ├── theme/
│   │   └── app_theme.dart            # Theme definitions (light & dark)
│   └── widgets/
│       └── braves_logo.dart          # Reusable logo widget
├── features/
│   ├── splash/
│   │   └── splash_screen.dart        # Splash screen with auth check
│   ├── auth/
│   │   └── auth_screen.dart          # Login/Register screen
│   ├── main/
│   │   └── main_screen.dart          # Main screen with bottom navigation
│   ├── menu/
│   │   └── menu_screen.dart          # Menu page
│   ├── health/
│   │   └── health_screen.dart       # Health page
│   ├── cognitive_tests/
│   │   └── cognitive_tests_screen.dart         # Tests page
│   ├── games/
│   │   └── games_screen.dart           # Games page
│   └── profile/
│       └── profile_screen.dart        # Profile page with settings
└── main.dart                          # App entry point

assets/
├── images/
│   ├── braves_logo.png               # App logo (PNG - 2048x2048)
│   └── braves_logo.svg               # App logo (SVG - source)
└── icons/
    └── (custom icons)
```

## Architecture

### State Management - Riverpod

The app uses **Riverpod** for state management with the following providers:

- **`authProvider`** - Manages authentication state (login, logout, session)
- **`themeModeProvider`** - Manages theme switching (light/dark)
- **`bottomNavIndexProvider`** - Manages bottom navigation state

### Core Services

1. **ApiClient** (`core/services/api_client.dart`)
   - HTTP methods: GET, POST, PUT, DELETE
   - JSON encoding/decoding
   - Error handling with custom exceptions
   - Ready for real API integration

2. **MockAuthService** (`core/services/mock_auth_service.dart`)
   - Simulates authentication flow
   - Network delay simulation
   - Demo user data
   - Easy to replace with real API

### Features

#### Authentication Flow
1. **Splash Screen** → Checks authentication status
2. **Auth Screen** → Login/Register with validation
3. **Main Screen** → Redirects after successful login

#### Theme System
- Material 3 design
- Light and Dark themes (for now)
- Persistent storage with SharedPreferences
- Toggle from Profile screen

#### 🗂️ Navigation
5 main sections accessible via bottom navigation:
- **Menu** - main dashboard
- **Health** - Health tracking
- **Tests** - Tests and assessments
- **Games** - Games and activities
- **Profile** - User profile and settings

## 📦 Dependencies

### Production
```yaml
dependencies:
  flutter_riverpod: ^2.5.1       # State management
  riverpod_annotation: ^2.3.5    # Riverpod annotations
  http: ^1.2.0                   # HTTP client
  shared_preferences: ^2.2.2     # Local storage
  flutter_svg: ^2.0.10           # SVG support (optional)
  cognition_package: ^1.7.0      # Ready cognitive games
```

### Development
```yaml
dev_dependencies:
  build_runner: ^2.4.8           # Code generation
  riverpod_generator: ^2.4.0     # Riverpod code generation
  mockito: ^5.4.4                # Mocking framework
  flutter_lints: ^5.0.0          # Linting rules
```

## 🔧 Development

### Running the App

```bash
# Development mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device_id>
```

### Building

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```
