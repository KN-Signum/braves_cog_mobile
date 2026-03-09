import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';

class TextQuestionBuilder extends ConsumerStatefulWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const TextQuestionBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  ConsumerState<TextQuestionBuilder> createState() =>
      _TextQuestionBuilderState();
}

class _TextQuestionBuilderState extends ConsumerState<TextQuestionBuilder> {
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
    final notifier = ref.read(surveyProvider(widget.surveyId).notifier);
    final isMultiline = widget.question.options?['multiline'] == true;

    return TextField(
      controller: _controller,
      maxLines: isMultiline ? 5 : 1,
      onChanged: (value) {
        notifier.updateAnswer(widget.question.id, value);
      },
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: widget.question.options?['placeholder'] as String?,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
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
    );
  }
}
