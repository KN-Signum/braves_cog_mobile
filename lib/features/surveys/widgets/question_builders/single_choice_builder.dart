import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';

class SingleChoiceBuilder extends ConsumerWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const SingleChoiceBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider(surveyId));
    final notifier = ref.read(surveyProvider(surveyId).notifier);

    final options = question.options?['options'] as List<dynamic>? ?? [];
    final selectedValue = state.answers[question.id];

    return Column(
      children: options.map<Widget>((option) {
        final optionValue = option is Map ? option['value'] : option;
        final optionLabel = option is Map ? option['label'] : option.toString();
        final isSelected = selectedValue == optionValue;
        final theme = Theme.of(context);
        final progressColor = theme.colorScheme.secondary;
        // Zmieszane tło
        final selectedBackground = Color.lerp(
          progressColor,
          Colors.white,
          0.5,
        )!;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              notifier.updateAnswer(question.id, optionValue);
              // Phq-9 check
              if (question.id.startsWith('phq9_') &&
                  question.id != 'phq9_difficulty') {
                final symptomIds = [
                  'phq9_1',
                  'phq9_2',
                  'phq9_3',
                  'phq9_4',
                  'phq9_5',
                  'phq9_6',
                  'phq9_7',
                  'phq9_8',
                  'phq9_9',
                ];
                bool anyPositive = false;
                for (final id in symptomIds) {
                  final v = id == question.id ? optionValue : state.answers[id];
                  if (v is num && v > 0) {
                    anyPositive = true;
                    break;
                  }
                }
                notifier.updateAnswer('phq9_any_positive', anyPositive);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected
                    ? selectedBackground
                    : theme.colorScheme.surface,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  width: 2,
                ),
                borderRadius: BorderRadius.zero,
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                        width: 2,
                      ),
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      optionLabel,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
