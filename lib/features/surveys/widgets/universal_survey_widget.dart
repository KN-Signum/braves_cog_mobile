import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:braves_cog/features/onboarding/widgets/medication_autocomplete.dart';
import 'package:braves_cog/core/services/medication_api_service.dart';
import 'package:braves_cog/features/health/widgets/specialization_autocomplete.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/time_picker_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/slider_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/table_question_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/segment_scale_question_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/hours_minutes_picker_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/single_hours_picker_widget.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/single_minutes_picker_widget.dart';
import 'package:braves_cog/features/onboarding/widgets/year_picker.dart' as custom_pickers;
import 'package:braves_cog/features/onboarding/widgets/height_picker.dart';
import 'package:braves_cog/features/onboarding/widgets/weight_picker.dart';
import 'package:braves_cog/features/onboarding/widgets/icon_option_grid.dart';
import 'package:braves_cog/features/surveys/widgets/question_widgets/clickable_question_text_widget.dart';
import 'package:google_fonts/google_fonts.dart';

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
  ConsumerState<UniversalSurveyWidget> createState() => _UniversalSurveyWidgetState();
}

class _UniversalSurveyWidgetState extends ConsumerState<UniversalSurveyWidget> {
  final Map<String, dynamic> _answers = {};
  final Map<String, List<int>> _hoursMinutesCache = {};
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, List<String>> _medicationStrengthsCache = {};
  final MedicationApiService _medicationApiService = MedicationApiService();
  int _currentStep = 0;
  String? _lastSurveyId;
  bool _showingAlert = false;
  String? _alertTitle;
  String? _alertMessage;

