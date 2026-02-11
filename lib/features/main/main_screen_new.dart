import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/core/providers/theme_provider.dart';
import '../auth/login_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../home/home_screen.dart';
import '../health/health_module_screen.dart';
import '../psychological_tests/psychological_tests_screen.dart';
import '../profile/user_profile_screen.dart';
import '../games/games_screen.dart';

class MainScreenNew extends ConsumerStatefulWidget {
  const MainScreenNew({super.key});

  @override
  ConsumerState<MainScreenNew> createState() => _MainScreenNewState();
}

class _MainScreenNewState extends ConsumerState<MainScreenNew> {
  String _currentView = 'splash';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // We can use the provider, but initializing shared prefs is async anyway so using instance is fine here too
    // But consistent usage is better.
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
    setState(() => _currentView = 'home');
  }

  void _navigateToHome() {
    setState(() => _currentView = 'home');
  }

  void _navigateToProfile() {
    setState(() => _currentView = 'profile');
  }

  void _navigateToGames() {
    setState(() => _currentView = 'games');
  }

  void _navigateToHealth() {
    setState(() => _currentView = 'health');
  }

  void _navigateToTests() {
    setState(() => _currentView = 'tests');
  }

  void _navigateToSettings() {
    setState(() => _currentView = 'settings');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/braves_logo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 32),
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      );
    }

    switch (_currentView) {
      case 'login':
        return LoginScreen(onLogin: _handleLoginComplete);

      case 'onboarding':
        return OnboardingScreen(onComplete: _handleOnboardingComplete);

      case 'home':
        return HomeScreen(
          onUserProfileClick: _navigateToProfile,
          onSettingsClick: _navigateToSettings,
          onHealthClick: _navigateToHealth,
          onTestsClick: _navigateToTests,
          onGamesClick: _navigateToGames,
        );

      case 'profile':
        return UserProfileScreen(onBack: _navigateToHome);

      case 'health':
        return HealthModuleScreen(onBack: _navigateToHome);

      case 'tests':
        return PsychologicalTestsScreen(onBack: _navigateToHome);

      case 'games':
        return GamesScreen(onBack: _navigateToHome);

      case 'settings':
        return _buildSettingsScreen();

      default:
        return HomeScreen(
          onUserProfileClick: _navigateToProfile,
          onSettingsClick: _navigateToSettings,
          onHealthClick: _navigateToHealth,
          onTestsClick: _navigateToTests,
          onGamesClick: _navigateToGames,
        );
    }
  }

  Widget _buildSettingsScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          onPressed: _navigateToHome,
        ),
        title: Text(
          'Ustawienia',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildThemeSwitchTile(),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Powiadomienia',
            subtitle: 'Zarządzaj powiadomieniami',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip,
            title: 'Prywatność',
            subtitle: 'Zarządzaj danymi osobowymi',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.info,
            title: 'O aplikacji',
            subtitle: 'Wersja 1.0.0',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              // Also clear other prefs if needed, but auth provider clears user info
              final prefs = await SharedPreferences.getInstance();
              // We might NOT want to clear EVERYTHING like onboarding status on logout?
              // The original code did `await prefs.clear()`.
              // If we clear everything, we reset onboarding too.
              // Assuming this is desired behavior for full reset.
              await prefs.clear();

              setState(() => _currentView = 'login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Wyloguj się',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSwitchTile() {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minVerticalPadding: 16,
        leading: Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: Theme.of(context).colorScheme.secondary,
            size: 24,
          ),
        ),
        title: Text(
          'Motyw',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          isDarkMode ? 'Ciemny' : 'Jasny',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
          ),
        ),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (value) {
            ref.read(themeModeProvider.notifier).toggleTheme();
          },
          activeColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minVerticalPadding: 16,
        leading: Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        onTap: onTap,
      ),
    );
  }
}
