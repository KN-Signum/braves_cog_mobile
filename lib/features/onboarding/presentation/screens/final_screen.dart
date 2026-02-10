import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/features/onboarding/presentation/providers/onboarding_provider.dart';

class ConsentsIntroScreen extends ConsumerStatefulWidget {
  const ConsentsIntroScreen({super.key});

  @override
  ConsumerState<ConsentsIntroScreen> createState() => _ConsentsIntroScreenState();
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
        ref.read(onboardingProvider.notifier).setStage(OnboardingStage.consents);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Text(
          'Pora na twoje zgody',
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
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
  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      widget.onAnimationComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Text(
          'Witaj w aplikacji\nBRAVES-Cog',
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
            height: 1.27,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }
}
