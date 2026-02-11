import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:braves_cog/core/widgets/app_bottom_nav_bar.dart';
import '../auth/login_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../home/home_screen.dart';
import '../health/health_module_screen.dart';
import '../psychological_tests/psychological_tests_screen.dart';
import '../profile/user_profile_screen.dart';
import '../games/games_screen.dart';
import '../settings/settings_screen.dart';

class MainScreenNew extends ConsumerStatefulWidget {
  const MainScreenNew({super.key});

  @override
  ConsumerState<MainScreenNew> createState() => _MainScreenNewState();
}

class _MainScreenNewState extends ConsumerState<MainScreenNew> {
  String _currentView = 'splash';
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    final isRegistered = prefs.getBool('user-registered') ?? false;
    final onboardingCompleted = prefs.getBool('onboarding-completed') ?? false;

    setState(() {
      _isLoading = false;
      if (!isRegistered) {
        _currentView = 'login';
      } else if (!onboardingCompleted) {
        _currentView = 'onboarding';
      } else {
        _currentView = 'home';
      }
    });
  }

  void _handleLoginComplete() {
    setState(() => _currentView = 'onboarding');
  }

  void _handleOnboardingComplete() {
    setState(() {
      _currentView = 'home';
      _currentIndex = 0;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          _currentView = 'home';
          break;
        case 1:
          _currentView = 'health';
          break;
        case 2:
          _currentView = 'games';
          break;
        case 3:
          _currentView = 'profile'; // Profile is index 3
          break;
        case 4:
          _currentView = 'settings';
          break;
      }
    });
  }
  
  void _navigateToHome() {
    setState(() {
      _currentView = 'home';
      _currentIndex = 0;
    });
  }

  void _navigateToHealth() {
    setState(() {
      _currentView = 'health';
      _currentIndex = 1;
    });
  }

  void _navigateToTests() {
    setState(() => _currentView = 'tests');
    // Tests doesn't have a bottom nav item, keep current index or deselect?
    // Keeping current index might be confusing if we show nav bar.
    // Let's assume Tests is a sub-screen of Home or standalone.
  }
  
  // Handlers for specific back navigations if needed, but generic to home is usually fine
  // for top level items, but if we are deep in stack...
  // Here we are doing flat navigation mostly.

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    }

    if (_currentView == 'login') {
      return LoginScreen(onLogin: _handleLoginComplete);
    }

    if (_currentView == 'onboarding') {
      return OnboardingScreen(onComplete: _handleOnboardingComplete);
    }
    
    // Check if we should show bottom nav.
    // We show it for: home, health, games, profile, settings.
    // What about tests? If tests is a full screen flow, maybe hide it?
    // User asked for bottom nav to be accessed from main health, home, games and settings.
    // Let's show it for all these "main" views.
    final bool showBottomNav = ['home', 'health', 'games', 'profile', 'settings'].contains(_currentView);

    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: showBottomNav 
          ? AppBottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onBottomNavTap,
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_currentView) {
      case 'home':
        return HomeScreen(
          onHealthClick: _navigateToHealth,
          onTestsClick: _navigateToTests,
        );
      case 'health':
        return HealthModuleScreen(onBack: _navigateToHome);
      case 'games':
        return GamesScreen(onBack: _navigateToHome);
      case 'profile':
        return UserProfileScreen(onBack: _navigateToHome);
      case 'settings':
        return SettingsScreen(
          onBack: _navigateToHome,
          onLogout: () {
            setState(() {
              _currentView = 'login';
              _currentIndex = 0;
            });
          },
        );
      case 'tests':
        return PsychologicalTestsScreen(onBack: _navigateToHome);
      default:
        // Fallback to home
        return HomeScreen(
          onHealthClick: _navigateToHealth,
          onTestsClick: _navigateToTests,
        );
    }
  }
}
