import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:braves_cog/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:braves_cog/features/onboarding/domain/entities/consents_entity.dart';

class ConsentsScreen extends ConsumerStatefulWidget {
  const ConsentsScreen({super.key});

  @override
  ConsumerState<ConsentsScreen> createState() => _ConsentsScreenState();
}

class _ConsentsScreenState extends ConsumerState<ConsentsScreen> {
  int _currentStep = 0;
  final int _totalSteps = 3;

  final _stepTitles = [
    'Zgody na przetwarzanie danych',
    'Monitorowanie zdarzeń niepożądanych',
    'Powiadomienia',
  ];

  void _handleNext(ConsentsEntity consents) {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      ref.read(onboardingProvider.notifier).setStage(OnboardingStage.final_);
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _updateConsents(ConsentsEntity newConsents) {
    ref.read(onboardingProvider.notifier).updateConsents(newConsents);
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    final consents = onboardingState.consents;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  onPressed: _currentStep == 0 ? null : _handleBack,
                  icon: Icon(Icons.chevron_left, size: 24, color: Theme.of(context).colorScheme.primary),
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    minimumSize: const Size(44, 44),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Zgody',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.1,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (_currentStep + 1) / _totalSteps,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned.fill(
            top: 148,
            bottom: 100,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    _stepTitles[_currentStep],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildConsentsStepContent(consents),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () => _handleNext(consents),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep == _totalSteps - 1 ? 'Dalej' : 'Kontynuuj',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onPrimary,
                      letterSpacing: -0.072,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onPrimary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentsStepContent(ConsentsEntity consents) {
    switch (_currentStep) {
      case 0:
        return _buildSwitchTile(
          title: 'Wyrażam zgodę na przetwarzanie moich danych osobowych',
          description: 'Twoje dane są bezpieczne i wykorzystywane wyłącznie do celów badania.',
          value: consents.dataCollection,
          onChanged: (value) => _updateConsents(consents.copyWith(dataCollection: value)),
        );
      case 1:
        return Column(
          children: [
            _buildSwitchTile(
              title: 'Chcę otrzymywać pytania o zdarzenia niepożądane',
              description: 'Regularne monitorowanie Twojego samopoczucia podczas stosowania leków.',
              value: consents.wantsAdverseEventsMonitoring,
              onChanged: (value) => _updateConsents(consents.copyWith(wantsAdverseEventsMonitoring: value)),
            ),
          ],
        );
      case 2:
        return _buildSwitchTile(
          title: 'Zgoda na powiadomienia push',
          description: 'Powiadomienia o konieczności uzupełnienia dziennika lub przyjęcia leków.',
          value: consents.pushNotifications,
          onChanged: (value) => _updateConsents(consents.copyWith(pushNotifications: value)),
        );
      default:
        return Container();
    }
  }

  Widget _buildSwitchTile({
    required String title,
    required String description,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).colorScheme.secondary;
                  }
                  return null;
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
