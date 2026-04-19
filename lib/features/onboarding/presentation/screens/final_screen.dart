import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:braves_cog/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:braves_cog/features/cognitive_games/presentation/cognitive_games_launcher.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_completion_provider.dart';

class ConsentsIntroScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBackToLogin;

  const ConsentsIntroScreen({super.key, this.onBackToLogin});

  @override
  ConsumerState<ConsentsIntroScreen> createState() =>
      _ConsentsIntroScreenState();
}

// ─── Result type for structured game session feedback ───
class GameSessionResult {
  final bool success;
  final String? errorMessage;
  final int savedCount;

  const GameSessionResult({
    required this.success,
    this.errorMessage,
    this.savedCount = 0,
  });
}

class _ConsentsIntroScreenState extends ConsumerState<ConsentsIntroScreen> {
  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ref
            .read(onboardingProvider.notifier)
            .setStage(OnboardingStage.consents);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Text(
          'Pora na twoje zgody',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.33,
            letterSpacing: -0.24,
          ),
        ),
      ),
    );
  }
}

class FinalScreen extends ConsumerStatefulWidget {
  final VoidCallback onAnimationComplete;

  const FinalScreen({super.key, required this.onAnimationComplete});

  @override
  ConsumerState<FinalScreen> createState() => _FinalScreenState();
}

class _FinalScreenState extends ConsumerState<FinalScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  void _handleStartGames() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Launch the cognitive games sequence with structured result
    CognitiveGamesLauncher.launchFullSequenceWithFeedback(
      context: context,
      ref: ref,
      onSuccess: () {
        if (!mounted) return;
        // Trigger availability refresh after cognitive games complete
        ref.read(availabilityRefreshProvider.notifier).triggerRefresh();
        // Auto-proceed after 1-2 second delay
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            widget.onAnimationComplete();
          }
        });
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 80,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Gratulacje!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Udało Ci się przejść przez onboarding! Teraz pora na pierwszą sesję gier poznawczych. Przygotuj sobie na nie ok. 10 minut. Jeśli potrzebujesz przerwy, to teraz jest to dobry moment.',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Loading indicator
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        height: 24,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Przygotowuję sesję...',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Error message
                  if (_errorMessage != null && !_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Błąd podczas sesji',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Time estimate (always show)
                  if (!_isLoading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 20,
                          color: Color(0xFF0F2847),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Szacowany czas: ~10 minut',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F2847),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  // Main button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleStartGames,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading
                          ? Theme.of(
                              context,
                            ).colorScheme.secondary.withOpacity(0.6)
                          : Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 0,
                      disabledBackgroundColor: Theme.of(
                        context,
                      ).colorScheme.secondary.withOpacity(0.6),
                    ),
                    child: Text(
                      _errorMessage != null && !_isLoading
                          ? 'SPRÓBUJ PONOWNIE'
                          : 'ROZPOCZNIJ SESJĘ GIER',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
