import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';

class MultipleChoiceBuilder extends ConsumerWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const MultipleChoiceBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider(surveyId));
    final notifier = ref.read(surveyProvider(surveyId).notifier);

    final options = question.options?['options'] as List<dynamic>? ?? [];
    final selectedValues = (state.answers[question.id] as List<dynamic>?) ?? [];

    return Column(
      children: options.map<Widget>((option) {
        final optionValue = option is Map ? option['value'] : option;
        final optionLabel = option is Map ? option['label'] : option.toString();
        final isSelected = selectedValues.contains(optionValue);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              final newValues = List<dynamic>.from(selectedValues);
              if (isSelected) {
                newValues.remove(optionValue);
              } else {
                newValues.add(optionValue);
              }
              notifier.updateAnswer(question.id, newValues);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
                borderRadius: BorderRadius.zero,
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      optionLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
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
