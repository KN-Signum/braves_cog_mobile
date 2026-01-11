import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/login_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../home/home_screen.dart';
import '../health/health_module_screen.dart';
import '../psychological_tests/psychological_tests_screen.dart';
import '../profile/user_profile_screen.dart';

class MainScreenNew extends StatefulWidget {
  const MainScreenNew({Key? key}) : super(key: key);

  @override
  State<MainScreenNew> createState() => _MainScreenNewState();
}

class _MainScreenNewState extends State<MainScreenNew> {
  String _currentView = 'splash';
  bool _isLoading = true;

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
    setState(() => _currentView = 'home');
  }

  void _navigateToHome() {
    setState(() => _currentView = 'home');
  }

  void _navigateToProfile() {
    setState(() => _currentView = 'profile');
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
        backgroundColor: AppTheme.backgroundColor,
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
                color: AppTheme.accentColor,
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
        );
      
      case 'profile':
        return UserProfileScreen(onBack: _navigateToHome);
      
      case 'health':
        return HealthModuleScreen(onBack: _navigateToHome);
      
      case 'tests':
        return PsychologicalTestsScreen(onBack: _navigateToHome);
      
      case 'settings':
        return _buildSettingsScreen();
      
      default:
        return HomeScreen(
          onUserProfileClick: _navigateToProfile,
          onSettingsClick: _navigateToSettings,
          onHealthClick: _navigateToHealth,
          onTestsClick: _navigateToTests,
        );
    }
  }

  Widget _buildSettingsScreen() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: AppTheme.primaryColor, size: 28),
          onPressed: _navigateToHome,
        ),
        title: Text(
          'Ustawienia',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
              final prefs = await SharedPreferences.getInstance();
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
              style: GoogleFonts.inter(
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

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.lightBackgroundColor,
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
            color: AppTheme.accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.accentColor, size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor.withOpacity(0.6),
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: AppTheme.primaryColor, size: 24),
        onTap: onTap,
      ),
    );
  }
}

