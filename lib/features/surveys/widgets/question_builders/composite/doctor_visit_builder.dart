import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/boolean_question_builder.dart';
import 'package:braves_cog/features/health/widgets/specialization_autocomplete.dart';

class DoctorVisitBuilder extends ConsumerWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const DoctorVisitBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider(surveyId));
    final notifier = ref.read(surveyProvider(surveyId).notifier);

    final doctorVisited = state.answers[question.id] as bool?;
    final specialization =
        state.answers['${question.id}_specialization'] as String?;
    final newDiagnosis = state.answers['${question.id}_new_diagnosis'] as bool?;
    final diagnosisDesc =
        state.answers['${question.id}_new_diagnosis_desc'] as String?;

    return Column(
      children: [
        BooleanQuestionBuilder(surveyId: surveyId, question: question),
        if (doctorVisited == true) ...[
          const SizedBox(height: 24),
          SpecializationAutocomplete(
            initialValue: specialization,
            onChanged: (value) {
              notifier.updateAnswer('${question.id}_specialization', value);
            },
            label: 'Specjalizacja lekarza',
            hint: 'np. Kardiolog, Dermatolog',
          ),
          const SizedBox(height: 24),
          Text(
            'Czy otrzymałeś nową diagnozę?',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    notifier.updateAnswer('${question.id}_new_diagnosis', true);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: newDiagnosis == true
                          ? (Color.lerp(
                                  Theme.of(context).colorScheme.secondary,
                                  Colors.white,
                                  0.5,
                                ) ??
                                Theme.of(context).scaffoldBackgroundColor)
                          : Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Text(
                      'Tak',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    notifier.updateAnswer(
                      '${question.id}_new_diagnosis',
                      false,
                    );
                    notifier.removeAnswer('${question.id}_new_diagnosis_desc');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: newDiagnosis == false
                          ? (Color.lerp(
                                  Theme.of(context).colorScheme.secondary,
                                  Colors.white,
                                  0.5,
                                ) ??
                                Theme.of(context).scaffoldBackgroundColor)
                          : Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Text(
                      'Nie',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (newDiagnosis == true) ...[
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: diagnosisDesc ?? ''),
              maxLines: 3,
              onChanged: (value) {
                notifier.updateAnswer(
                  '${question.id}_new_diagnosis_desc',
                  value,
                );
              },
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Jaka to była diagnoza?',
                hintText: 'Wpisz diagnozę',
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
        ],
      ],
    );
  }
}
