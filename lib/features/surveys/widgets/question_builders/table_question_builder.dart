import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/table_question_widget.dart';

class TableQuestionBuilder extends ConsumerWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const TableQuestionBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider(surveyId));
    final notifier = ref.read(surveyProvider(surveyId).notifier);

    final rows = question.options?['rows'] as List<dynamic>? ?? [];
    final columns = question.options?['columns'] as List<dynamic>? ?? [];
    final rowLabels = question.options?['rowLabels'] as Map<String, dynamic>?;
    final columnLabels =
        question.options?['columnLabels'] as Map<String, dynamic>?;
    final rowTooltips =
        question.options?['rowTooltips'] as Map<String, dynamic>?;

    final selectedValues = <String, String?>{};
    for (var row in rows) {
      final rowKey = row is Map ? row['value'] : row.toString();
      selectedValues[rowKey] =
          (state.answers['${question.id}_$rowKey'] as String?);
    }

    final processedRowLabels = rowLabels?.map((k, v) {
      final value = v.toString();
      final firstLine = value.contains('\n') ? value.split('\n').first : value;
      return MapEntry(k, firstLine);
    });

    return TableQuestionWidget(
      selectedValues: selectedValues,
      onChanged: (rowKey, columnKey) {
        notifier.updateAnswer('${question.id}_$rowKey', columnKey);
      },
      rows: rows
          .map<String>((r) => r is Map ? r['value'].toString() : r.toString())
          .toList(),
      columns: columns
          .map<String>((c) => c is Map ? c['value'].toString() : c.toString())
          .toList(),
      rowLabels: processedRowLabels,
      columnLabels: columnLabels?.map((k, v) => MapEntry(k, v.toString())),
      rowTooltips: rowTooltips?.map((k, v) => MapEntry(k, v.toString())),
    );
  }
}
