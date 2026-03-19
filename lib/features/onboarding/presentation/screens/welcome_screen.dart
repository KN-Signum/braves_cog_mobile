import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/features/onboarding/presentation/providers/onboarding_provider.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Ten ekran nie jest już używany – nawigacja przechodzi bezpośrednio do IntroScreen.
    return const Scaffold(
      body: SizedBox.shrink(),
    );
  }
}

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  int _currentPage = 0;

  void _next(WidgetRef ref) {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
    } else {
      ref.read(onboardingProvider.notifier).setStage(OnboardingStage.profile);
    }
  }

  void _back() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = switch (_currentPage) {
      0 => 'Witaj w badaniu\nBRAVES Cog',
      1 => 'Czym jest sesja\nOnboarding?',
      _ => 'Przerwy i kolejne sesje',
    };

    final body = switch (_currentPage) {
      0 =>
          'Dziękujemy, że zdecydowałeś się wziąć udział w tym projekcie badawczym. '
          'Twoje odpowiedzi pozwolą nam lepiej zrozumieć związek między stylem życia, '
          'funkcjami poznawczymi i samopoczuciem psychicznym.',
      1 =>
          'Pierwsza sesja — Onboarding — obejmuje kilka kwestionariuszy dotyczących '
          'Twojej aktywności fizycznej, snu, diety, zdrowia oraz samopoczucia. '
          'Wypełnienie jej zajmie około 40–55 minut.',
      _ =>
          'Możesz robić przerwy i wracać do aplikacji w dowolnym momencie — '
          'Twoje odpowiedzi są zapisywane automatycznie.\n\n'
          'Kolejna pełna sesja tego rodzaju odbędzie się po 180 dniach.',
    };

    final primaryButtonLabel = _currentPage < 2 ? 'Kontynuuj' : 'Zaczynamy';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style:
                          theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentPage
                              ? AppTheme.primaryColor
                              : AppTheme.primaryColor.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _next(ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: AppTheme.inverseTextColor,
                      disabledBackgroundColor: AppTheme.primaryColor,
                      disabledForegroundColor: AppTheme.inverseTextColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          primaryButtonLabel,
                          style:
                              theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.inverseTextColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.arrow_forward,
                          color: AppTheme.inverseTextColor,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
