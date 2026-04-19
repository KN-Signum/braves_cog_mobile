import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/widgets/app_bottom_nav_bar.dart';
import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/features/auth/presentation/screens/login_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../home/home_screen.dart';
import '../health/health_module_screen.dart';
import '../surveys/widgets/universal_survey_widget.dart';
import '../surveys/widgets/screening_flow_widget.dart';
import '../surveys/widgets/follow_up_flow_widget.dart';
import '../surveys/config/survey_configs/monitoring_survey_config.dart';
import '../surveys/config/survey_schedule_config.dart';
import '../surveys/presentation/providers/survey_completion_provider.dart';
import '../profile/user_profile_screen.dart';
import '../cognitive_games/presentation/games_screen.dart';
import '../settings/settings_screen.dart';

class MainScreenNew extends ConsumerStatefulWidget {
  const MainScreenNew({super.key});

  @override
  ConsumerState<MainScreenNew> createState() => _MainScreenNewState();
}

class _MainScreenNewState extends ConsumerState<MainScreenNew> {
  String _currentView = 'home';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _handleLoginComplete() async {
    final authState = ref.read(authProvider);

    // After activation, user needs onboarding if requiresOnboarding is true
    if (authState.user?.requiresOnboarding ?? true) {
      setState(() => _currentView = 'onboarding');
    } else {
      // User is fully activated, go to home
      setState(() {
        _currentView = 'home';
        _currentIndex = 0;
      });
    }
  }

  void _handleBackFromOnboarding() {
    setState(() => _currentView = 'login');
  }

  void _handleOnboardingComplete() {
    // Onboarding includes the first monitoring session — seed the completion so
    // the monitoring card is locked for the next ~6 days.
    ref
        .read(surveyCompletionProvider.notifier)
        .recordCompletion(SurveyScheduleConfig.monitoring);
    // First screening should open 30 days after baseline onboarding.
    ref
        .read(surveyCompletionProvider.notifier)
        .recordCompletion(SurveyScheduleConfig.screening);
    // First follow-up should open 180 days after onboarding.
    ref
        .read(surveyCompletionProvider.notifier)
        .recordCompletion(SurveyScheduleConfig.followUp);
    // Refresh availability after recording completions
    ref.read(availabilityRefreshProvider.notifier).triggerRefresh();
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
          // Trigger refresh of availability when user navigates to home
          ref.read(availabilityRefreshProvider.notifier).triggerRefresh();
          break;
        case 1:
          _currentView = 'health';
          break;
        case 2:
          _currentView = 'games';
          break;
        case 3:
          _currentView = 'profile';
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
    // Trigger refresh of availability when returning home
    ref.read(availabilityRefreshProvider.notifier).triggerRefresh();
  }

  void _navigateToTests() {
    setState(() => _currentView = 'tests');
    // Tests doesn't have a bottom nav item, keep current index or deselect?
    // Keeping current index might be confusing if we show nav bar.
    // Let's assume Tests is a sub-screen of Home or standalone.
  }

  void _navigateToMonitoring() {
    setState(() {
      _currentView = 'monitoring';
      _currentIndex = 1; // Assuming health is index 1
    });
  }

  void _navigateToScreening() {
    setState(() {
      _currentView = 'screening';
      _currentIndex = 1;
    });
  }

  void _navigateToFollowUp() {
    setState(() {
      _currentView = 'followup';
      _currentIndex = 1;
    });
  }

  // Handlers for specific back navigations if needed, but generic to home is usually fine
  // for top level items, but if we are deep in stack...
  // Here we are doing flat navigation mostly.

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Show splash/loading while the silent re-auth check runs on app start.
    // isInitializing is true only during the very first checkAuthStatus() call.
    if (authState.isInitializing) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    }

    if (!authState.isAuthenticated) {
      return LoginScreen(onLogin: _handleLoginComplete);
    }

    if (authState.user!.requiresOnboarding) {
      return OnboardingScreen(
        onComplete: _handleOnboardingComplete,
        onBackToLogin: _handleBackFromOnboarding,
      );
    }

    // Check if we should show bottom nav.
    // We show it for: home, health, games, profile, settings.
    final bool showBottomNav = [
      'home',
      'health',
      'games',
      'profile',
      'settings',
    ].contains(_currentView);

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
          key: const ValueKey('home'),
          onMonitoringClick: _navigateToMonitoring,
          onScreeningClick: _navigateToScreening,
          onFollowUpClick: _navigateToFollowUp,
          onTestsClick: _navigateToTests,
        );
      case 'health':
        return HealthModuleScreen(
          key: const ValueKey('health'),
          onBack: _navigateToHome,
        );
      case 'monitoring':
        return UniversalSurveyWidget(
          key: const ValueKey('monitoring'),
          survey: MonitoringSurveyConfig.getSurvey(),
          onComplete: (answers, {isBackNavigation = false}) {
            if (!isBackNavigation) {
              ref
                  .read(surveyCompletionProvider.notifier)
                  .recordCompletion(SurveyScheduleConfig.monitoring);
              // Refresh availability after survey completion
              ref.read(availabilityRefreshProvider.notifier).triggerRefresh();
              _navigateToHome();
            }
          },
          onBack: _navigateToHome,
          startAtLastQuestion: false,
          showFinishLabel: true,
        );
      case 'screening':
        return ScreeningFlowWidget(
          key: const ValueKey('screening'),
          onComplete: (Map<String, dynamic> allAnswers) {
            ref
                .read(surveyCompletionProvider.notifier)
                .recordCompletion(SurveyScheduleConfig.screening);
            // Refresh availability after survey completion
            ref.read(availabilityRefreshProvider.notifier).triggerRefresh();
            _navigateToHome();
          },
          onBack: _navigateToHome,
        );
      case 'followup':
        return FollowUpFlowWidget(
          key: const ValueKey('followup'),
          onComplete: (Map<String, dynamic> allAnswers) {
            ref
                .read(surveyCompletionProvider.notifier)
                .recordCompletion(SurveyScheduleConfig.followUp);
            // Refresh availability after survey completion
            ref.read(availabilityRefreshProvider.notifier).triggerRefresh();
            _navigateToHome();
          },
          onBack: _navigateToHome,
        );
      case 'games':
        return GamesScreen(key: const ValueKey('games'));
      case 'profile':
        return UserProfileScreen(key: const ValueKey('profile'));
      case 'settings':
        return SettingsScreen(
          key: const ValueKey('settings'),
          onLogout: () {
            setState(() {
              _currentView = 'login';
              _currentIndex = 0;
            });
          },
        );
      default:
        return HomeScreen(
          key: const ValueKey('default_home'),
          onMonitoringClick: _navigateToMonitoring,
          onScreeningClick: _navigateToScreening,
          onFollowUpClick: _navigateToFollowUp,
          onTestsClick: _navigateToTests,
        );
    }
  }
}
