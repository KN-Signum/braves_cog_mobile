# Braves Cog 

A modern Flutter application built with **Riverpod** state management, featuring authentication, theme management, and a multi-page navigation structure.

## 📱 Features

- ✅ **Authentication System** - Login/Register with mock service
- ✅ **Theme Management** - Light/Dark theme with persistent storage
- ✅ **Multi-Page Navigation** - 5 main sections with bottom navigation
- ✅ **Riverpod State Management** - Clean, scalable architecture
- ✅ **Responsive UI** - Material 3 design with Polish localization

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (^3.8.1 or higher)
- Dart SDK (^3.8.1 or higher)
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. **Clone the repository** (if applicable):
   ```bash
   cd /Users/adamgruda/Projects/braves_cog
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### Demo Credentials

For testing the authentication:
- **Email**: `test@example.com`
- **Password**: `password123`


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

## 🏗️ Architecture

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

#### 🔐 Authentication Flow
1. **Splash Screen** → Checks authentication status
2. **Auth Screen** → Login/Register with validation
3. **Main Screen** → Redirects after successful login

#### 🎨 Theme System
- Material 3 design
- Light and Dark themes
- Persistent storage with SharedPreferences
- Toggle from Profile screen

#### 🗂️ Navigation
5 main sections accessible via bottom navigation:
- **Menu** - main dashboard
- **Zdrowie** - Health tracking
- **Testy** - Tests and assessments
- **Gry** - Games and activities
- **Profil** - User profile and settings

## 📦 Dependencies

### Production
```yaml
dependencies:
  flutter_riverpod: ^2.5.1      # State management
  riverpod_annotation: ^2.3.5   # Riverpod annotations
  http: ^1.2.0                   # HTTP client
  shared_preferences: ^2.2.2     # Local storage
  flutter_svg: ^2.0.10           # SVG support (optional)
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

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Code Generation

If you use Riverpod code generation (future enhancement):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🎨 Customization

### Changing Theme Colors

Edit `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryColor = Color(0xFF1976D2);  // Change this
static const Color secondaryColor = Color(0xFF424242); // And this
```

### Adding New Pages

1. Create new screen in `lib/features/your_feature/`
2. Add to `MainScreen._pages` list
3. Add navigation item to `MainScreen._navItems`
4. Update `bottomNavIndexProvider` if needed

### Replacing Mock Auth with Real API

1. Update `lib/core/services/mock_auth_service.dart` with real API calls
2. Or create new service: `lib/core/services/auth_service.dart`
3. Update provider in `lib/core/providers/auth_provider.dart`

## 🐛 Troubleshooting

### Logo Not Showing
- Ensure PNG file exists: `assets/images/braves_logo.png`
- Run: `flutter clean && flutter pub get`
- Do a **full restart** (not hot reload)
- See: `TROUBLESHOOTING_LOGO.md` for details

### Build Errors
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

### Theme Not Persisting
- Check SharedPreferences permissions
- Clear app data and try again

### Authentication Not Working
- Using demo credentials? Check `mock_auth_service.dart`
- Check console for error messages

## 📄 License



## 👤 Author

Built with ❤️ for Braves Cog

**Last Updated**: November 12, 2025
