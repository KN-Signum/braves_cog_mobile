import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/time_picker_widget.dart';

class TimeQuestionBuilder extends ConsumerWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const TimeQuestionBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider(surveyId));
    final notifier = ref.read(surveyProvider(surveyId).notifier);

    final timeValue = state.answers[question.id];
    TimeOfDay? timeOfDay;

    if (timeValue != null) {
      if (timeValue is Map) {
        timeOfDay = TimeOfDay(
          hour: timeValue['hour'] ?? 0,
          minute: timeValue['minute'] ?? 0,
        );
      } else if (timeValue is String) {
        final parts = timeValue.split(':');
        if (parts.length == 2) {
          timeOfDay = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0,
          );
        }
      }
    }

    return TimePickerWidget(
      value: timeOfDay,
      onChanged: (time) {
        notifier.updateAnswer(question.id, {
          'hour': time.hour,
          'minute': time.minute,
        });
      },
      label: question.options?['label'] as String? ?? 'Wybierz godzinę',
    );
  }
}
