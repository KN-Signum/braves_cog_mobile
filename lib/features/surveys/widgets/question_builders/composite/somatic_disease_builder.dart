import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';

class SomaticDiseaseBuilder extends ConsumerWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const SomaticDiseaseBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider(surveyId));
    final notifier = ref.read(surveyProvider(surveyId).notifier);

    final enabledKey = '${question.id}_enabled';
    final dontKnowKey = '${question.id}_dont_know';
    final subtypesKey = '${question.id}_subtypes';
    final otherTextKey = '${question.id}_other_text';

    final enabled = (state.answers[enabledKey] as bool?) ?? false;
    final dontKnow = (state.answers[dontKnowKey] as bool?) ?? false;
    final selectedSubtypes = List<String>.from(
      state.answers[subtypesKey] as List<dynamic>? ?? const [],
    );

    final subtypes = (question.options?['subtypes'] as List<dynamic>? ?? [])
        .map<Map<String, dynamic>>((s) {
          if (s is Map) {
            return {
              'value': s['value'].toString(),
              'label': s['label'].toString(),
              'allowFreeText': s['allowFreeText'] == true,
            };
          }
          return {
            'value': s.toString(),
            'label': s.toString(),
            'allowFreeText': false,
          };
        })
        .toList();

    final diseaseLabel =
        question.options?['diseaseLabel'] as String? ?? question.question;
    final diseaseDescription =
        question.options?['diseaseDescription'] as String?;
    final hasDontKnow = question.options?['hasDontKnow'] == true;
    final rowKey = question.options?['rowKey'] as String?;

    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final selectedBg =
        Color.lerp(secondary, Colors.white, 0.5) ??
        Theme.of(context).scaffoldBackgroundColor;

    final otherTextInitial = state.answers[otherTextKey]?.toString() ?? '';
    final otherTextController = TextEditingController(text: otherTextInitial);

    // Special case: "Inne choroby somatyczne" - show text field directly when enabled
    if (rowKey == 'other') {
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
                  child: Text(
                    diseaseLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
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
                    Switch(
                      value: enabled,
                      onChanged: (value) {
                        notifier.updateAnswer(enabledKey, value);
                        if (value) {
                          // "Tak" – resetuj status "Nie wiem".
                          notifier.updateAnswer(dontKnowKey, false);
                          notifier.updateAnswer(question.id, 'yes');
                          notifier.updateAnswer('${question.id}_status', 'yes');
                        } else {
                          // "Nie" – brak choroby.
                          notifier.updateAnswer(question.id, 'no');
                          notifier.updateAnswer('${question.id}_status', 'no');
                          notifier.updateAnswer(otherTextKey, '');
                        }
                      },
                      thumbColor: WidgetStateProperty.resolveWith<Color?>((
                        states,
                      ) {
                        return primary;
                      }),
                      trackColor: WidgetStateProperty.resolveWith<Color?>((
                        states,
                      ) {
                        return Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest;
                      }),
                      trackOutlineColor:
                          WidgetStateProperty.resolveWith<Color?>((states) {
                            return primary;
                          }),
                    ),
                  ],
                ),
              ],
            ),
            if (hasDontKnow) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  final newValue = !dontKnow;
                  notifier.updateAnswer(dontKnowKey, newValue);
                  if (newValue) {
                    notifier.updateAnswer(enabledKey, false);
                    notifier.updateAnswer(question.id, 'dont_know');
                    notifier.updateAnswer('${question.id}_status', 'dont_know');
                    notifier.updateAnswer(otherTextKey, '');
                  } else {
                    notifier.removeAnswer(question.id);
                    notifier.removeAnswer('${question.id}_status');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: dontKnow
                        ? selectedBg
                        : Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: primary, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        dontKnow
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Nie wiem',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (enabled && !dontKnow) ...[
              const SizedBox(height: 16),
              TextField(
                controller: otherTextController,
                onChanged: (value) {
                  notifier.updateAnswer(otherTextKey, value);
                },
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Wpisz jakie...',
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: primary, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: primary, width: 2),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Regular somatic disease question
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
                      diseaseLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (diseaseDescription != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        diseaseDescription,
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
                  Switch(
                    value: enabled,
                    onChanged: (value) {
                      notifier.updateAnswer(enabledKey, value);
                      if (value) {
                        // "Tak" – resetuj status "Nie wiem".
                        notifier.updateAnswer(dontKnowKey, false);
                        notifier.updateAnswer(question.id, 'yes');
                        notifier.updateAnswer('${question.id}_status', 'yes');
                      } else {
                        // "Nie" – brak choroby.
                        notifier.updateAnswer(question.id, 'no');
                        notifier.updateAnswer('${question.id}_status', 'no');
                        notifier.updateAnswer(subtypesKey, []);
                      }
                    },
                    thumbColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      return primary;
                    }),
                    trackColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      return Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest;
                    }),
                    trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      return primary;
                    }),
                  ),
                ],
              ),
            ],
          ),
          if (hasDontKnow) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                final newValue = !dontKnow;
                notifier.updateAnswer(dontKnowKey, newValue);
                if (newValue) {
                  notifier.updateAnswer(enabledKey, false);
                  notifier.updateAnswer(question.id, 'dont_know');
                  notifier.updateAnswer('${question.id}_status', 'dont_know');
                  notifier.updateAnswer(subtypesKey, []);
                } else {
                  notifier.removeAnswer(question.id);
                  notifier.removeAnswer('${question.id}_status');
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: dontKnow
                      ? selectedBg
                      : Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: primary, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      dontKnow
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Nie wiem',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (enabled && !dontKnow) ...[
            const SizedBox(height: 16),
            Text(
              'Jakie?',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Column(
              children: subtypes.map((subtype) {
                final value = subtype['value'] as String;
                // Zmień "Inne (jakie?)" na "Inne"
                String label = subtype['label'] as String;
                if (label.contains('Inne (jakie?)')) {
                  label = 'Inne';
                }
                final allowFreeText = subtype['allowFreeText'] as bool;
                final isSelected = selectedSubtypes.contains(value);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final current = List<String>.from(selectedSubtypes);
                          if (current.contains(value)) {
                            current.remove(value);
                            if (allowFreeText) {
                              notifier.updateAnswer(otherTextKey, '');
                            }
                          } else {
                            current.add(value);
                          }
                          notifier.updateAnswer(subtypesKey, current);
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
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  label,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: primary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (allowFreeText && isSelected) ...[
                        const SizedBox(height: 8),
                        TextField(
                          controller: otherTextController,
                          onChanged: (value) {
                            notifier.updateAnswer(otherTextKey, value);
                          },
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Wpisz jakie...',
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).scaffoldBackgroundColor,
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: primary, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: primary, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ],
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
