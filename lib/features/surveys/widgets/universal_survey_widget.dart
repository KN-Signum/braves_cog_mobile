import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:braves_cog/features/surveys/presentation/managers/survey_validation_manager.dart';
import 'package:braves_cog/features/surveys/presentation/managers/survey_alert_manager.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';

import 'package:braves_cog/features/surveys/widgets/question_builders/composite/doctor_visit_builder.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/composite/medications_builder.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/composite/somatic_disease_builder.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/composite/substance_use_builder.dart';
import 'package:braves_cog/features/onboarding/widgets/year_picker.dart'
    as custom_pickers;
import 'package:braves_cog/features/onboarding/widgets/height_picker.dart';
import 'package:braves_cog/features/onboarding/widgets/weight_picker.dart';
import 'package:braves_cog/features/onboarding/widgets/icon_option_grid.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/clickable_question_text_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/text_question_builder.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/single_choice_builder.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/multiple_choice_builder.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/number_question_builder.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/scale_question_builder.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/table_question_builder.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/time_question_builder.dart';
import 'package:braves_cog/features/surveys/widgets/question_builders/boolean_question_builder.dart';
import 'package:google_fonts/google_fonts.dart';

bool _isAlertSurvey(String surveyId) {
  if (surveyId == 'PHQ_2' || surveyId == 'GAD_2') return true;
  if (surveyId == 'Baseline_Depression' ||
      surveyId.contains('PHQ_9') ||
      surveyId.contains('phq9'))
    return true;
  if (surveyId == 'Baseline_Stress_And_Anxiety_GAD7' ||
      surveyId.contains('GAD_7') ||
      surveyId.contains('gad7'))
    return true;
  return false;
}

class UniversalSurveyWidget extends ConsumerStatefulWidget {
  final SurveyEntity survey;
  final Function(Map<String, dynamic>, {bool isBackNavigation}) onComplete;
  final VoidCallback onBack;
  final bool showHeaderAndProgress;
  final int? globalStepOffset;
  final int? globalTotalSteps;
  final String? headerTitle;
  final bool startAtLastQuestion;
  final bool showFinishLabel;
  final Map<String, dynamic>? initialAnswers;

  const UniversalSurveyWidget({
    super.key,
    required this.survey,
    required this.onComplete,
    required this.onBack,
    this.showHeaderAndProgress = true,
    this.globalStepOffset,
    this.globalTotalSteps,
    this.headerTitle,
    this.startAtLastQuestion = false,
    this.showFinishLabel = false,
    this.initialAnswers,
  });

  @override
  ConsumerState<UniversalSurveyWidget> createState() =>
      _UniversalSurveyWidgetState();
}

class _UniversalSurveyWidgetState extends ConsumerState<UniversalSurveyWidget> {
  final Map<String, TextEditingController> _textControllers = {};
  int _currentStep = 0;
  bool _showingAlert = false;
  bool _isSubmitting = false;
  double _maxProgressValue = 0.0;

  String? _alertTitle;
  String? _alertMessage;

  /// Po pojawieniu się alertu w ankietach PHQ-2, GAD-2, PHQ-9, GAD-7 nie można cofać do pytań.
  bool _alertWasShownInThisSurvey = false;

  /// Krok (indeks pytania) w momencie pokazania alertu – pasek postępu nie spada przy cofaniu.
  int? _progressStepWhenAlertShown;

  /// MiniEat (screening), MiniEat onboarding (MINI_EAT_OB) i Baseline_Eating_Habits – opis pytania w „i” w kółku (tooltip).
  bool get _isMiniEatStyleSurvey =>
      widget.survey.id == 'MINI_EAT' ||
      widget.survey.id == 'MINI_EAT_OB' ||
      widget.survey.id == 'Baseline_Eating_Habits';

