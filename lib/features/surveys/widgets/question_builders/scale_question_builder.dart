import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/segment_scale_question_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/slider_widget.dart';

class ScaleQuestionBuilder extends ConsumerWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const ScaleQuestionBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider(surveyId));
    final notifier = ref.read(surveyProvider(surveyId).notifier);

    final min = (question.options?['min'] as num?)?.toDouble() ?? 0.0;
    final max = (question.options?['max'] as num?)?.toDouble() ?? 100.0;
    final step = (question.options?['step'] as num?)?.toDouble();
    final unit = question.options?['unit'] as String?;
    final segmentScale = question.options?['segmentScale'] == true;
    final showMarkers = question.options?['showMarkers'] == true;

    final currentValue =
        (state.answers[question.id] as num?)?.toDouble() ??
        (segmentScale ? 0.0 : min);

    if (segmentScale) {
      return SegmentScaleQuestionWidget(
        value: currentValue.toInt(),
        onChanged: (value) {
          notifier.updateAnswer(question.id, value);
        },
        minLabel: question.options?['minLabel'] as String?,
        maxLabel: question.options?['maxLabel'] as String?,
        reversed: question.options?['reversed'] == true,
      );
    }

    final valueLabels =
        question.options?['valueLabels'] as Map<String, dynamic>?;
    final valueLabelsMap = valueLabels?.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );

    return SliderQuestionWidget(
      value: currentValue,
      onChanged: (value) {
        notifier.updateAnswer(question.id, value);
      },
      min: min,
      max: max,
      step: step,
      unit: unit,
      label: question.options?['label'] as String?,
      startColor: question.options?['startColor'] != null
          ? Color(question.options!['startColor'] as int)
          : null,
      endColor: question.options?['endColor'] != null
          ? Color(question.options!['endColor'] as int)
          : null,
      minLabel: question.options?['minLabel'] as String?,
      maxLabel: question.options?['maxLabel'] as String?,
      showMarkers: showMarkers,
      valueLabels: valueLabelsMap,
    );
  }
}
