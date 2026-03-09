import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';

class SomaticDiseaseBuilder extends ConsumerStatefulWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const SomaticDiseaseBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  ConsumerState<SomaticDiseaseBuilder> createState() =>
      _SomaticDiseaseBuilderState();
}

class _SomaticDiseaseBuilderState
    extends ConsumerState<SomaticDiseaseBuilder> {
  late final TextEditingController _otherTextController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(surveyProvider(widget.surveyId));
    final otherTextKey = '${widget.question.id}_other_text';
    final initialText = state.answers[otherTextKey]?.toString() ?? '';
    _otherTextController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _otherTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surveyProvider(widget.surveyId));
    final notifier =
        ref.read(surveyProvider(widget.surveyId).notifier);

    final enabledKey = '${widget.question.id}_enabled';
    final dontKnowKey = '${widget.question.id}_dont_know';
    final subtypesKey = '${widget.question.id}_subtypes';
    final otherTextKey = '${widget.question.id}_other_text';

    final enabled = (state.answers[enabledKey] as bool?) ?? false;
    final dontKnow = (state.answers[dontKnowKey] as bool?) ?? false;
    final selectedSubtypes = List<String>.from(
      state.answers[subtypesKey] as List<dynamic>? ?? const [],
    );

    final subtypes = (widget.question.options?['subtypes'] as List<dynamic>? ??
            [])
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

    final diseaseLabel = widget.question.options?['diseaseLabel'] as String? ??
        widget.question.question;
    final diseaseDescription =
        widget.question.options?['diseaseDescription'] as String?;
    final hasDontKnow = widget.question.options?['hasDontKnow'] == true;
    final rowKey = widget.question.options?['rowKey'] as String?;

    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final selectedBg =
        Color.lerp(secondary, Colors.white, 0.5) ??
        Theme.of(context).scaffoldBackgroundColor;

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
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 28,
                        child: GestureDetector(
                          onTap: () {
                            final newValue = !enabled;
                            notifier.updateAnswer(enabledKey, newValue);
                            if (newValue) {
                              // "Tak" – resetuj status "Nie wiem".
                              notifier.updateAnswer(dontKnowKey, false);
                              notifier.updateAnswer(widget.question.id, 'yes');
                              notifier.updateAnswer(
                                '${widget.question.id}_status',
                                'yes',
                              );
                            } else {
                              // "Nie" – brak choroby.
                              notifier.updateAnswer(widget.question.id, 'no');
                              notifier.updateAnswer(
                                '${widget.question.id}_status',
                                'no',
                              );
                              notifier.updateAnswer(otherTextKey, '');
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
            if (hasDontKnow) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  final newValue = !dontKnow;
                  notifier.updateAnswer(dontKnowKey, newValue);
                  if (newValue) {
                    notifier.updateAnswer(enabledKey, false);
                    notifier.updateAnswer(widget.question.id, 'dont_know');
                    notifier.updateAnswer(
                      '${widget.question.id}_status',
                      'dont_know',
                    );
                    notifier.updateAnswer(otherTextKey, '');
                  } else {
                    notifier.removeAnswer(widget.question.id);
                    notifier.removeAnswer('${widget.question.id}_status');
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
                controller: _otherTextController,
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
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 28,
                    child: GestureDetector(
                      onTap: () {
                        final newValue = !enabled;
                        notifier.updateAnswer(enabledKey, newValue);
                        if (newValue) {
                          // "Tak" – resetuj status "Nie wiem".
                          notifier.updateAnswer(dontKnowKey, false);
                          notifier.updateAnswer(widget.question.id, 'yes');
                          notifier.updateAnswer(
                            '${widget.question.id}_status',
                            'yes',
                          );
                        } else {
                          // "Nie" – brak choroby.
                          notifier.updateAnswer(widget.question.id, 'no');
                          notifier.updateAnswer(
                            '${widget.question.id}_status',
                            'no',
                          );
                          notifier.updateAnswer(subtypesKey, []);
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
          if (hasDontKnow) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                final newValue = !dontKnow;
                notifier.updateAnswer(dontKnowKey, newValue);
                if (newValue) {
                  notifier.updateAnswer(enabledKey, false);
                  notifier.updateAnswer(widget.question.id, 'dont_know');
                  notifier.updateAnswer(
                    '${widget.question.id}_status',
                    'dont_know',
                  );
                  notifier.updateAnswer(subtypesKey, []);
                } else {
                  notifier.removeAnswer(widget.question.id);
                  notifier.removeAnswer('${widget.question.id}_status');
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
                          controller: _otherTextController,
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
