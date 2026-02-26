import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/core/services/medication_api_service.dart';
import 'package:braves_cog/features/onboarding/widgets/medication_autocomplete.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/boolean_question_builder.dart';

class MedicationsBuilder extends ConsumerStatefulWidget {
  final String surveyId;
  final SurveyQuestionEntity question;

  const MedicationsBuilder({
    super.key,
    required this.surveyId,
    required this.question,
  });

  @override
  ConsumerState<MedicationsBuilder> createState() => _MedicationsBuilderState();
}

class _MedicationsBuilderState extends ConsumerState<MedicationsBuilder> {
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, List<String>> _medicationStrengthsCache = {};
  late final MedicationApiService _medicationApiService;

  @override
  void initState() {
    super.initState();
    _medicationApiService = MedicationApiService();
  }

  @override
  void dispose() {
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getTextController(String key, String initialText) {
    if (!_textControllers.containsKey(key)) {
      _textControllers[key] = TextEditingController(text: initialText);
    } else if (_textControllers[key]!.text != initialText &&
        !_textControllers[key]!.value.selection.isValid) {
      // Only update text if the user is not actively typing (no selection)
      // This is a naive check. A better approach is to not overwrite text if it's currently focused.
      // But for simple builders, this is often okay if external changes rarely happen.
      _textControllers[key]!.text = initialText;
    }
    return _textControllers[key]!;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surveyProvider(widget.surveyId));
    final notifier = ref.read(surveyProvider(widget.surveyId).notifier);
    final question = widget.question;

    final medsChanged = state.answers[question.id] as bool?;
    final medications =
        (state.answers['${question.id}_medications'] as List<dynamic>?) ?? [];

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    return Column(
      children: [
        BooleanQuestionBuilder(surveyId: widget.surveyId, question: question),
        if (medsChanged == true) ...[
          const SizedBox(height: 24),
          ...medications.asMap().entries.map((entry) {
            final index = entry.key;
            final med = entry.value as Map<String, dynamic>;
            final name = (med['name'] as String?) ?? '';
            final dose = med['dose'] as String? ?? med['dosage']?.toString();
            final doseDontKnow = med['doseDontKnow'] as bool? ?? false;
            final manual = med['manual'] as bool? ?? false;
            final selectedStrength = med['selectedStrength'] as String?;

            // Wczytaj z cache listę dawek dla danego leku (tylko w trybie automatycznym).
            final strengths = manual
                ? const <String>[]
                : _medicationStrengthsCache[name] ?? const <String>[];
            final hasStrengths = strengths.isNotEmpty;

            // Jeśli mamy nazwę leku, a nie ma jeszcze dawek w cache,
            // dociągnij je asynchronicznie z serwisu na podstawie pliku JSON.
            if (name.isNotEmpty &&
                !manual &&
                !_medicationStrengthsCache.containsKey(name)) {
              _medicationApiService.getStrengthsFor(name).then((values) {
                if (!mounted) return;
                setState(() {
                  _medicationStrengthsCache[name] = values;
                });
              });
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: primary, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tryb automatyczny – wybór z listy leków
                    if (!manual) ...[
                      MedicationAutocomplete(
                        key: ValueKey('med_${question.id}_$index'),
                        initialValue: name.isEmpty ? null : name,
                        onChanged: (value) {
                          final newMeds = List<Map<String, dynamic>>.from(
                            medications,
                          );
                          newMeds[index]['name'] = value;
                          // resetuj dawkę przy zmianie leku
                          newMeds[index]['dose'] = null;
                          newMeds[index]['dosage'] = null;
                          newMeds[index]['doseDontKnow'] = false;
                          newMeds[index]['selectedStrength'] = null;
                          newMeds[index]['manual'] = false;
                          notifier.updateAnswer(
                            '${question.id}_medications',
                            newMeds,
                          );

                          // Po wybraniu leku dociągnij listę dawek.
                          _medicationApiService.getStrengthsFor(value).then((
                            values,
                          ) {
                            if (!mounted) return;
                            setState(() {
                              _medicationStrengthsCache[value] = values;
                            });
                          });
                        },
                        label: 'Lek ${index + 1}',
                        hint: 'Wpisz nazwę leku',
                      ),
                      const SizedBox(height: 12),
                    ] else ...[
                      // Tryb ręczny – użytkownik sam wpisuje nazwę leku.
                      Text(
                        'Nazwa leku',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _getTextController(
                          'med_${question.id}_${index}_name_manual',
                          name,
                        ),
                        onChanged: (value) {
                          final newMeds = List<Map<String, dynamic>>.from(
                            medications,
                          );
                          newMeds[index]['name'] = value;
                          notifier.updateAnswer(
                            '${question.id}_medications',
                            newMeds,
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Wpisz nazwę leku',
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: primary, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: primary, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: primary, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Dawka leku
                    Text(
                      'Dawka',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),

                    if (!manual && hasStrengths && !doseDontKnow) ...[
                      Column(
                        children: [
                          ...strengths.map((s) {
                            final isSelected = selectedStrength == s;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GestureDetector(
                                onTap: () {
                                  final newMeds =
                                      List<Map<String, dynamic>>.from(
                                        medications,
                                      );
                                  newMeds[index]['selectedStrength'] = s;
                                  newMeds[index]['dose'] = s;
                                  newMeds[index]['dosage'] = s;
                                  notifier.updateAnswer(
                                    '${question.id}_medications',
                                    newMeds,
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (Color.lerp(
                                                secondary,
                                                Colors.white,
                                                0.7,
                                              ) ??
                                              theme.scaffoldBackgroundColor)
                                        : theme.scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.zero,
                                    border: Border.all(
                                      color: primary,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    s,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          // Opcja "Inna" -> wolny tekst.
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                              onTap: () {
                                final newMeds = List<Map<String, dynamic>>.from(
                                  medications,
                                );
                                newMeds[index]['selectedStrength'] = '_other';
                                // Nie nadpisujemy od razu dawki – użytkownik wpisze niżej.
                                notifier.updateAnswer(
                                  '${question.id}_medications',
                                  newMeds,
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedStrength == '_other'
                                      ? (Color.lerp(
                                              secondary,
                                              Colors.white,
                                              0.7,
                                            ) ??
                                            theme.scaffoldBackgroundColor)
                                      : theme.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.zero,
                                  border: Border.all(color: primary, width: 2),
                                ),
                                child: Text(
                                  'Inna',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (selectedStrength == '_other') ...[
                            TextField(
                              controller: _getTextController(
                                'med_${question.id}_${index}_dose_other',
                                dose ?? '',
                              ),
                              onChanged: (value) {
                                final newMeds = List<Map<String, dynamic>>.from(
                                  medications,
                                );
                                newMeds[index]['dose'] = value;
                                newMeds[index]['dosage'] = value;
                                notifier.updateAnswer(
                                  '${question.id}_medications',
                                  newMeds,
                                );
                              },
                              decoration: InputDecoration(
                                hintText: 'np. 10 mg, 2x dziennie',
                                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: primary.withValues(alpha: 0.5),
                                ),
                                filled: true,
                                fillColor: theme.scaffoldBackgroundColor,
                                contentPadding: const EdgeInsets.all(16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                    color: primary,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                    color: primary,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                    color: primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ] else ...[
                      // Brak listy dawek albo tryb ręczny – zwykłe pole tekstowe.
                      TextField(
                        controller: _getTextController(
                          'med_${question.id}_${index}_dose_manual',
                          dose ?? '',
                        ),
                        enabled: !doseDontKnow,
                        onChanged: (value) {
                          final newMeds = List<Map<String, dynamic>>.from(
                            medications,
                          );
                          newMeds[index]['dose'] = value;
                          newMeds[index]['dosage'] = value;
                          notifier.updateAnswer(
                            '${question.id}_medications',
                            newMeds,
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'np. 10 mg, 2x dziennie',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: primary.withValues(alpha: 0.5),
                          ),
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: primary, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
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

                    if (!manual) ...[
                      const SizedBox(height: 8),
                      // "Nie wiem" dla dawki – tylko w trybie automatycznym.
                      GestureDetector(
                        onTap: () {
                          final newMeds = List<Map<String, dynamic>>.from(
                            medications,
                          );
                          final newValue = !doseDontKnow;
                          newMeds[index]['doseDontKnow'] = newValue;
                          if (newValue) {
                            newMeds[index]['dose'] = null;
                            newMeds[index]['dosage'] = null;
                          }
                          notifier.updateAnswer(
                            '${question.id}_medications',
                            newMeds,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: doseDontKnow
                                ? Color.lerp(secondary, Colors.white, 0.5) ??
                                      theme.scaffoldBackgroundColor
                                : theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.zero,
                            border: Border.all(color: primary, width: 2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                doseDontKnow
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Nie wiem',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),
                    // Fallback: użytkownik nie znalazł leku na liście.
                    GestureDetector(
                      onTap: () {
                        final newMeds = List<Map<String, dynamic>>.from(
                          medications,
                        );
                        final newManual = !manual;
                        newMeds[index]['manual'] = newManual;
                        if (newManual) {
                          // Czyścimy dawkę i znacznik "Nie wiem".
                          newMeds[index]['dose'] = null;
                          newMeds[index]['dosage'] = null;
                          newMeds[index]['doseDontKnow'] = false;
                          newMeds[index]['selectedStrength'] = null;
                        }
                        notifier.updateAnswer(
                          '${question.id}_medications',
                          newMeds,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.zero,
                          border: Border.all(color: primary, width: 2),
                        ),
                        child: Text(
                          'Nie znalazłem mojego leku wśród proponowanych',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                      ),
                    ),

                    if (medications.length > 1) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            final newMeds = List<Map<String, dynamic>>.from(
                              medications,
                            );
                            newMeds.removeAt(index);
                            notifier.updateAnswer(
                              '${question.id}_medications',
                              newMeds,
                            );
                          },
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.red[400],
                          ),
                          style: IconButton.styleFrom(
                            minimumSize: const Size(44, 44),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              final newMeds = List<Map<String, dynamic>>.from(medications);
              newMeds.add({
                'name': '',
                'dose': null,
                'dosage': null,
                'doseDontKnow': false,
              });
              notifier.updateAnswer('${question.id}_medications', newMeds);
            },
            icon: const Icon(Icons.add),
            label: Text(
              medications.isEmpty ? 'Dodaj lek' : 'Dodaj kolejny lek',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.inverseTextColor,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.inverseTextColor,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              elevation: 0,
            ),
          ),
          if (medications.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Kliknij przycisk aby dodać lek',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.6),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