  @override
  void initState() {
    super.initState();
    // Initialize answers from the provider if provided
    Future.microtask(() {
      final notifier = ref.read(surveyProvider(widget.survey.id).notifier);
      notifier.setInitialAnswers(widget.initialAnswers);
      _initializeDefaultValues(notifier);
    });

    if (widget.startAtLastQuestion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final visibleQuestions = _visibleQuestions;
          if (visibleQuestions.isNotEmpty) {
            setState(() {
              _currentStep = visibleQuestions.length - 1;
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(UniversalSurveyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.survey.id != widget.survey.id) {
      Future.microtask(() {
        if (mounted) {
          final notifier = ref.read(surveyProvider(widget.survey.id).notifier);
          notifier.setInitialAnswers(widget.initialAnswers);
          _initializeDefaultValues(notifier);
        }
      });

      if (widget.startAtLastQuestion) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            final visibleQuestions = _visibleQuestions;
            if (visibleQuestions.isNotEmpty) {
              setState(() {
                _currentStep = visibleQuestions.length - 1;
              });
            }
          }
        });
      } else {
        setState(() {
          _currentStep = 0;
        });
      }
    } else if (oldWidget.startAtLastQuestion != widget.startAtLastQuestion) {
      if (widget.startAtLastQuestion) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            final visibleQuestions = _visibleQuestions;
            if (visibleQuestions.isNotEmpty) {
              setState(() {
                _currentStep = visibleQuestions.length - 1;
              });
            }
          }
        });
      } else {
        setState(() {
          _currentStep = 0;
        });
      }
    }
  }

  void _initializeDefaultValues(SurveyNotifier notifier) {
    final state = ref.read(surveyProvider(widget.survey.id));
    for (var question in widget.survey.questions) {
      if (question.options?['picker'] != null &&
          !state.answers.containsKey(question.id)) {
        final pickerType = question.options?['picker'] as String;
        switch (pickerType) {
          case 'year':
            final defaultYear =
                question.options?['defaultYear'] as int? ?? 1990;
            notifier.updateAnswer(question.id, defaultYear.toString());
            break;
          case 'height':
            notifier.updateAnswer(question.id, '170');
            break;
          case 'weight':
            notifier.updateAnswer(question.id, '70');
            break;
        }
      }
      if (question.type == QuestionType.slider &&
          question.options?['showMarkers'] == true &&
          !state.answers.containsKey(question.id)) {
        final min = (question.options?['min'] as num?)?.toDouble() ?? 0.0;
        notifier.updateAnswer(question.id, min);
      }
    }
  }

  List<SurveyQuestionEntity> get _visibleQuestions {
    final state = ref.watch(surveyProvider(widget.survey.id));
    return widget.survey.questions.where((question) {
      if (question.conditionalLogic == null) return true;

      final showIf = question.conditionalLogic!['showIf'];
      if (showIf == null) return true;

      final questionId = showIf['questionId'];
      final operator = showIf['operator'];
      final value = showIf['value'];

      if (!state.answers.containsKey(questionId)) {
        final tableAnswerKey = '${questionId}_$value';
        if (state.answers.containsKey(tableAnswerKey)) {
          final tableAnswer = state.answers[tableAnswerKey];
          return operator == '==' && tableAnswer == value;
        }
        return false;
      }

      final answer = state.answers[questionId];

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
    if (_isSubmitting) return false;
    if (_showingAlert) return true;
    if (_currentStep >= _visibleQuestions.length) return false;

    final question = _visibleQuestions[_currentStep];
    final answers = ref.watch(surveyProvider(widget.survey.id)).answers;
    return SurveyValidationManager.canProceed(question, answers);
  }

  Future<void> _handleNext() async {
    if (_isSubmitting) return;

    final notifier = ref.read(surveyProvider(widget.survey.id).notifier);
    final answers = ref.read(surveyProvider(widget.survey.id)).answers;

    if (!_canProceed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Najpierw wypełnij wszystkie pola',
            style: GoogleFonts.inter(fontSize: 14),
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      );
      return;
    }

    if (_showingAlert) {
      setState(() {
        _isSubmitting = true;
      });
      await notifier.submitSurvey(widget.survey.id);
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _showingAlert = false;
          _alertTitle = null;
          _alertMessage = null;
        });
        widget.onComplete(answers, isBackNavigation: false);
      }
      return;
    }

    if (_currentStep < _visibleQuestions.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      final alert = SurveyAlertManager.getAlertForSurvey(
        widget.survey.id,
        answers,
      );
      if (alert != null) {
        setState(() {
          _showingAlert = true;
          _alertTitle = alert.title;
          _alertMessage = alert.message;
          if (_isAlertSurvey(widget.survey.id)) {
            _alertWasShownInThisSurvey = true;
            _progressStepWhenAlertShown = _currentStep;
          }
        });
      } else {
        setState(() {
          _isSubmitting = true;
        });
        await notifier.submitSurvey(widget.survey.id);
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
          widget.onComplete(answers, isBackNavigation: false);
        }
      }
    }
  }

  void _handleBack() {
    if (_isAlertSurvey(widget.survey.id) && _alertWasShownInThisSurvey) {
      final answers = ref.read(surveyProvider(widget.survey.id)).answers;
      widget.onComplete(answers, isBackNavigation: true);
      widget.onBack();
      return;
    }
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      final answers = ref.read(surveyProvider(widget.survey.id)).answers;
      widget.onComplete(answers, isBackNavigation: true);
      widget.onBack();
    }
  }

  String _getQuestionText(SurveyQuestionEntity question) {
    String text = question.question;

    if (question.genderForm != null) {
      final profile = ref.read(profileProvider).profile;
      final genderIdentity = profile.genderIdentity.trim().toLowerCase();

      if (text.contains('wykonywałeś/-aś')) {
        String verbForm;
        if (genderIdentity == 'male') {
          verbForm = 'wykonywałeś';
        } else if (genderIdentity == 'female') {
          verbForm = 'wykonywałaś';
        } else if (genderIdentity == 'non_binary' ||
            genderIdentity == 'other' ||
            genderIdentity == 'prefer_not_to_say') {
          verbForm = 'wykonywano';
        } else {
          verbForm = 'wykonywano';
        }
        text = text.replaceAll('wykonywałeś/-aś', verbForm);
      } else if (text.contains('chodziłeś/-aś')) {
        String verbForm;
        if (genderIdentity == 'male') {
          verbForm = 'chodziłeś';
        } else if (genderIdentity == 'female') {
          verbForm = 'chodziłaś';
        } else if (genderIdentity == 'non_binary' ||
            genderIdentity == 'other' ||
            genderIdentity == 'prefer_not_to_say') {
          verbForm = 'chodzono';
        } else {
          verbForm = 'chodzono';
        }
        text = text.replaceAll('chodziłeś/-aś', verbForm);
      } else {
        text = text.replaceAll('{genderForm}', question.genderForm!);
      }
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final visibleQuestions = _visibleQuestions;
    final totalSteps = visibleQuestions.length;
    final useGlobalProgress =
        widget.globalStepOffset != null && widget.globalTotalSteps != null;
    final localProgress = totalSteps > 0
        ? (_currentStep + 1) / totalSteps
        : 0.0;
    final globalProgress = useGlobalProgress && widget.globalTotalSteps! > 0
        ? (widget.globalStepOffset! + _currentStep + 1) /
              widget.globalTotalSteps!
        : localProgress;
    double progressValue = globalProgress.clamp(0.0, 1.0);
    if (progressValue > _maxProgressValue) {
      _maxProgressValue = progressValue;
    }
    progressValue = _maxProgressValue;
    final percent = (progressValue * 100).round();

    // Ensure current step is valid after conditional logic changes
    if (_currentStep >= totalSteps && totalSteps > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentStep = totalSteps - 1;
          });
        }
      });
    }

    final currentQuestion =
        visibleQuestions.isNotEmpty && _currentStep < visibleQuestions.length
        ? visibleQuestions[_currentStep]
        : null;

    if (currentQuestion == null) {
      return Scaffold(body: Center(child: Text('Brak pytań')));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          if (widget.showHeaderAndProgress)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        if (!_showingAlert)
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
                          )
                        else
                          const SizedBox(width: 44, height: 44),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.headerTitle ?? widget.survey.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
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
                              '$percent%',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: LinearProgressIndicator(
                        value: progressValue,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
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
              child: _showingAlert
                  ? _buildAlertContent()
                  : _buildQuestion(currentQuestion),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
            child: ElevatedButton(
              onPressed: _canProceed ? _handleNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.inverseTextColor,
                disabledBackgroundColor: AppTheme.primaryColor,
                disabledForegroundColor: AppTheme.inverseTextColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: AppTheme.inverseTextColor,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _showingAlert
                              ? 'Kontynuuj'
                              : (widget.showFinishLabel &&
                                        _currentStep == totalSteps - 1
                                    ? 'Zakończ'
                                    : 'Kontynuuj'),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.inverseTextColor,
                              ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.arrow_forward,
                          color: AppTheme.inverseTextColor,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_alertTitle != null) ...[
            Text(
              _alertTitle!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (_alertMessage != null) ...[
            Text(
              _alertMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestion(SurveyQuestionEntity question) {
    final questionText = _getQuestionText(question);
    final isInfoOnly = question.options?['info'] == true;
    final isIntroStyle = question.options?['intro'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isInfoOnly) ...[
          if (isIntroStyle) ...[
            SizedBox(
              width: double.infinity,
              child: Text(
                questionText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                  letterSpacing: -0.24,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (question.description != null)
              SizedBox(
                width: double.infinity,
                child: Text(
                  question.description!,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.6, fontSize: 18),
                ),
              ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: Text(
                questionText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
            if (question.description != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Text(
                  question.description!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF505968),
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ],
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: _isMiniEatStyleSurvey && question.description != null
                ? ClickableQuestionTextWidget(
                    questionText: questionText,
                    tooltipText: question.description,
                    textStyle: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  )
                : Text(
                    questionText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
          // Don't show description as separate text for MINI EAT / MiniEat onboarding (it's in the tooltip)
          if (question.description != null && !_isMiniEatStyleSurvey) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Text(
                question.description!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF505968),
                ),
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

    final pickerType = question.options?['picker'] as String?;
    if (pickerType != null) {
      switch (pickerType) {
        case 'year':
          return _buildYearPicker(question);
        case 'height':
          return _buildHeightPicker(question);
        case 'weight':
          return _buildWeightPicker(question);
        case 'icon_grid':
          return _buildIconGridQuestion(question);
        default:
          break;
      }
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
    return TextQuestionBuilder(
      key: ValueKey(question.id),
      surveyId: widget.survey.id,
      question: question,
    );
  }

  Widget _buildNumberQuestion(SurveyQuestionEntity question) {
    return NumberQuestionBuilder(
      key: ValueKey(question.id),
      surveyId: widget.survey.id,
      question: question,
    );
  }

  Widget _buildChoiceQuestion(SurveyQuestionEntity question) {
    return SingleChoiceBuilder(surveyId: widget.survey.id, question: question);
  }

  Widget _buildMultiChoiceQuestion(SurveyQuestionEntity question) {
    return MultipleChoiceBuilder(
      surveyId: widget.survey.id,
      question: question,
    );
  }

  Widget _buildTableQuestion(SurveyQuestionEntity question) {
    return TableQuestionBuilder(surveyId: widget.survey.id, question: question);
  }

  Widget _buildTimeQuestion(SurveyQuestionEntity question) {
    return TimeQuestionBuilder(surveyId: widget.survey.id, question: question);
  }

  Widget _buildSliderQuestion(SurveyQuestionEntity question) {
    return ScaleQuestionBuilder(surveyId: widget.survey.id, question: question);
  }

  Widget _buildBooleanQuestion(SurveyQuestionEntity question) {
    return BooleanQuestionBuilder(
      surveyId: widget.survey.id,
      question: question,
    );
  }

  Widget _buildCompositeQuestion(SurveyQuestionEntity question) {
    final compositeType = question.options?['composite'];

    if (compositeType == 'doctor_visit') {
      return DoctorVisitBuilder(surveyId: widget.survey.id, question: question);
    } else if (compositeType == 'medications') {
      return MedicationsBuilder(surveyId: widget.survey.id, question: question);
    } else if (compositeType == 'substance_use') {
      return SubstanceUseBuilder(
        surveyId: widget.survey.id,
        question: question,
      );
    } else if (compositeType == 'somatic_disease') {
      return SomaticDiseaseBuilder(
        surveyId: widget.survey.id,
        question: question,
      );
    }

    return BooleanQuestionBuilder(
      surveyId: widget.survey.id,
      question: question,
    );
  }

  Widget _buildYearPicker(SurveyQuestionEntity question) {
    final state = ref.watch(surveyProvider(widget.survey.id));
    final notifier = ref.read(surveyProvider(widget.survey.id).notifier);
    final answer = state.answers[question.id];
    final currentValue = answer is int
        ? answer
        : (answer != null ? int.tryParse(answer.toString()) ?? 1990 : 1990);
    final minYear = question.options?['minYear'] as int? ?? 1925;
    final maxYear = question.options?['maxYear'] as int? ?? DateTime.now().year;
    final defaultYear = question.options?['defaultYear'] as int? ?? 1990;

    return custom_pickers.YearPicker(
      value: currentValue,
      onChange: (value) {
        notifier.updateAnswer(question.id, value);
      },
      minYear: minYear,
      maxYear: maxYear,
      defaultYear: defaultYear,
    );
  }

  Widget _buildHeightPicker(SurveyQuestionEntity question) {
    final state = ref.watch(surveyProvider(widget.survey.id));
    final notifier = ref.read(surveyProvider(widget.survey.id).notifier);
    final answer = state.answers[question.id];
    final currentValue = answer is int
        ? answer
        : (answer != null ? int.tryParse(answer.toString()) ?? 170 : 170);

    return HeightPicker(
      height: currentValue,
      onHeightChanged: (value) {
        notifier.updateAnswer(question.id, value);
      },
    );
  }

  Widget _buildWeightPicker(SurveyQuestionEntity question) {
    final state = ref.watch(surveyProvider(widget.survey.id));
    final notifier = ref.read(surveyProvider(widget.survey.id).notifier);
    final answer = state.answers[question.id];
    final currentValue = answer is int
        ? answer
        : (answer != null ? int.tryParse(answer.toString()) ?? 70 : 70);

    return WeightPicker(
      weight: currentValue,
      onWeightChanged: (value) {
        notifier.updateAnswer(question.id, value);
      },
    );
  }

  Widget _buildIconGridQuestion(SurveyQuestionEntity question) {
    final state = ref.watch(surveyProvider(widget.survey.id));
    final notifier = ref.read(surveyProvider(widget.survey.id).notifier);

    final iconOptions =
        question.options?['iconOptions'] as List<dynamic>? ?? [];
    final selectedValue = state.answers[question.id]?.toString() ?? '';
    final columns = question.options?['columns'] as int? ?? 2;

    final options = iconOptions.map((opt) {
      if (opt is Map) {
        return IconOption(
          value: opt['value']?.toString() ?? '',
          label: opt['label']?.toString() ?? '',
          icon: _getIconFromString(opt['icon']?.toString() ?? ''),
        );
      }
      return IconOption(value: '', label: '', icon: Icons.help);
    }).toList();

    return IconOptionGrid(
      options: options,
      value: selectedValue,
      onChange: (value) {
        notifier.updateAnswer(question.id, value);
      },
      columns: columns,
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'male':
        return Icons.male;
      case 'female':
        return Icons.female;
      case 'transgender':
        return Icons.transgender;
      case 'person_outline':
        return Icons.person_outline;
      case 'block':
        return Icons.block;
      case 'school_outlined':
        return Icons.school_outlined;
      case 'build_outlined':
        return Icons.build_outlined;
      case 'menu_book':
        return Icons.menu_book;
      case 'school':
        return Icons.school;
      case 'more_horiz':
        return Icons.more_horiz;
      case 'accessibility_new':
        return Icons.accessibility_new;
      case 'accessible':
        return Icons.accessible;
      case 'accessible_forward':
        return Icons.accessible_forward;
      case 'wheelchair_pickup':
        return Icons.wheelchair_pickup;
      default:
        return Icons.help;
    }
  }
}
