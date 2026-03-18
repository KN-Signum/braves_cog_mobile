import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/widgets/universal_survey_widget.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:braves_cog/features/surveys/config/survey_flow_rules.dart';
import 'package:braves_cog/features/surveys/config/survey_configs/mini_eat_survey_config.dart';

bool _isAlertSurvey(String surveyId) {
  if (surveyId == 'PHQ_2' || surveyId == 'GAD_2') return true;
  if (surveyId == 'Baseline_Depression' ||
      surveyId.contains('PHQ_9') ||
      surveyId.contains('phq9')) return true;
  if (surveyId == 'Baseline_Stress_And_Anxiety_GAD7' ||
      surveyId.contains('GAD_7') ||
      surveyId.contains('gad7')) return true;
  return false;
}

class ScreeningFlowWidget extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onComplete;

  const ScreeningFlowWidget({
    super.key,
    required this.onBack,
    required this.onComplete,
  });

  @override
  ConsumerState<ScreeningFlowWidget> createState() =>
      _ScreeningFlowWidgetState();
}

class _ScreeningFlowWidgetState extends ConsumerState<ScreeningFlowWidget> {
  int _currentSurveyIndex = 0;
  final Map<String, dynamic> _allAnswers = {};
  bool _startAtEndForCurrentSurvey = false;
  /// Ankiety alertowe, po których pokazano alert – nie pokazujemy ich już w flow.
  final Set<String> _alertSurveysCompleted = {};

  late List<Map<String, dynamic>> _surveys;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).profile;
    _surveys = SurveyFlowRules.getScreeningSurveys(profile.type);
  }

  void _handleSurveyComplete(
    Map<String, dynamic> answers, {
    bool isBackNavigation = false,
  }) {
    final currentSurveyId = _surveys[_currentSurveyIndex]['id'];
    _allAnswers[currentSurveyId] = answers;

    // Jeśli to nawigacja wstecz, tylko zapisz odpowiedzi, nie przechodź dalej
    if (isBackNavigation) {
      return;
    }

    if (currentSurveyId == 'screening_diet') {
      final dietChangedRaw = answers['diet_changed'];
      final dietChanged = dietChangedRaw == true ||
          dietChangedRaw == 1 ||
          dietChangedRaw == 'true';
      setState(() {
        // Usuwamy dynamicznie dodaną wcześniej MINI_EAT (jeśli była)
        // i dodajemy ją ponownie tylko gdy odpowiedź to "Tak".
        _surveys = List<Map<String, dynamic>>.from(_surveys)
          ..removeWhere(
            (e) => (e['id'] as String?) == 'MINI_EAT',
          );

        if (dietChanged) {
          _surveys.insert(
            _currentSurveyIndex + 1,
            {
              'id': 'MINI_EAT',
              'config': MiniEatSurveyConfig.getSurvey(),
            },
          );
        }

        _currentSurveyIndex++;
        _startAtEndForCurrentSurvey = false;

        // Pomijamy ankiety alertowe, które zostały już ukończone.
        while (_currentSurveyIndex < _surveys.length &&
            _alertSurveysCompleted.contains(
                _surveys[_currentSurveyIndex]['id'] as String)) {
          _currentSurveyIndex++;
        }
      });

      if (_currentSurveyIndex >= _surveys.length) {
        widget.onComplete(_allAnswers);
      }

      return;
    }

    if (_isAlertSurvey(currentSurveyId)) {
      _alertSurveysCompleted.add(currentSurveyId);
    }

    if (_currentSurveyIndex < _surveys.length - 1) {
      setState(() {
        _currentSurveyIndex++;
        _startAtEndForCurrentSurvey = false;
        while (_currentSurveyIndex < _surveys.length &&
            _alertSurveysCompleted.contains(
                _surveys[_currentSurveyIndex]['id'] as String)) {
          _currentSurveyIndex++;
        }
      });
      if (_currentSurveyIndex >= _surveys.length) {
        widget.onComplete(_allAnswers);
      }
    } else {
      widget.onComplete(_allAnswers);
    }
  }

  void _handleBack() {
    if (_currentSurveyIndex > 0) {
      int targetIndex = _currentSurveyIndex - 1;
      while (targetIndex >= 0 &&
          _isAlertSurvey(_surveys[targetIndex]['id'] as String)) {
        targetIndex--;
      }
      if (targetIndex < 0) {
        widget.onBack();
      } else {
        setState(() {
          _currentSurveyIndex = targetIndex;
          _startAtEndForCurrentSurvey = true;
        });
      }
    } else {
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    int index = _currentSurveyIndex;
    while (index < _surveys.length &&
        _alertSurveysCompleted.contains(_surveys[index]['id'] as String)) {
      index++;
    }
    if (index >= _surveys.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onComplete(_allAnswers);
      });
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }
    if (index != _currentSurveyIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _currentSurveyIndex = index);
      });
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }
    final currentMeta = _surveys[_currentSurveyIndex];
    final currentSurvey = currentMeta['config'] as SurveyEntity;
    final currentSurveyId = currentMeta['id'] as String;
    final initialAnswers =
        _allAnswers[currentSurveyId] as Map<String, dynamic>?;

    if (currentSurvey.questions.isEmpty) {
      return Scaffold(
        body: Center(child: Text('Brak pytań w ankiecie: ${currentSurvey.id}')),
      );
    }

    // Global progress liczony po WSZYSTKICH pytaniach we wszystkich ankietach screeningu.
    int totalQuestions = 0;
    int questionOffset = 0;
    for (int i = 0; i < _surveys.length; i++) {
      final meta = _surveys[i];
      final survey = meta['config'] as SurveyEntity;
      final qCount = survey.questions.length;
      if (i < _currentSurveyIndex) {
        questionOffset += qCount;
      }
      totalQuestions += qCount;
    }

    return UniversalSurveyWidget(
      survey: currentSurvey,
      onComplete: _handleSurveyComplete,
      onBack: _handleBack,
      showHeaderAndProgress: true,
      globalStepOffset: questionOffset,
      globalTotalSteps: totalQuestions,
      startAtLastQuestion: _startAtEndForCurrentSurvey,
      showFinishLabel: _currentSurveyIndex == _surveys.length - 1,
      initialAnswers: initialAnswers,
    );
  }
}
