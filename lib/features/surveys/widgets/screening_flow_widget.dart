import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/widgets/universal_survey_widget.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:braves_cog/features/surveys/config/survey_flow_rules.dart';
import 'package:braves_cog/features/surveys/config/survey_configs/mini_eat_survey_config.dart';

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
      final dietChanged = answers['diet_changed'];
      if (dietChanged == true) {
        setState(() {
          _surveys.add({
            'id': 'MINI_EAT',
            'config': MiniEatSurveyConfig.getSurvey(),
          });
          _currentSurveyIndex++;
        });
        return;
      } else {}
    }

    if (_currentSurveyIndex < _surveys.length - 1) {
      setState(() {
        _currentSurveyIndex++;
        _startAtEndForCurrentSurvey = false;
      });
    } else {
      widget.onComplete(_allAnswers);
    }
  }

  void _handleBack() {
    if (_currentSurveyIndex > 0) {
      setState(() {
        _currentSurveyIndex--;
        _startAtEndForCurrentSurvey = true;
      });
    } else {
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
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
