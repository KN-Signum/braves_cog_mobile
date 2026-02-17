import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/surveys/utils/gender_form_helper.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:braves_cog/features/onboarding/widgets/medication_autocomplete.dart';
import 'package:braves_cog/features/health/widgets/specialization_autocomplete.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/time_picker_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/slider_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/table_question_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/segment_scale_question_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class UniversalSurveyWidget extends ConsumerStatefulWidget {
  final SurveyEntity survey;
  final Function(Map<String, dynamic>) onComplete;
  final VoidCallback onBack;

  const UniversalSurveyWidget({
    super.key,
    required this.survey,
    required this.onComplete,
    required this.onBack,
  });

  @override
  ConsumerState<UniversalSurveyWidget> createState() => _UniversalSurveyWidgetState();
}

class _UniversalSurveyWidgetState extends ConsumerState<UniversalSurveyWidget> {
  final Map<String, dynamic> _answers = {};
  int _currentStep = 0;
  String? _lastSurveyId;

  @override
  void initState() {
    super.initState();
    _lastSurveyId = widget.survey.id;
  }

  @override
  void didUpdateWidget(UniversalSurveyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.survey.id != widget.survey.id) {
      _answers.clear();
      _currentStep = 0;
      _lastSurveyId = widget.survey.id;
    }
  }

  List<SurveyQuestionEntity> get _visibleQuestions {
    return widget.survey.questions.where((question) {
      if (question.conditionalLogic == null) return true;
      
      final showIf = question.conditionalLogic!['showIf'];
      if (showIf == null) return true;

      final questionId = showIf['questionId'];
      final operator = showIf['operator'];
      final value = showIf['value'];

      if (!_answers.containsKey(questionId)) return false;

      final answer = _answers[questionId];
      
      switch (operator) {
        case '>':
          return (answer as num) > value;
        case '>=':
          return (answer as num) >= value;
        case '<':
          return (answer as num) < value;
        case '<=':
          return (answer as num) <= value;
        case '==':
          return answer == value;
        case '!=':
          return answer != value;
        default:
          return true;
      }
    }).toList();
  }

  bool get _canProceed {
    if (_currentStep >= _visibleQuestions.length) return false;
    final question = _visibleQuestions[_currentStep];
    
    if (question.options?['info'] == true) {
      return true;
    }
    
    if (!question.required) return true;
    
    if (question.type == QuestionType.table) {
      return _validateTableQuestion(question);
    }
    
    if (question.options?['composite'] != null) {
      return _validateCompositeQuestion(question);
    }
    
    if (!_answers.containsKey(question.id)) return false;
    
    final answer = _answers[question.id];
    if (answer == null) return false;
    
    if (answer is String && answer.isEmpty) return false;
    if (answer is List && answer.isEmpty) return false;
    
    return true;
  }

  bool _validateTableQuestion(SurveyQuestionEntity question) {
    final rows = question.options?['rows'] as List<dynamic>? ?? [];
    
    for (var row in rows) {
      final rowKey = row is Map ? row['value'] : row.toString();
      final answerKey = '${question.id}_$rowKey';
      if (!_answers.containsKey(answerKey) || _answers[answerKey] == null) {
        return false;
      }
    }
    
    return true;
  }

  bool _validateCompositeQuestion(SurveyQuestionEntity question) {
    final compositeType = question.options?['composite'];
    
    if (compositeType == 'doctor_visit') {
      final doctorVisited = _answers[question.id];
      if (doctorVisited == true) {
        final specialization = _answers['${question.id}_specialization'];
        final newDiagnosis = _answers['${question.id}_new_diagnosis'];
        if (specialization == null || specialization.toString().isEmpty) return false;
        if (newDiagnosis == true) {
          final diagnosisDesc = _answers['${question.id}_new_diagnosis_desc'];
          if (diagnosisDesc == null || diagnosisDesc.toString().isEmpty) return false;
        }
      }
      return true;
    }
    
    if (compositeType == 'medications') {
      final medsChanged = _answers[question.id];
      if (medsChanged == true) {
        final medications = _answers['${question.id}_medications'] as List?;
        if (medications == null || medications.isEmpty) return false;
        for (var med in medications) {
          if (med['name'] == null || med['name'].toString().isEmpty) return false;
        }
      }
      return true;
    }
    
    return true;
  }

  void _handleNext() {
    if (!_canProceed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Najpierw wypełnij wszystkie pola',
            style: GoogleFonts.inter(fontSize: 14),
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      );
      return;
    }

    if (_currentStep < _visibleQuestions.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      widget.onComplete(_answers);
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      widget.onBack();
    }
  }

  String _getQuestionText(SurveyQuestionEntity question) {
    String text = question.question;
    
    if (question.genderForm != null) {
      final profile = ref.read(profileProvider).profile;
      final genderIdentity = profile.genderIdentity;
      text = text.replaceAll('{genderForm}', question.genderForm!);
    }
    
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final visibleQuestions = _visibleQuestions;
    final totalSteps = visibleQuestions.length;
    final currentQuestion = visibleQuestions.isNotEmpty && _currentStep < visibleQuestions.length
        ? visibleQuestions[_currentStep]
        : null;

    if (currentQuestion == null) {
      return Scaffold(
        body: Center(child: Text('Brak pytań')),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        onPressed: _handleBack,
                        style: IconButton.styleFrom(
                          shape: const CircleBorder(),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                          minimumSize: const Size(44, 44),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.survey.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 44,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${((_currentStep + 1) / totalSteps * 100).round()}%',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / totalSteps,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.secondary,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildQuestion(currentQuestion),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _canProceed ? _handleNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.primary,
                disabledBackgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                disabledForegroundColor:
                    Theme.of(context).colorScheme.primary,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep == totalSteps - 1 ? 'Zakończ' : 'Kontynuuj',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(SurveyQuestionEntity question) {
    final questionText = _getQuestionText(question);
    final isInfoOnly = question.options?['info'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isInfoOnly) ...[
          Text(
            questionText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ] else ...[
          Text(
            questionText,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (question.description != null) ...[
            const SizedBox(height: 8),
            Text(
              question.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF505968),
              ),
            ),
          ],
        ],
        if (!isInfoOnly) const SizedBox(height: 24),
        _buildQuestionInput(question),
      ],
    );
  }

  Widget _buildQuestionInput(SurveyQuestionEntity question) {
    if (question.options?['info'] == true) {
      return const SizedBox.shrink();
    }

    switch (question.type) {
      case QuestionType.text:
        return _buildTextQuestion(question);
      case QuestionType.number:
        return _buildNumberQuestion(question);
      case QuestionType.choice:
        return _buildChoiceQuestion(question);
      case QuestionType.multichoice:
        return _buildMultiChoiceQuestion(question);
      case QuestionType.table:
        return _buildTableQuestion(question);
      case QuestionType.time:
        return _buildTimeQuestion(question);
      case QuestionType.slider:
        return _buildSliderQuestion(question);
      case QuestionType.boolean:
        if (question.options?['composite'] != null) {
          return _buildCompositeQuestion(question);
        }
        return _buildBooleanQuestion(question);
      default:
        return Text('Nieobsługiwany typ pytania: ${question.type}');
    }
  }

  Widget _buildTextQuestion(SurveyQuestionEntity question) {
    final isMultiline = question.options?['multiline'] == true;
    final controller = TextEditingController(
      text: _answers[question.id]?.toString() ?? '',
    );

    return TextField(
      controller: controller,
      maxLines: isMultiline ? 5 : 1,
      onChanged: (value) {
        setState(() {
          _answers[question.id] = value;
        });
      },
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: question.options?['placeholder'] as String?,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberQuestion(SurveyQuestionEntity question) {
    final controller = TextEditingController(
      text: _answers[question.id]?.toString() ?? '',
    );
    final label = question.options?['label'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _answers[question.id] = value.isEmpty ? null : int.tryParse(value);
            });
          },
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: question.options?['placeholder'] as String?,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2,
              ),
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceQuestion(SurveyQuestionEntity question) {
    final options = question.options?['options'] as List<dynamic>? ?? [];
    final selectedValue = _answers[question.id];

    return Column(
      children: options.map<Widget>((option) {
        final optionValue = option is Map ? option['value'] : option;
        final optionLabel = option is Map ? option['label'] : option.toString();
        final isSelected = selectedValue == optionValue;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _answers[question.id] = optionValue;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                optionLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultiChoiceQuestion(SurveyQuestionEntity question) {
    final options = question.options?['options'] as List<dynamic>? ?? [];
    final selectedValues = (_answers[question.id] as List<dynamic>?) ?? [];

    return Column(
      children: options.map<Widget>((option) {
        final optionValue = option is Map ? option['value'] : option;
        final optionLabel = option is Map ? option['label'] : option.toString();
        final isSelected = selectedValues.contains(optionValue);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                final newValues = List<dynamic>.from(selectedValues);
                if (isSelected) {
                  newValues.remove(optionValue);
                } else {
                  newValues.add(optionValue);
                }
                _answers[question.id] = newValues;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
                borderRadius: BorderRadius.zero,
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      optionLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTableQuestion(SurveyQuestionEntity question) {
    final rows = question.options?['rows'] as List<dynamic>? ?? [];
    final columns = question.options?['columns'] as List<dynamic>? ?? [];
    final rowLabels = question.options?['rowLabels'] as Map<String, dynamic>?;
    final columnLabels = question.options?['columnLabels'] as Map<String, dynamic>?;
    final rowTooltips = question.options?['rowTooltips'] as Map<String, dynamic>?;

    final selectedValues = <String, String?>{};
    for (var row in rows) {
      final rowKey = row is Map ? row['value'] : row.toString();
      selectedValues[rowKey] = (_answers['${question.id}_$rowKey'] as String?);
    }

    final processedRowLabels = rowLabels?.map((k, v) {
      final value = v.toString();
      final firstLine = value.contains('\n') ? value.split('\n').first : value;
      return MapEntry(k, firstLine);
    });

    return TableQuestionWidget(
      selectedValues: selectedValues,
      onChanged: (rowKey, columnKey) {
        setState(() {
          _answers['${question.id}_$rowKey'] = columnKey;
        });
      },
      rows: rows.map<String>((r) => r is Map ? r['value'].toString() : r.toString()).toList(),
      columns: columns.map<String>((c) => c is Map ? c['value'].toString() : c.toString()).toList(),
      rowLabels: processedRowLabels,
      columnLabels: columnLabels?.map((k, v) => MapEntry(k, v.toString())),
      rowTooltips: rowTooltips?.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  Widget _buildTimeQuestion(SurveyQuestionEntity question) {
    final timeValue = _answers[question.id];
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
        setState(() {
          _answers[question.id] = {
            'hour': time.hour,
            'minute': time.minute,
          };
        });
      },
      label: question.options?['label'] as String? ?? 'Wybierz godzinę',
    );
  }

  Widget _buildSliderQuestion(SurveyQuestionEntity question) {
    final min = (question.options?['min'] as num?)?.toDouble() ?? 0.0;
    final max = (question.options?['max'] as num?)?.toDouble() ?? 100.0;
    final step = (question.options?['step'] as num?)?.toDouble();
    final unit = question.options?['unit'] as String?;
    final currentValue = (_answers[question.id] as num?)?.toDouble() ?? min;
    final segmentScale = question.options?['segmentScale'] == true;

    if (segmentScale) {
      return SegmentScaleQuestionWidget(
        value: currentValue.toInt(),
        onChanged: (value) {
          setState(() {
            _answers[question.id] = value;
          });
        },
        minLabel: question.options?['minLabel'] as String?,
        maxLabel: question.options?['maxLabel'] as String?,
        reversed: question.options?['reversed'] == true,
      );
    }

    return SliderQuestionWidget(
      value: currentValue,
      onChanged: (value) {
        setState(() {
          _answers[question.id] = value;
        });
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
    );
  }

  Widget _buildBooleanQuestion(SurveyQuestionEntity question) {
    final selectedValue = _answers[question.id] as bool?;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _answers[question.id] = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selectedValue == true
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
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
              setState(() {
                _answers[question.id] = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selectedValue == false
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
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
    );
  }

  Widget _buildCompositeQuestion(SurveyQuestionEntity question) {
    final compositeType = question.options?['composite'];
    
    if (compositeType == 'doctor_visit') {
      return _buildDoctorVisitCompositeQuestion(question);
    } else if (compositeType == 'medications') {
      return _buildMedicationsCompositeQuestion(question);
    }
    
    return _buildBooleanQuestion(question);
  }

  Widget _buildDoctorVisitCompositeQuestion(SurveyQuestionEntity question) {
    final doctorVisited = _answers[question.id] as bool?;
    final specialization = _answers['${question.id}_specialization'] as String?;
    final newDiagnosis = _answers['${question.id}_new_diagnosis'] as bool?;
    final diagnosisDesc = _answers['${question.id}_new_diagnosis_desc'] as String?;

    return Column(
      children: [
        _buildBooleanQuestion(question),
        if (doctorVisited == true) ...[
          const SizedBox(height: 24),
          SpecializationAutocomplete(
            initialValue: specialization,
            onChanged: (value) {
              setState(() {
                _answers['${question.id}_specialization'] = value;
              });
            },
            label: 'Specjalizacja lekarza',
            hint: 'np. Kardiolog, Dermatolog',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _answers['${question.id}_new_diagnosis'] = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: newDiagnosis == true
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Text(
                      'Czy otrzymałeś nową diagnozę?',
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
                    setState(() {
                      _answers['${question.id}_new_diagnosis'] = false;
                      _answers['${question.id}_new_diagnosis_desc'] = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: newDiagnosis == false
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
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
                setState(() {
                  _answers['${question.id}_new_diagnosis_desc'] = value;
                });
              },
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Jaka to była diagnoza?',
                hintText: 'Wpisz diagnozę',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
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

  Widget _buildMedicationsCompositeQuestion(SurveyQuestionEntity question) {
    final medsChanged = _answers[question.id] as bool?;
    final medications = (_answers['${question.id}_medications'] as List<dynamic>?) ?? [];

    return Column(
      children: [
        _buildBooleanQuestion(question),
        if (medsChanged == true) ...[
          const SizedBox(height: 24),
          ...medications.asMap().entries.map((entry) {
            final index = entry.key;
            final med = entry.value as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: MedicationAutocomplete(
                      key: ValueKey('med_${question.id}_$index'),
                      initialValue: med['name'] as String?,
                      onChanged: (value) {
                        setState(() {
                          final newMeds = List<Map<String, dynamic>>.from(medications);
                          newMeds[index]['name'] = value;
                          _answers['${question.id}_medications'] = newMeds;
                        });
                      },
                      label: 'Lek ${index + 1}',
                      hint: 'Wpisz nazwę leku',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: med['dosage']?.toString() ?? ''),
                      onChanged: (value) {
                        setState(() {
                          final newMeds = List<Map<String, dynamic>>.from(medications);
                          newMeds[index]['dosage'] = value;
                          _answers['${question.id}_medications'] = newMeds;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Dawkowanie',
                        hintText: 'np. 2x dziennie',
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (medications.length > 1) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          final newMeds = List<Map<String, dynamic>>.from(medications);
                          newMeds.removeAt(index);
                          _answers['${question.id}_medications'] = newMeds;
                        });
                      },
                      icon: Icon(Icons.remove_circle, color: Colors.red[400]),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(44, 44),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                final newMeds = List<Map<String, dynamic>>.from(medications);
                newMeds.add({'name': '', 'dosage': ''});
                _answers['${question.id}_medications'] = newMeds;
              });
            },
            icon: const Icon(Icons.add),
            label: Text(
              medications.isEmpty ? 'Dodaj lek' : 'Dodaj kolejny lek',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
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
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

