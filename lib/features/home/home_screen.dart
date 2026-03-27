import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_availability.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_completion_provider.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback onMonitoringClick;
  final VoidCallback onScreeningClick;
  final VoidCallback onFollowUpClick;
  final VoidCallback onTestsClick;

  const HomeScreen({
    super.key,
    required this.onMonitoringClick,
    required this.onScreeningClick,
    required this.onFollowUpClick,
    required this.onTestsClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final userType = profileState.profile.type.value;
    final monitoringAvailability = ref.watch(monitoringAvailabilityProvider);
    final screeningAvailability = ref.watch(screeningAvailabilityProvider);

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
                    Text(
                      'Witaj, jak się dzisiaj masz?',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingXl),
                    _buildMonitoringCard(context, monitoringAvailability),
                    SizedBox(height: AppTheme.spacingMd),
                    _buildScreeningCard(context, screeningAvailability),
                    SizedBox(height: AppTheme.spacingMd),
                    _buildFollowUpCard(context),
                    SizedBox(height: AppTheme.spacingXl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoringCard(
    BuildContext context,
    SurveyAvailability availability,
  ) {
    final locked = !availability.isAvailable;
    return GestureDetector(
      onTap: locked ? null : onMonitoringClick,
      child: Opacity(
        opacity: locked ? 0.45 : 1.0,
        child: Container(
          padding: EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monitoring',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    SizedBox(height: AppTheme.spacingSm),
                    Text(
                      locked
                          ? 'Następne: ${DateFormat('dd.MM.yyyy').format(availability.nextAvailableAt!)}'
                          : 'Codzienne sprawdzanie samopoczucia i stanu zdrowia',
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
                ),
                child: Icon(
                  Icons.monitor_heart,
                  size: 40,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreeningCard(
    BuildContext context,
    SurveyAvailability availability,
  ) {
    final locked = !availability.isAvailable;
    return GestureDetector(
      onTap: locked ? null : onScreeningClick,
      child: Opacity(
        opacity: locked ? 0.45 : 1.0,
        child: Container(
          padding: EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                : Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.1),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Screening',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    SizedBox(height: AppTheme.spacingSm),
                    Text(
                      locked
                          ? 'Następne: ${DateFormat('dd.MM.yyyy').format(availability.nextAvailableAt!)}'
                          : 'Szczegółowa ocena zdrowia, snu i samopoczucia',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.assessment,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFollowUpCard(BuildContext context) {
    return GestureDetector(
      onTap: onFollowUpClick,
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
              : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Follow-up',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Ankiety kontrolne: styl życia, sen, odżywianie, samopoczucie',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.fact_check_outlined,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
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
