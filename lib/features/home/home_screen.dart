import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback onHealthClick;
  final VoidCallback onTestsClick;

  const HomeScreen({
    super.key,
    required this.onHealthClick,
    required this.onTestsClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final userType = profileState.profile.type.value;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.displaySmall,
                        children: [
                          const TextSpan(text: 'Witaj z powrotem,\n'),
                          TextSpan(
                            text: userType,
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const TextSpan(text: '!'),
                        ],
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingXl),

                    // Feeling Section
                    Text(
                      'Jak się dzisiaj czujesz?',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: AppTheme.spacingMd),

                    // Health Survey Button
                    _buildHealthSurveyCard(context),
                    SizedBox(height: AppTheme.spacingXl),

                    // Psychological Tests Section
                    Text(
                      'Testy psychologiczne',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: AppTheme.spacingMd),

                    _buildTestCard(
                      context,
                      title: 'Testy jednorazowe',
                      description:
                          'Badanie jednorazowe oceniające aktualny stan',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.15)
                          : Theme.of(
                              context,
                            ).colorScheme.secondary.withValues(alpha: 0.1),
                      iconColor: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      icon: Icons.psychology,
                    ),
                    SizedBox(height: AppTheme.spacingMd),

                    _buildTestCard(
                      context,
                      title: 'Testy wielokrotne',
                      description: 'Monitorowanie postępów w czasie',
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      iconColor: Theme.of(context).colorScheme.primary,
                      icon: Icons.assignment,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSurveyCard(BuildContext context) {
    return GestureDetector(
      onTap: onHealthClick,
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          // borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wypełnij ankietę',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Sprawdź swoje zdrowie i samopoczucie',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                // borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
              ),
              child: Icon(
                Icons.fitness_center,
                size: 40,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard(
    BuildContext context, {
    required String title,
    required String description,
    required Color color,
    required Color iconColor,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTestsClick,
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: color,
          // borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
          border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingSm),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: AppTheme.spacingMd),
                  Row(
                    children: [
                      Text(
                        'Rozpocznij',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: iconColor),
                      ),
                      SizedBox(width: AppTheme.spacingSm),
                      Icon(Icons.arrow_forward, color: iconColor, size: 20),
                    ],
                  ),
                ],
              ),
            ),
            Icon(icon, size: 60, color: iconColor),
          ],
        ),
      ),
    );
  }
}