  @override
  void initState() {
    super.initState();
    _lastSurveyId = widget.survey.id;
    if (widget.initialAnswers != null) {
      _answers.addAll(widget.initialAnswers!);
    }
    _initializeDefaultValues();

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
      _answers.clear();
      if (widget.initialAnswers != null) {
        _answers.addAll(widget.initialAnswers!);
      }
      _lastSurveyId = widget.survey.id;
      _initializeDefaultValues();
      
      // Jeśli startAtLastQuestion jest ustawione, ustaw _currentStep na ostatnie pytanie
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
        _currentStep = 0;
      }
    } else if (oldWidget.startAtLastQuestion != widget.startAtLastQuestion) {
      // Jeśli tylko startAtLastQuestion się zmieniło, zaktualizuj _currentStep
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

  TextEditingController _getTextController(String key, String initialText) {
    final existing = _textControllers[key];
    if (existing != null) {
      return existing;
    }
    final controller = TextEditingController(text: initialText);
    _textControllers[key] = controller;
    return controller;
  }

  void _initializeDefaultValues() {
    for (var question in widget.survey.questions) {
      if (question.options?['picker'] != null && !_answers.containsKey(question.id)) {
        final pickerType = question.options?['picker'] as String;
        switch (pickerType) {
          case 'year':
            final defaultYear = question.options?['defaultYear'] as int? ?? 1990;
            _answers[question.id] = defaultYear.toString();
            break;
          case 'height':
            _answers[question.id] = '170';
            break;
          case 'weight':
            _answers[question.id] = '70';
            break;
        }
      }
      if (question.type == QuestionType.slider && 
          question.options?['showMarkers'] == true && 
          !_answers.containsKey(question.id)) {
        final min = (question.options?['min'] as num?)?.toDouble() ?? 0.0;
        _answers[question.id] = min;
      }
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

      if (!_answers.containsKey(questionId)) {
        final tableAnswerKey = '${questionId}_$value';
        if (_answers.containsKey(tableAnswerKey)) {
          final tableAnswer = _answers[tableAnswerKey];
          return operator == '==' && tableAnswer == value;
        }
        return false;
      }

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
    // Jeśli pokazujemy alert, zawsze pozwól przejść dalej
    if (_showingAlert) return true;
    
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
    
    if (compositeType == 'substance_use') {
      final enabledKey = '${question.id}_enabled';
      final frequencyKey = '${question.id}_frequency';
      final enabled = _answers[enabledKey] as bool? ?? false;
      if (!enabled) {
        // Jeśli użytkownik zaznaczył NIE, traktujemy to jako 0 dni – zawsze OK.
        return true;
      }
      final frequency = _answers[frequencyKey];
      if (frequency == null) return false;
      if (frequency.toString().isEmpty) return false;
      return true;
    }
    
    if (compositeType == 'somatic_disease') {
      final enabledKey = '${question.id}_enabled';
      final dontKnowKey = '${question.id}_dont_know';
      final subtypesKey = '${question.id}_subtypes';
      final otherTextKey = '${question.id}_other_text';
      final rowKey = question.options?['rowKey'] as String?;

      final enabled = _answers[enabledKey] as bool? ?? false;
      final dontKnow = _answers[dontKnowKey] as bool? ?? false;

      // "Nie wiem" zawsze jest akceptowane.
      if (dontKnow) return true;

      // Jeśli użytkownik wybrał "Nie" (przełącznik w pozycji wyłączonej),
      // to traktujemy to jako brak choroby – też OK.
      if (!enabled) return true;

      // Dla "Innych chorób somatycznych" (rowKey == 'other') wymagamy tylko tekstu.
      if (rowKey == 'other') {
        final otherText = _answers[otherTextKey]?.toString().trim() ?? '';
        if (otherText.isEmpty) return false;
        return true;
      }

      // Dla pozostałych chorób: przy "Tak" musi być wybrana co najmniej jedna pod-opcja.
      final subtypes = _answers[subtypesKey] as List<dynamic>? ?? const [];
      if (subtypes.isEmpty) return false;

      // Jeśli wśród pod-opcji jest "other", wymagamy wypełnienia pola tekstowego.
      if (subtypes.contains('other')) {
        final otherText = _answers[otherTextKey]?.toString().trim() ?? '';
        if (otherText.isEmpty) return false;
      }

      return true;
    }
    
    if (compositeType == 'hours_minutes') {
      final showDontKnow = question.options?['showDontKnow'] == true;
      final dontKnowKey = '${question.id}_dont_know';
      
      // If "Nie wiem" is selected, validation passes
      if (showDontKnow) {
        final dontKnowValue = _answers[dontKnowKey] as bool?;
        if (dontKnowValue == true) {
          return true;
        }
      }
      
      final hours = _answers['${question.id}_hours'];
      final minutes = _answers['${question.id}_minutes'];
      // Both hours and minutes should be set (can be 0, which is valid)
      return hours != null && minutes != null;
    }
    
    if (compositeType == 'single_hours' || compositeType == 'single_minutes') {
      final value = _answers[question.id];
      // Value should be set (can be 0, which is valid)
      return value != null;
    }
    
    return true;
  }

  int _getIntAnswer(String key) {
    final value = _answers[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    return 0;
  }

  int _getTableInt(String questionId, String rowKey) {
    return _getIntAnswer('${questionId}_$rowKey');
  }

  void _prepareAlertForCurrentSurvey() {
    _showingAlert = false;
    _alertTitle = null;
    _alertMessage = null;

    final surveyId = widget.survey.id;

    // PHQ-2
    if (surveyId == 'PHQ_2') {
      final q1 = _getIntAnswer('phq2_1');
      final q2 = _getIntAnswer('phq2_2');
      final score = q1 + q2;
      
      _showingAlert = true;
      if (score < 3) {
        _alertTitle = 'Alert informacyjny';
        _alertMessage = 'Twój wynik wykonanego testu nie wskazuje obecnie na podwyższone objawy obniżonego nastroju. Ten wynik pochodzi z kwestionariusza przesiewowego i nie stanowi diagnozy.';
      } else {
        _alertTitle = 'Alert ostrzegawczy';
        _alertMessage = 'Twój wynik wykonanego testu sugeruje podwyższone objawy obniżonego nastroju w ostatnich dwóch tygodniach. Nie jest to diagnoza, ale sygnał, że warto rozważyć dalszą ocenę lub rozmowę ze specjalistą. Jeśli potrzebujesz wsparcia już teraz, przejdź do zakładki „Uzyskaj pomoc".';
      }
    }
    
    // GAD-2
    if (surveyId == 'GAD_2') {
      final q1 = _getIntAnswer('gad2_1');
      final q2 = _getIntAnswer('gad2_2');
      final score = q1 + q2;
      
      _showingAlert = true;
      if (score < 3) {
        _alertTitle = 'Alert informacyjny';
        _alertMessage = 'Twój wynik wykonanego testu nie wskazuje obecnie na podwyższony poziom objawów lękowych. Ten wynik nie stanowi diagnozy.';
      } else {
        _alertTitle = 'Alert ostrzegawczy';
        _alertMessage = 'Twój wynik wykonanego testu sugeruje podwyższony poziom objawów lękowych w ostatnich dwóch tygodniach. Nie jest to diagnoza, ale sygnał, że warto rozważyć dalszą ocenę lub kontakt ze specjalistą. W zakładce „Uzyskaj pomoc" znajdziesz dostępne formy wsparcia.';
      }
    }
    
    // PHQ-9
    if (surveyId == 'Baseline_Depression' || surveyId.contains('PHQ_9') || surveyId.contains('phq9')) {
      int score = 0;
      for (int i = 1; i <= 9; i++) {
        score += _getIntAnswer('phq9_$i');
      }
      
      // Sprawdź pytanie 9 (myśli samobójcze) - priorytet najwyższy
      final q9Value = _getIntAnswer('phq9_9');
      if (q9Value >= 1) {
        _showingAlert = true;
        _alertTitle = 'Alert krytyczny';
        _alertMessage = 'Jedna z twoich odpowiedzi wykonanego testu sugeruje obecność myśli o zrobieniu sobie krzywdy lub odebraniu sobie życia. Ten wynik nie jest diagnozą, ale sygnałem wymagającym natychmiastowego działania. Jeśli czujesz, że możesz być w niebezpieczeństwie, zadzwoń 112 lub 999. Szczegółowe numery wsparcia znajdziesz w zakładce „Uzyskaj pomoc".';
      } else if (score >= 20) {
        _showingAlert = true;
        _alertTitle = 'Alert krytyczny';
        _alertMessage = 'Twój wynik wykonanego testu wskazuje na bardzo nasilone objawy depresyjne. Nie jest to diagnoza, jednak zalecany jest pilny kontakt ze specjalistą. W sytuacji nagłej skorzystaj z numerów dostępnych w zakładce „Uzyskaj pomoc" lub zadzwoń 112 / 999.';
      } else if (score >= 15) {
        _showingAlert = true;
        _alertTitle = 'Alert wysoki';
        _alertMessage = 'Twój wynik wykonanego testu wskazuje na nasilone objawy depresyjne. Nie jest to diagnoza, ale zalecany jest kontakt ze specjalistą zdrowia psychicznego. Skorzystaj z informacji dostępnych w zakładce „Uzyskaj pomoc".';
      } else if (score >= 10) {
        _showingAlert = true;
        _alertTitle = 'Alert podwyższony';
        _alertMessage = 'Twój wynik wykonanego testu wskazuje na umiarkowane objawy depresyjne. Nie jest to diagnoza, jednak zalecany jest kontakt ze specjalistą. W zakładce „Uzyskaj pomoc" znajdziesz numery i kontakty do wsparcia.';
      } else if (score >= 5) {
        _showingAlert = true;
        _alertTitle = 'Alert ostrzegawczy';
        _alertMessage = 'Twój wynik wykonanego testu sugeruje łagodne objawy depresyjne. Nie jest to diagnoza. Jeśli objawy utrzymują się lub wpływają na codzienne funkcjonowanie, warto je monitorować lub skonsultować ze specjalistą. W razie potrzeby zajrzyj do zakładki „Uzyskaj pomoc".';
      } else {
        _showingAlert = true;
        _alertTitle = 'Alert informacyjny';
        _alertMessage = 'Twój wynik wykonanego testu wskazuje na brak lub minimalne objawy depresyjne. Ten wynik pochodzi z narzędzia przesiewowego i nie stanowi diagnozy.';
      }
    }
    
    // GAD-7
    if (surveyId == 'Baseline_Stress_And_Anxiety_GAD7' || surveyId.contains('GAD_7') || surveyId.contains('gad7')) {
      int score = 0;
      for (int i = 1; i <= 7; i++) {
        score += _getIntAnswer('gad7_$i');
      }
      
      _showingAlert = true;
      if (score >= 15) {
        _alertTitle = 'Alert wysoki';
        _alertMessage = 'Twój wynik wykonanego testu wskazuje na wysoki poziom objawów lękowych. Nie jest to diagnoza, ale zalecany jest kontakt z psychologiem lub psychiatrą. Skorzystaj z informacji dostępnych w zakładce „Uzyskaj pomoc".';
      } else if (score >= 10) {
        _alertTitle = 'Alert podwyższony';
        _alertMessage = 'Twój wynik wykonanego testu wskazuje na umiarkowany poziom objawów lękowych. Nie jest to diagnoza, jednak zaleca się kontakt ze specjalistą. Pomocne kontakty znajdziesz w zakładce „Uzyskaj pomoc".';
      } else if (score >= 5) {
        _alertTitle = 'Alert ostrzegawczy';
        _alertMessage = 'Twój wynik wykonanego testu sugeruje łagodny poziom objawów lękowych. Nie jest to diagnoza. Warto obserwować objawy i rozważyć strategie radzenia sobie ze stresem. Jeśli potrzebujesz wsparcia, zajrzyj do zakładki „Uzyskaj pomoc".';
      } else {
        _alertTitle = 'Alert informacyjny';
        _alertMessage = 'Twój wynik wykonanego testu nie wskazuje na istotne objawy lękowe. Ten wynik nie stanowi diagnozy.';
      }
    }
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

    // Jeśli pokazujemy alert, przejdź dalej (zamknij alert i zakończ ankietę)
    if (_showingAlert) {
      setState(() {
        _showingAlert = false;
        _alertTitle = null;
        _alertMessage = null;
      });
      widget.onComplete(_answers, isBackNavigation: false);
      return;
    }

    if (_currentStep < _visibleQuestions.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Sprawdź czy trzeba pokazać alert przed zakończeniem
      _prepareAlertForCurrentSurvey();
      if (_showingAlert) {
        setState(() {
          // Alert będzie wyświetlony w build
        });
      } else {
        widget.onComplete(_answers, isBackNavigation: false);
      }
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      // Zapisz odpowiedzi przed powrotem do poprzedniej ankiety
      widget.onComplete(_answers, isBackNavigation: true);
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
    final useGlobalProgress = widget.globalStepOffset != null && widget.globalTotalSteps != null;
    final localProgress = totalSteps > 0 ? (_currentStep + 1) / totalSteps : 0.0;
    final globalProgress = useGlobalProgress && widget.globalTotalSteps! > 0
        ? (widget.globalStepOffset! + _currentStep + 1) / widget.globalTotalSteps!
        : localProgress;
    final progressValue = globalProgress.clamp(0.0, 1.0);
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
          if (widget.showHeaderAndProgress)
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
                              widget.headerTitle ?? widget.survey.title,
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
                              '$percent%',
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
                        value: progressValue,
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
              child: _showingAlert ? _buildAlertContent() : _buildQuestion(currentQuestion),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _canProceed ? _handleNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.inverseTextColor,
                disabledBackgroundColor: AppTheme.primaryColor,
                disabledForegroundColor: AppTheme.inverseTextColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _showingAlert 
                        ? 'Kontynuuj' 
                        : (widget.showFinishLabel && _currentStep == totalSteps - 1 
                            ? 'Zakończ' 
                            : 'Kontynuuj'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isInfoOnly) ...[
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
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: widget.survey.id == 'MINI_EAT' && question.description != null
                ? ClickableQuestionTextWidget(
                    questionText: questionText,
                    tooltipText: question.description,
                    textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  )
                : Text(
                    questionText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
          ),
          // Don't show description as separate text for MINI EAT (it's in the tooltip)
          if (question.description != null && widget.survey.id != 'MINI_EAT') ...[
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
    final isMultiline = question.options?['multiline'] == true;
    final text = _answers[question.id]?.toString() ?? '';
    final controller = _getTextController(question.id, text);

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

  Widget _buildNumberQuestion(SurveyQuestionEntity question) {
    final compositeType = question.options?['composite'] as String?;
    
    // Check if this is a hours_minutes composite picker
    if (compositeType == 'hours_minutes') {
      final showDontKnow = question.options?['showDontKnow'] == true;
      final dontKnowKey = '${question.id}_dont_know';
      final dontKnowValue = _answers[dontKnowKey] as bool? ?? false;
      final primary = Theme.of(context).colorScheme.primary;
      final selectedBg = Color.lerp(primary, Colors.white, 0.5) ?? Theme.of(context).scaffoldBackgroundColor;
      
      final maxHours = question.options?['maxHours'] as int? ?? 23;
      final maxMinutes = question.options?['maxMinutes'] as int? ?? 59;
      final minMinutesIfZeroHours =
          question.options?['minMinutesIfZeroHours'] as int? ?? 0;
      
      // Get hours and minutes from answers, with fallback to cache.
      final cached = _hoursMinutesCache[question.id];
      int hoursValue =
          _answers['${question.id}_hours'] as int? ?? cached?[0] ?? 0;
      int minutesValue =
          _answers['${question.id}_minutes'] as int? ?? cached?[1] ?? 0;

      // Jeśli 0 godzin – minimalnie minMinutesIfZeroHours minut (np. 10 dla aktywności fizycznej).
      if (hoursValue == 0 && minutesValue < minMinutesIfZeroHours) {
        minutesValue = minMinutesIfZeroHours;
      }
      
      // Initialize if not set
      // Nie inicjalizujemy wartości w _answers jeśli użytkownik zaznaczył "Nie wiem"
      // (żeby nie wysyłać tych pól w payloadzie).
      if (!dontKnowValue) {
        if (!_answers.containsKey('${question.id}_hours')) {
          _answers['${question.id}_hours'] = 0;
        }
        if (!_answers.containsKey('${question.id}_minutes')) {
          _answers['${question.id}_minutes'] =
              hoursValue == 0 ? minMinutesIfZeroHours : 0;
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
              onChanged: (hours, minutes) {
                setState(() {
                  final h = hours ?? 0;
                  final m = minutes ?? 0;
                  _hoursMinutesCache[question.id] = [h, m];
                  _answers['${question.id}_hours'] = h;
                  _answers['${question.id}_minutes'] = m;
                  // Also store combined value for backward compatibility
                  _answers[question.id] = h * 60 + m;
                  // Uncheck "Nie wiem" if user selects time
                  if (showDontKnow) {
                    _answers[dontKnowKey] = false;
                  }
                });
              },
            ),
          if (!dontKnowValue) const SizedBox(height: 16),
          // "Nie wiem / Trudno powiedzieć" checkbox (pod pickerem)
          if (showDontKnow)
            GestureDetector(
              onTap: () {
                setState(() {
                  final newValue = !dontKnowValue;
                  _answers[dontKnowKey] = newValue;

                  // Cache aktualnego czasu, żeby po odznaczeniu wrócić do poprzedniego wyboru.
                  _hoursMinutesCache[question.id] = [hoursValue, minutesValue];

                  if (newValue) {
                    // "Zamrażamy" / wyłączamy edycję – i nie wysyłamy wartości w payloadzie.
                    _answers.remove('${question.id}_hours');
                    _answers.remove('${question.id}_minutes');
                    _answers.remove(question.id);
                  } else {
                    // Przywróć wartości z cache
                    final restored = _hoursMinutesCache[question.id];
                    final h = restored?[0] ?? 0;
                    final m = restored?[1] ?? 0;
                    _answers['${question.id}_hours'] = h;
                    _answers['${question.id}_minutes'] = m;
                    _answers[question.id] = h * 60 + m;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: dontKnowValue ? selectedBg : Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(
                    color: primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.zero,
                ),
                child: Row(
                  children: [
                    Icon(
                      dontKnowValue ? Icons.check_box : Icons.check_box_outline_blank,
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
      final maxHours = question.options?['maxHours'] as int? ?? 23;
      final hoursValue = _answers[question.id] as int? ?? 0;
      
      // Initialize if not set
      if (!_answers.containsKey(question.id)) {
        _answers[question.id] = 0;
      }
      
      return SingleHoursPickerWidget(
        hours: hoursValue,
        maxHours: maxHours,
        onChanged: (hours) {
          setState(() {
            _answers[question.id] = hours ?? 0;
          });
        },
      );
    }
    
    // Check if this is a single minutes picker
    if (compositeType == 'single_minutes') {
      final maxMinutes = question.options?['maxMinutes'] as int? ?? 59;
      final minutesValue = _answers[question.id] as int? ?? 0;
      
      // Initialize if not set
      if (!_answers.containsKey(question.id)) {
        _answers[question.id] = 0;
      }
      
      return SingleMinutesPickerWidget(
        minutes: minutesValue,
        maxMinutes: maxMinutes,
        onChanged: (minutes) {
          setState(() {
            _answers[question.id] = minutes ?? 0;
          });
        },
      );
    }
    
    // Regular number input
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

  Widget _buildChoiceQuestion(SurveyQuestionEntity question) {
    final options = question.options?['options'] as List<dynamic>? ?? [];
    final selectedValue = _answers[question.id];

    return Column(
      children: options.map<Widget>((option) {
        final optionValue = option is Map ? option['value'] : option;
        final optionLabel = option is Map ? option['label'] : option.toString();
        final isSelected = selectedValue == optionValue;
        final theme = Theme.of(context);
        final progressColor = theme.colorScheme.secondary;
        // Kolor z paska postępu zmieszany w 50% z białym
        final selectedBackground = Color.lerp(
          progressColor,
          Colors.white,
          0.5,
        )!;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _answers[question.id] = optionValue;
                // Specjalny przypadek: PHQ-9 – aktualizuj znacznik, czy jakikolwiek objaw > 0
                if (question.id.startsWith('phq9_') && question.id != 'phq9_difficulty') {
                  final symptomIds = [
                    'phq9_1',
                    'phq9_2',
                    'phq9_3',
                    'phq9_4',
                    'phq9_5',
                    'phq9_6',
                    'phq9_7',
                    'phq9_8',
                    'phq9_9',
                  ];
                  bool anyPositive = false;
                  for (final id in symptomIds) {
                    final v = _answers[id];
                    if (v is num && v > 0) {
                      anyPositive = true;
                      break;
                    }
                  }
                  _answers['phq9_any_positive'] = anyPositive;
                }
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected
                    ? selectedBackground
                    : theme.colorScheme.surface,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  width: 2,
                ),
                borderRadius: BorderRadius.zero,
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                        width: 2,
                      ),
                      color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      optionLabel,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
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
    final showMarkers = question.options?['showMarkers'] == true;

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

    final valueLabels = question.options?['valueLabels'] as Map<String, dynamic>?;
    final valueLabelsMap = valueLabels?.map((key, value) => MapEntry(key.toString(), value.toString()));

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
      showMarkers: showMarkers,
      valueLabels: valueLabelsMap,
    );
  }

  Widget _buildBooleanQuestion(SurveyQuestionEntity question) {
    final selectedValue = _answers[question.id] as bool?;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    // Kolor z paska postępu zmieszany w 50% z białym
    final selectedBackground = Color.lerp(secondary, Colors.white, 0.5) ??
        Theme.of(context).scaffoldBackgroundColor;

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
                    ? selectedBackground
                    : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  color: primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                'Tak',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: primary,
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
                    ? selectedBackground
                    : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  color: primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                'Nie',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: primary,
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
    } else if (compositeType == 'substance_use') {
      return _buildSubstanceUseCompositeQuestion(question);
    } else if (compositeType == 'somatic_disease') {
      return _buildSomaticDiseaseCompositeQuestion(question);
    }
    
    return _buildBooleanQuestion(question);
  }

  Widget _buildSubstanceUseCompositeQuestion(SurveyQuestionEntity question) {
    final enabledKey = '${question.id}_enabled';
    final frequencyKey = '${question.id}_frequency';
    final enabled = (_answers[enabledKey] as bool?) ?? false;
    final selectedFrequency = _answers[frequencyKey] as String?;
    final frequencies = (question.options?['frequencies'] as List<dynamic>? ?? [])
        .map<Map<String, String>>((f) {
      if (f is Map) {
        return {
          'value': f['value'].toString(),
          'label': f['label'].toString(),
        };
      }
      return {'value': f.toString(), 'label': f.toString()};
    }).toList();

    final substanceLabel = question.options?['substanceLabel'] as String? ?? question.question;
    final substanceDescription = question.options?['substanceDescription'] as String?;

    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final selectedBg = Color.lerp(secondary, Colors.white, 0.5) ??
        Theme.of(context).scaffoldBackgroundColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: primary,
          width: 2,
        ),
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
                      substanceLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    if (substanceDescription != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        substanceDescription,
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: primary,
                        ),
                  ),
                  Switch(
                    value: enabled,
                    onChanged: (value) {
                      setState(() {
                        _answers[enabledKey] = value;
                        if (!value) {
                          // Jeśli NIE -> 0 dni
                          _answers[frequencyKey] = '0';
                          _answers[question.id] = '0';
                        } else {
                          // Jeśli TAK, użytkownik musi wybrać jedną z częstotliwości
                          _answers[frequencyKey] = null;
                          _answers[question.id] = null;
                        }
                      });
                    },
                    thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
                      return primary;
                    }),
                    trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
                      return Theme.of(context).colorScheme.surfaceContainerHighest;
                    }),
                    trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
                      return primary;
                    }),
                  ),
                ],
              ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: 16),
            Text(
              'Jak często?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            Column(
              children: frequencies.map((freq) {
                final value = freq['value']!;
                final label = freq['label']!;
                final isSelected = selectedFrequency == value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _answers[frequencyKey] = value;
                        _answers[question.id] = value;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedBg
                            : Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.zero,
                        border: Border.all(
                          color: primary,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: primary,
                            ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
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
          const SizedBox(height: 24),
          Text(
            'Czy otrzymałeś nową diagnozę?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
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
                          ? (Color.lerp(Theme.of(context).colorScheme.secondary, Colors.white, 0.5) ??
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
                    setState(() {
                      _answers['${question.id}_new_diagnosis'] = false;
                      _answers['${question.id}_new_diagnosis_desc'] = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: newDiagnosis == false
                          ? (Color.lerp(Theme.of(context).colorScheme.secondary, Colors.white, 0.5) ??
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

  Widget _buildSomaticDiseaseCompositeQuestion(SurveyQuestionEntity question) {
    final enabledKey = '${question.id}_enabled';
    final dontKnowKey = '${question.id}_dont_know';
    final subtypesKey = '${question.id}_subtypes';
    final otherTextKey = '${question.id}_other_text';

    final enabled = (_answers[enabledKey] as bool?) ?? false;
    final dontKnow = (_answers[dontKnowKey] as bool?) ?? false;
    final selectedSubtypes =
        List<String>.from(_answers[subtypesKey] as List<dynamic>? ?? const []);

    final subtypes = (question.options?['subtypes'] as List<dynamic>? ?? [])
        .map<Map<String, dynamic>>((s) {
      if (s is Map) {
        return {
          'value': s['value'].toString(),
          'label': s['label'].toString(),
          'allowFreeText': s['allowFreeText'] == true,
        };
      }
      return {'value': s.toString(), 'label': s.toString(), 'allowFreeText': false};
    }).toList();

    final diseaseLabel =
        question.options?['diseaseLabel'] as String? ?? question.question;
    final diseaseDescription =
        question.options?['diseaseDescription'] as String?;
    final hasDontKnow = question.options?['hasDontKnow'] == true;
    final rowKey = question.options?['rowKey'] as String?;

    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final selectedBg = Color.lerp(secondary, Colors.white, 0.5) ??
        Theme.of(context).scaffoldBackgroundColor;

    final otherTextInitial = _answers[otherTextKey]?.toString() ?? '';
    final otherTextController = TextEditingController(text: otherTextInitial);

    // Special case: "Inne choroby somatyczne" - show text field directly when enabled
    if (rowKey == 'other') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.zero,
          border: Border.all(
            color: primary,
            width: 2,
          ),
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: primary,
                          ),
                    ),
                    Switch(
                      value: enabled,
                      onChanged: (value) {
                        setState(() {
                          _answers[enabledKey] = value;
                          if (value) {
                            // "Tak" – resetuj status "Nie wiem".
                            _answers[dontKnowKey] = false;
                            _answers[question.id] = 'yes';
                            _answers['${question.id}_status'] = 'yes';
                          } else {
                            // "Nie" – brak choroby.
                            _answers[question.id] = 'no';
                            _answers['${question.id}_status'] = 'no';
                            _answers[otherTextKey] = '';
                          }
                        });
                      },
                      thumbColor: WidgetStateProperty.resolveWith<Color?>(
                          (states) {
                        return primary;
                      }),
                      trackColor: WidgetStateProperty.resolveWith<Color?>(
                          (states) {
                        return Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest;
                      }),
                      trackOutlineColor:
                          WidgetStateProperty.resolveWith<Color?>((states) {
                        return primary;
                      }),
                    ),
                  ],
                ),
              ],
            ),
            if (hasDontKnow) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    final newValue = !dontKnow;
                    _answers[dontKnowKey] = newValue;
                    if (newValue) {
                      _answers[enabledKey] = false;
                      _answers[question.id] = 'dont_know';
                      _answers['${question.id}_status'] = 'dont_know';
                      _answers[otherTextKey] = '';
                    } else {
                      _answers[question.id] = null;
                      _answers['${question.id}_status'] = null;
                    }
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: dontKnow
                        ? selectedBg
                        : Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                      color: primary,
                      width: 2,
                    ),
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
                controller: otherTextController,
                onChanged: (value) {
                  setState(() {
                    _answers[otherTextKey] = value;
                  });
                },
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Wpisz jakie...',
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
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
      );
    }

    // Regular somatic disease question
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: primary,
          width: 2,
        ),
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
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: primary,
                        ),
                  ),
                  Switch(
                    value: enabled,
                    onChanged: (value) {
                      setState(() {
                        _answers[enabledKey] = value;
                        if (value) {
                          // "Tak" – resetuj status "Nie wiem".
                          _answers[dontKnowKey] = false;
                          _answers[question.id] = 'yes';
                          _answers['${question.id}_status'] = 'yes';
                        } else {
                          // "Nie" – brak choroby.
                          _answers[question.id] = 'no';
                          _answers['${question.id}_status'] = 'no';
                          _answers[subtypesKey] = [];
                        }
                      });
                    },
                    thumbColor: WidgetStateProperty.resolveWith<Color?>(
                        (states) {
                      return primary;
                    }),
                    trackColor: WidgetStateProperty.resolveWith<Color?>(
                        (states) {
                      return Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest;
                    }),
                    trackOutlineColor:
                        WidgetStateProperty.resolveWith<Color?>((states) {
                      return primary;
                    }),
                  ),
                ],
              ),
            ],
          ),
          if (hasDontKnow) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                setState(() {
                  final newValue = !dontKnow;
                  _answers[dontKnowKey] = newValue;
                  if (newValue) {
                    _answers[enabledKey] = false;
                    _answers[question.id] = 'dont_know';
                    _answers['${question.id}_status'] = 'dont_know';
                    _answers[subtypesKey] = [];
                  } else {
                    _answers[question.id] = null;
                    _answers['${question.id}_status'] = null;
                  }
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: dontKnow
                      ? selectedBg
                      : Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(
                    color: primary,
                    width: 2,
                  ),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
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
                          setState(() {
                            final current =
                                List<String>.from(selectedSubtypes);
                            if (current.contains(value)) {
                              current.remove(value);
                              if (allowFreeText) {
                                _answers[otherTextKey] = '';
                              }
                            } else {
                              current.add(value);
                            }
                            _answers[subtypesKey] = current;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? selectedBg
                                : Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.zero,
                            border: Border.all(
                              color: primary,
                              width: 2,
                            ),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
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
                          controller: otherTextController,
                          onChanged: (value) {
                            setState(() {
                              _answers[otherTextKey] = value;
                            });
                          },
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Wpisz jakie...',
                            filled: true,
                            fillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
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
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicationsCompositeQuestion(SurveyQuestionEntity question) {
    final medsChanged = _answers[question.id] as bool?;
    final medications =
        (_answers['${question.id}_medications'] as List<dynamic>?) ?? [];

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    return Column(
      children: [
        _buildBooleanQuestion(question),
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
            final strengths =
                manual ? const <String>[] : _medicationStrengthsCache[name] ?? const <String>[];
            final hasStrengths = strengths.isNotEmpty;

            // Jeśli mamy nazwę leku, a nie ma jeszcze dawek w cache,
            // dociągnij je asynchronicznie z serwisu na podstawie pliku JSON.
            if (name.isNotEmpty && !manual &&
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
                  border: Border.all(
                    color: primary,
                    width: 2,
                  ),
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
                          setState(() {
                            final newMeds =
                                List<Map<String, dynamic>>.from(medications);
                            newMeds[index]['name'] = value;
                            // resetuj dawkę przy zmianie leku
                            newMeds[index]['dose'] = null;
                            newMeds[index]['dosage'] = null;
                            newMeds[index]['doseDontKnow'] = false;
                            newMeds[index]['selectedStrength'] = null;
                            newMeds[index]['manual'] = false;
                            _answers['${question.id}_medications'] = newMeds;
                          });
                          // Po wybraniu leku dociągnij listę dawek.
                          _medicationApiService
                              .getStrengthsFor(value)
                              .then((values) {
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
                          setState(() {
                            final newMeds =
                                List<Map<String, dynamic>>.from(medications);
                            newMeds[index]['name'] = value;
                            _answers['${question.id}_medications'] = newMeds;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Wpisz nazwę leku',
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
                                  setState(() {
                                    final newMeds =
                                        List<Map<String, dynamic>>.from(
                                            medications);
                                    newMeds[index]['selectedStrength'] = s;
                                    newMeds[index]['dose'] = s;
                                    newMeds[index]['dosage'] = s;
                                    _answers['${question.id}_medications'] =
                                        newMeds;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
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
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(
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
                                setState(() {
                                  final newMeds =
                                      List<Map<String, dynamic>>.from(
                                          medications);
                                  newMeds[index]['selectedStrength'] =
                                      '_other';
                                  // Nie nadpisujemy od razu dawki – użytkownik wpisze niżej.
                                  _answers['${question.id}_medications'] =
                                      newMeds;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
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
                                  border: Border.all(
                                    color: primary,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  'Inna',
                                  style:
                                      theme.textTheme.bodyMedium?.copyWith(
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
                                setState(() {
                                  final newMeds =
                                      List<Map<String, dynamic>>.from(
                                          medications);
                                  newMeds[index]['dose'] = value;
                                  newMeds[index]['dosage'] = value;
                                  _answers['${question.id}_medications'] =
                                      newMeds;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'np. 10 mg, 2x dziennie',
                                hintStyle:
                                    theme.textTheme.bodyMedium?.copyWith(
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
                          setState(() {
                            final newMeds =
                                List<Map<String, dynamic>>.from(medications);
                            newMeds[index]['dose'] = value;
                            newMeds[index]['dosage'] = value;
                            _answers['${question.id}_medications'] = newMeds;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'np. 10 mg, 2x dziennie',
                          hintStyle:
                              theme.textTheme.bodyMedium?.copyWith(
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

                    if (!manual) ...[
                      const SizedBox(height: 8),
                      // "Nie wiem" dla dawki – tylko w trybie automatycznym.
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            final newMeds =
                                List<Map<String, dynamic>>.from(medications);
                            final newValue = !doseDontKnow;
                            newMeds[index]['doseDontKnow'] = newValue;
                            if (newValue) {
                              newMeds[index]['dose'] = null;
                              newMeds[index]['dosage'] = null;
                            }
                            _answers['${question.id}_medications'] = newMeds;
                          });
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
                            border: Border.all(
                              color: primary,
                              width: 2,
                            ),
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
                        setState(() {
                          final newMeds =
                              List<Map<String, dynamic>>.from(medications);
                          final newManual = !manual;
                          newMeds[index]['manual'] = newManual;
                          if (newManual) {
                            // Czyścimy dawkę i znacznik "Nie wiem".
                            newMeds[index]['dose'] = null;
                            newMeds[index]['dosage'] = null;
                            newMeds[index]['doseDontKnow'] = false;
                            newMeds[index]['selectedStrength'] = null;
                          }
                          _answers['${question.id}_medications'] = newMeds;
                        });
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
                          border: Border.all(
                            color: primary,
                            width: 2,
                          ),
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
                            setState(() {
                              final newMeds =
                                  List<Map<String, dynamic>>.from(medications);
                              newMeds.removeAt(index);
                              _answers['${question.id}_medications'] = newMeds;
                            });
                          },
                          icon: Icon(Icons.remove_circle, color: Colors.red[400]),
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
              setState(() {
                final newMeds = List<Map<String, dynamic>>.from(medications);
                newMeds.add({
                  'name': '',
                  'dose': null,
                  'dosage': null,
                  'doseDontKnow': false,
                });
                _answers['${question.id}_medications'] = newMeds;
              });
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

  Widget _buildYearPicker(SurveyQuestionEntity question) {
    final currentValue = _answers[question.id]?.toString() ?? '1990';
    final minYear = question.options?['minYear'] as int? ?? 1925;
    final maxYear = question.options?['maxYear'] as int? ?? DateTime.now().year;
    final defaultYear = question.options?['defaultYear'] as int? ?? 1990;

    return custom_pickers.YearPicker(
      value: currentValue,
      onChange: (value) {
        setState(() {
          _answers[question.id] = value;
        });
      },
      minYear: minYear,
      maxYear: maxYear,
      defaultYear: defaultYear,
    );
  }

  Widget _buildHeightPicker(SurveyQuestionEntity question) {
    final currentValue = _answers[question.id]?.toString() ?? '170';

    return HeightPicker(
      height: currentValue,
      onHeightChanged: (value) {
        setState(() {
          _answers[question.id] = value;
        });
      },
    );
  }

  Widget _buildWeightPicker(SurveyQuestionEntity question) {
    final currentValue = _answers[question.id]?.toString() ?? '70';

    return WeightPicker(
      weight: currentValue,
      onWeightChanged: (value) {
        setState(() {
          _answers[question.id] = value;
        });
      },
    );
  }

  Widget _buildIconGridQuestion(SurveyQuestionEntity question) {
    final iconOptions = question.options?['iconOptions'] as List<dynamic>? ?? [];
    final selectedValue = _answers[question.id]?.toString() ?? '';
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
        setState(() {
          _answers[question.id] = value;
        });
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

