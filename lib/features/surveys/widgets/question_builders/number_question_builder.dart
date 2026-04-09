import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/hours_minutes_picker_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/single_hours_picker_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/single_minutes_picker_widget.dart';

class NumberQuestionBuilder extends ConsumerStatefulWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const NumberQuestionBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  ConsumerState<NumberQuestionBuilder> createState() =>
      _NumberQuestionBuilderState();
}

class _NumberQuestionBuilderState extends ConsumerState<NumberQuestionBuilder> {
  // Lokalne cache do przywracania godzin i minut po odznaczeniu "Nie wiem"
  List<int>? _hoursMinutesCache;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialText =
        ref
            .read(surveyProvider(widget.surveyId))
            .answers[widget.question.id]
            ?.toString() ??
        '';
    _controller = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surveyProvider(widget.surveyId));
    final notifier = ref.read(surveyProvider(widget.surveyId).notifier);
    final compositeType = widget.question.options?['composite'] as String?;

    // Check if this is a hours_minutes composite picker
    if (compositeType == 'hours_minutes') {
      final showDontKnow = widget.question.options?['showDontKnow'] == true;
      final dontKnowKey = '${widget.question.id}_dont_know';
      final dontKnowValue = state.answers[dontKnowKey] as bool? ?? false;
      final primary = Theme.of(context).colorScheme.primary;
      final progressColor = Theme.of(context).colorScheme.secondary;
      final selectedBg =
          Color.lerp(progressColor, Colors.white, 0.5) ??
          Theme.of(context).scaffoldBackgroundColor;

      final maxHours = widget.question.options?['maxHours'] as int? ?? 23;
      final maxMinutes = widget.question.options?['maxMinutes'] as int? ?? 59;
      final minMinutesIfZeroHours =
          widget.question.options?['minMinutesIfZeroHours'] as int? ?? 0;

      final defaultHours = widget.question.options?['defaultHours'] as int? ?? 0;
      final defaultMinutes =
          widget.question.options?['defaultMinutes'] as int? ??
          (defaultHours == 0 ? minMinutesIfZeroHours : 0);

      // Get hours and minutes from answers, with fallback to cache and defaults.
      final cached = _hoursMinutesCache;
      int hoursValue =
          state.answers['${widget.question.id}_hours'] as int? ??
          cached?[0] ??
          defaultHours;
      int minutesValue =
          state.answers['${widget.question.id}_minutes'] as int? ??
          cached?[1] ??
          defaultMinutes;

      // Jeśli 0 godzin – minimalnie minMinutesIfZeroHours minut (np. 10 dla aktywności fizycznej).
      if (hoursValue == 0 && minutesValue < minMinutesIfZeroHours) {
        minutesValue = minMinutesIfZeroHours;
      }

      // Initialize if not set – domyślnie wartości z konfiguracji pytania.
      if (!dontKnowValue) {
        if (!state.answers.containsKey('${widget.question.id}_hours')) {
          Future.microtask(
            () => notifier.updateAnswer('${widget.question.id}_hours', hoursValue),
          );
        }
        if (!state.answers.containsKey('${widget.question.id}_minutes')) {
          Future.microtask(
            () => notifier.updateAnswer(
              '${widget.question.id}_minutes',
              minutesValue,
            ),
          );
        }
      }

      return Column(
        children: [
          // Picker (znika, gdy zaznaczone \"Nie wiem\")
          if (!dontKnowValue)
            HoursMinutesPickerWidget(
              hours: hoursValue,
              minutes: minutesValue,
              maxHours: maxHours,
              maxMinutes: maxMinutes,
              minMinutesIfZeroHours: minMinutesIfZeroHours,
              openOnInit: !state.answers
                      .containsKey('${widget.question.id}_hours') &&
                  !state.answers
                      .containsKey('${widget.question.id}_minutes'),
              onChanged: (hours, minutes) {
                final h = hours ?? 0;
                final m = minutes ?? 0;
                _hoursMinutesCache = [h, m];
                Future.microtask(() {
                  notifier.updateAnswer('${widget.question.id}_hours', h);
                  notifier.updateAnswer('${widget.question.id}_minutes', m);
                  notifier.updateAnswer(widget.question.id, h * 60 + m);
                  if (showDontKnow) {
                    notifier.updateAnswer(dontKnowKey, false);
                  }
                });
              },
            ),
          if (!dontKnowValue) const SizedBox(height: 16),
          // "Nie wiem / Trudno powiedzieć" checkbox (pod pickerem)
          if (showDontKnow)
            GestureDetector(
              onTap: () {
                final newValue = !dontKnowValue;
                notifier.updateAnswer(dontKnowKey, newValue);

                _hoursMinutesCache = [hoursValue ?? 0, minutesValue ?? 0];

                if (newValue) {
                  notifier.removeAnswer('${widget.question.id}_hours');
                  notifier.removeAnswer('${widget.question.id}_minutes');
                  notifier.removeAnswer(widget.question.id);
                } else {
                  final restored = _hoursMinutesCache;
                  final h = restored?[0] ?? 0;
                  final m = restored?[1] ?? 0;
                  notifier.updateAnswer('${widget.question.id}_hours', h);
                  notifier.updateAnswer('${widget.question.id}_minutes', m);
                  notifier.updateAnswer(widget.question.id, h * 60 + m);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: dontKnowValue
                      ? selectedBg
                      : Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: primary, width: 2),
                  borderRadius: BorderRadius.zero,
                ),
                child: Row(
                  children: [
                    Icon(
                      dontKnowValue
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Nie wiem / Trudno powiedzieć',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    }

    // Check if this is a single hours picker
    if (compositeType == 'single_hours') {
      final maxHours = widget.question.options?['maxHours'] as int? ?? 23;
      final defaultHours = widget.question.options?['defaultHours'] as int? ?? 0;
      final hoursValue = state.answers[widget.question.id] as int? ?? defaultHours;

      // Initialize if not set
      if (!state.answers.containsKey(widget.question.id)) {
        Future.microtask(
          () => notifier.updateAnswer(widget.question.id, defaultHours),
        );
      }

      return SingleHoursPickerWidget(
        hours: hoursValue,
        maxHours: maxHours,
        onChanged: (hours) {
          notifier.updateAnswer(widget.question.id, hours ?? 0);
        },
      );
    }

    // Check if this is a single minutes picker
    if (compositeType == 'single_minutes') {
      final maxMinutes = widget.question.options?['maxMinutes'] as int? ?? 59;
      final defaultMinutes = widget.question.options?['defaultMinutes'] as int? ?? 0;
      final minutesValue = state.answers[widget.question.id] as int? ?? defaultMinutes;

      // Initialize if not set
      if (!state.answers.containsKey(widget.question.id)) {
        Future.microtask(
          () => notifier.updateAnswer(widget.question.id, defaultMinutes),
        );
      }

      return SingleMinutesPickerWidget(
        minutes: minutesValue,
        maxMinutes: maxMinutes,
        onChanged: (minutes) {
          notifier.updateAnswer(widget.question.id, minutes ?? 0);
        },
      );
    }

    // Regular number input
    final label = widget.question.options?['label'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            notifier.updateAnswer(
              widget.question.id,
              value.isEmpty ? null : int.tryParse(value),
            );
          },
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.question.options?['placeholder'] as String?,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
