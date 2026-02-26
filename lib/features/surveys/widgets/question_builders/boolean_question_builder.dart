import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';

class BooleanQuestionBuilder extends ConsumerWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const BooleanQuestionBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider(surveyId));
    final notifier = ref.read(surveyProvider(surveyId).notifier);

    final selectedValue = state.answers[question.id] as bool?;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    // Kolor z paska postępu zmieszany w 50% z białym
    final selectedBackground =
        Color.lerp(secondary, Colors.white, 0.5) ??
        Theme.of(context).scaffoldBackgroundColor;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              notifier.updateAnswer(question.id, true);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selectedValue == true
                    ? selectedBackground
                    : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: primary, width: 2),
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                'Tak',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              notifier.updateAnswer(question.id, false);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selectedValue == false
                    ? selectedBackground
                    : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: primary, width: 2),
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                'Nie',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
