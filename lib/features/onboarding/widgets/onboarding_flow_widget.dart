import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/surveys/widgets/universal_survey_widget.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/demographic_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/ipaq_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/screening_sq_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/mini_eat_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/screening_su_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/brief_2way_sss_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/aq_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/gad_7_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/pss_10_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/phq_9_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/somatic_diseases_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/somatic_drugs_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/mental_disorders_survey_config.dart';
import 'package:braves_cog/features/surveys/data/survey_configs/medications_survey_config.dart';

class OnboardingFlowWidget extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onComplete;

  const OnboardingFlowWidget({
    super.key,
    required this.onBack,
    required this.onComplete,
  });

  @override
  ConsumerState<OnboardingFlowWidget> createState() => _OnboardingFlowWidgetState();
}

class _OnboardingFlowWidgetState extends ConsumerState<OnboardingFlowWidget> {
  int _currentModuleIndex = 0;
  int _currentSurveyIndex = 0;
  final Map<String, dynamic> _allAnswers = {};
  bool _startAtEndForCurrentSurvey = false;

  final List<Map<String, dynamic>> _modules = [
    {
      'id': 'Demographic',
      'name': 'Dane demograficzne',
      'surveys': [
        {'id': 'Demographic', 'config': DemographicSurveyConfig.getSurvey()},
      ],
    },
    {
      'id': 'Baseline_Lifestyle',
      'name': 'Styl życia',
      'surveys': [
        {'id': 'Baseline_Physical_Activity', 'config': IPAQSurveyConfig.getSurvey()},
        {'id': 'Baseline_Sleep_Quality', 'config': ScreeningSQSurveyConfig.getSurvey()},
        {'id': 'Baseline_Eating_Habits', 'config': MiniEatSurveyConfig.getSurvey()},
        {'id': 'Baseline_Substance_Use', 'config': ScreeningSUSurveyConfig.getSurvey()},
        {'id': 'Baseline_Social_Support', 'config': Brief2WaySSSSurveyConfig.getSurvey()},
      ],
    },
    {
      'id': 'Baseline_Symptoms',
      'name': 'Profil psychologiczny',
      'surveys': [
        {'id': 'Baseline_ASD', 'config': AQSurveyConfig.getSurvey()},
        {'id': 'Baseline_Stress_And_Anxiety_GAD7', 'config': GAD7SurveyConfig.getSurvey()},
        {'id': 'Baseline_Stress_And_Anxiety_PSS10', 'config': PSS10SurveyConfig.getSurvey()},
        {'id': 'Baseline_Depression', 'config': PHQ9SurveyConfig.getSurvey()},
      ],
    },
    {
      'id': 'Baseline_Medical_History',
      'name': 'Informacje zdrowotne',
      'surveys': [
        {'id': 'Baseline_Somatic_Disease', 'config': SomaticDiseasesSurveyConfig.getSurvey()},
        {'id': 'Baseline_Mental_Health_Disorders', 'config': MentalDisordersSurveyConfig.getSurvey()},
        {'id': 'Baseline_Medications', 'config': MedicationsSurveyConfig.getSurvey()},
      ],
    },
  ];

  void _handleSurveyComplete(Map<String, dynamic> answers, {bool isBackNavigation = false}) {
    final currentModule = _modules[_currentModuleIndex];
    final currentSurvey = currentModule['surveys'][_currentSurveyIndex];
    final surveyId = currentSurvey['id'];
    
    if (!_allAnswers.containsKey(currentModule['id'])) {
      _allAnswers[currentModule['id']] = <String, dynamic>{};
    }
    final moduleMap =
        _allAnswers[currentModule['id']] as Map<String, dynamic>;
    moduleMap[surveyId as String] = answers;

    // Jeśli to nawigacja wstecz, tylko zapisz odpowiedzi, nie przechodź dalej
    if (isBackNavigation) {
      return;
    }

    if (_currentSurveyIndex < (currentModule['surveys'] as List).length - 1) {
      setState(() {
        _currentSurveyIndex++;
        _startAtEndForCurrentSurvey = false;
      });
    } else {
      if (_currentModuleIndex < _modules.length - 1) {
        setState(() {
          _currentModuleIndex++;
          _currentSurveyIndex = 0;
          _startAtEndForCurrentSurvey = false;
        });
      } else {
        widget.onComplete(_allAnswers);
      }
    }
  }

  void _handleBack() {
    if (_currentSurveyIndex > 0) {
      setState(() {
        _currentSurveyIndex--;
        _startAtEndForCurrentSurvey = true;
      });
    } else if (_currentModuleIndex > 0) {
      setState(() {
        _currentModuleIndex--;
        final previousModule = _modules[_currentModuleIndex];
        _currentSurveyIndex = (previousModule['surveys'] as List).length - 1;
        _startAtEndForCurrentSurvey = true;
      });
    } else {
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentModule = _modules[_currentModuleIndex];
    final currentSurvey = currentModule['surveys'][_currentSurveyIndex];
    final survey = currentSurvey['config'] as SurveyEntity;
    final surveyId = currentSurvey['id'] as String;
    final moduleId = currentModule['id'] as String;

    Map<String, dynamic>? moduleAnswers;
    final rawModuleAnswers = _allAnswers[moduleId];
    if (rawModuleAnswers is Map<String, dynamic>) {
      moduleAnswers = rawModuleAnswers;
    } else if (rawModuleAnswers is Map) {
      moduleAnswers = Map<String, dynamic>.from(rawModuleAnswers as Map);
    }

    final initialAnswers = moduleAnswers != null
        ? moduleAnswers[surveyId] as Map<String, dynamic>?
        : null;
    final isLastModule = _currentModuleIndex == _modules.length - 1;
    final isLastSurveyInModule =
        _currentSurveyIndex == (currentModule['surveys'] as List).length - 1;
    final isLastSurveyInFlow = isLastModule && isLastSurveyInModule;

    if (survey.questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Brak pytań w ankiecie: ${survey.id}'),
        ),
      );
    }

    // Global progress liczony po WSZYSTKICH pytaniach we wszystkich ankietach onbordingu
    int totalQuestions = 0;
    int questionOffset = 0;
    for (int m = 0; m < _modules.length; m++) {
      final module = _modules[m];
      final surveys = module['surveys'] as List;
      for (int s = 0; s < surveys.length; s++) {
        final sEntity = surveys[s]['config'] as SurveyEntity;
        final qCount = sEntity.questions.length;
        if (m < _currentModuleIndex ||
            (m == _currentModuleIndex && s < _currentSurveyIndex)) {
          questionOffset += qCount;
        }
        totalQuestions += qCount;
      }
    }

    return UniversalSurveyWidget(
      survey: survey,
      onComplete: _handleSurveyComplete,
      onBack: _handleBack,
      showHeaderAndProgress: true,
      globalStepOffset: questionOffset,
      globalTotalSteps: totalQuestions,
      headerTitle: currentModule['name'] as String?,
      startAtLastQuestion: _startAtEndForCurrentSurvey,
      showFinishLabel: isLastSurveyInFlow,
      initialAnswers: initialAnswers,
    );
  }
}










