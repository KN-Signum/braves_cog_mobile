import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:braves_cog/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:braves_cog/features/onboarding/presentation/screens/profile_form_screen.dart';
import 'package:braves_cog/features/onboarding/presentation/screens/consents_screen.dart';
import 'package:braves_cog/features/onboarding/presentation/screens/final_screen.dart';

class OnboardingScreen extends ConsumerWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);

    // Listen to changes to handle completion
    ref.listen(onboardingProvider, (previous, next) {
      if (next.stage == OnboardingStage.completed) {
        onComplete();
      }
      if (next.error != null && (previous?.error != next.error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    switch (state.stage) {
      case OnboardingStage.logo:
        // Trigger auto advance for logo
        Future.microtask(() {
           Future.delayed(const Duration(seconds: 2), () {
             ref.read(onboardingProvider.notifier).setStage(OnboardingStage.welcome);
           });
        });
        return const _LogoScreen();
      
      case OnboardingStage.welcome:
        return const WelcomeScreen();
      
      case OnboardingStage.intro:
        return const IntroScreen();
      
      case OnboardingStage.profile:
        return const ProfileFormScreen();
      
      case OnboardingStage.consentsIntro:
        return const ConsentsIntroScreen();
      
      case OnboardingStage.consents:
        return const ConsentsScreen();
      
      case OnboardingStage.final_:
        return FinalScreen(
          onAnimationComplete: () {
            ref.read(onboardingProvider.notifier).completeOnboarding();
          },
        );

      case OnboardingStage.completed:
        return const Scaffold(body: Center(child: CircularProgressIndicator())); // Should navigate away
    }
  }
}

class _LogoScreen extends StatelessWidget {
  const _LogoScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F0), // AppTheme.backgroundColor
      body: Center(
        child: Image.asset(
          'assets/images/braves_logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
