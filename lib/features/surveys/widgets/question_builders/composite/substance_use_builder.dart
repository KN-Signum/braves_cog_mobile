import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';

class SubstanceUseBuilder extends ConsumerWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const SubstanceUseBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider(surveyId));
    final notifier = ref.read(surveyProvider(surveyId).notifier);

    final enabledKey = '${question.id}_enabled';
    final frequencyKey = '${question.id}_frequency';
    final enabled = (state.answers[enabledKey] as bool?) ?? false;
    final selectedFrequency = state.answers[frequencyKey] as String?;
    final frequencies =
        (question.options?['frequencies'] as List<dynamic>? ?? [])
            .map<Map<String, String>>((f) {
              if (f is Map) {
                return {
                  'value': f['value'].toString(),
                  'label': f['label'].toString(),
                };
              }
              return {'value': f.toString(), 'label': f.toString()};
            })
            .toList();

    final substanceLabel =
        question.options?['substanceLabel'] as String? ?? question.question;
    final substanceDescription =
        question.options?['substanceDescription'] as String?;

    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final selectedBg =
        Color.lerp(secondary, Colors.white, 0.5) ??
        Theme.of(context).scaffoldBackgroundColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      substanceLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (substanceDescription != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        substanceDescription,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF505968),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Nie    Tak',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: primary),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 28,
                    child: GestureDetector(
                      onTap: () {
                        final newValue = !enabled;
                        notifier.updateAnswer(enabledKey, newValue);
                        if (!newValue) {
                          notifier.updateAnswer(frequencyKey, '0');
                          notifier.updateAnswer(question.id, '0');
                        } else {
                          notifier.removeAnswer(frequencyKey);
                          notifier.removeAnswer(question.id);
                        }
                      },
                      child: Container(
                        width: 74,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: primary, width: 2),
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 150),
                          alignment: enabled
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: 16),
            Text(
              'Jak często?',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Column(
              children: frequencies.map((freq) {
                final value = freq['value']!;
                final label = freq['label']!;
                final isSelected = selectedFrequency == value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () {
                      notifier.updateAnswer(frequencyKey, value);
                      notifier.updateAnswer(question.id, value);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedBg
                            : Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.zero,
                        border: Border.all(color: primary, width: 2),
                      ),
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
