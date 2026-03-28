import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/features/surveys/widgets/universal_survey_widget.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:braves_cog/features/surveys/config/survey_flow_rules.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';

bool _isAlertSurvey(String surveyId) {
  if (surveyId == 'PHQ_2' || surveyId == 'GAD_2') return true;
  if (surveyId == 'Baseline_Depression' ||
      surveyId.contains('PHQ_9') ||
      surveyId.contains('phq9')) {
    return true;
  }
  if (surveyId == 'Baseline_Stress_And_Anxiety_GAD7' ||
      surveyId.contains('GAD_7') ||
      surveyId.contains('gad7')) {
    return true;
  }
  if (surveyId == 'Baseline_ASD' ||
      surveyId.contains('AQ') ||
      surveyId.contains('aq')) {
    return true;
  }
  return false;
}

class OnboardingFlowWidget extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onComplete;

  const OnboardingFlowWidget({
    super.key,
    required this.onBack,
    required this.onComplete,
  });

  @override
  ConsumerState<OnboardingFlowWidget> createState() =>
      _OnboardingFlowWidgetState();
}

class _OnboardingFlowWidgetState extends ConsumerState<OnboardingFlowWidget> {
  int _currentModuleIndex = 0;
  int _currentSurveyIndex = 0;
  final Map<String, dynamic> _allAnswers = {};
  bool _startAtEndForCurrentSurvey = false;
  final Set<String> _alertSurveysCompleted = {};
  bool _isLoadingProgress = true;

  late List<Map<String, dynamic>> _modules;

  @override
  void initState() {
    super.initState();
    _initializeFlow();
  }

  Future<void> _initializeFlow() async {
    final profile = ref.read(profileProvider).profile;
    final baseModules = SurveyFlowRules.getOnboardingModules(profile.type);
    final authUserId = ref.read(authProvider).user?.id;

    Map<String, Map<String, dynamic>> completedSurveyAnswers = {};
    if (authUserId != null) {
      try {
        completedSurveyAnswers = await ref
            .read(surveyRemoteDataSourceProvider)
            .getCompletedSurveyAnswersByType(
              userId: authUserId,
              surveyType: 'onboarding',
            );
      } catch (e) {
        debugPrint(
          '[OnboardingFlowWidget] Failed to load onboarding progress from backend: $e',
        );
      }
    }

    final filteredModules = <Map<String, dynamic>>[];

    for (final module in baseModules) {
      final moduleId = module['id'] as String;
      final surveys = (module['surveys'] as List).cast<Map<String, dynamic>>();
      final remainingSurveys = <Map<String, dynamic>>[];

      for (final surveyMeta in surveys) {
        final surveyId = surveyMeta['id'] as String;
        final completedAnswers = completedSurveyAnswers[surveyId];

        if (completedAnswers != null) {
          if (!_allAnswers.containsKey(moduleId)) {
            _allAnswers[moduleId] = <String, dynamic>{};
          }
          final moduleAnswers = _allAnswers[moduleId] as Map<String, dynamic>;
          moduleAnswers[surveyId] = completedAnswers;
        } else {
          remainingSurveys.add(surveyMeta);
        }
      }

      if (remainingSurveys.isNotEmpty) {
        filteredModules.add({...module, 'surveys': remainingSurveys});
      }
    }

    if (!mounted) return;

    setState(() {
      _modules = filteredModules;
      _currentModuleIndex = 0;
      _currentSurveyIndex = 0;
      _isLoadingProgress = false;
    });

    if (filteredModules.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onComplete(_allAnswers);
        }
      });
    }
  }

  void _handleSurveyComplete(
    Map<String, dynamic> answers, {
    bool isBackNavigation = false,
  }) {
    final currentModule = _modules[_currentModuleIndex];
    final currentSurvey = currentModule['surveys'][_currentSurveyIndex];
    final surveyId = currentSurvey['id'];

    if (!_allAnswers.containsKey(currentModule['id'])) {
      _allAnswers[currentModule['id']] = <String, dynamic>{};
    }
    final moduleMap = _allAnswers[currentModule['id']] as Map<String, dynamic>;
    moduleMap[surveyId as String] = answers;

    if (isBackNavigation) return;

    if (_isAlertSurvey(surveyId)) {
      _alertSurveysCompleted.add(surveyId);
    }

    int nextM = _currentModuleIndex;
    int nextS = _currentSurveyIndex;
    final surveys = currentModule['surveys'] as List;
    if (nextS < surveys.length - 1) {
      nextS++;
    } else if (nextM < _modules.length - 1) {
      nextM++;
      nextS = 0;
    } else {
      widget.onComplete(_allAnswers);
      return;
    }
    while (nextM < _modules.length) {
      final nextSurveys = _modules[nextM]['surveys'] as List;
      if (nextS >= nextSurveys.length) {
        nextM++;
        nextS = 0;
        continue;
      }
      final nextId = nextSurveys[nextS]['id'] as String;
      if (!_alertSurveysCompleted.contains(nextId)) break;
      nextS++;
      if (nextS >= nextSurveys.length) {
        nextM++;
        nextS = 0;
      }
    }
    setState(() {
      _currentModuleIndex = nextM;
      _currentSurveyIndex = nextS;
      _startAtEndForCurrentSurvey = false;
    });
    if (nextM >= _modules.length) {
      widget.onComplete(_allAnswers);
    }
  }

  void _handleBack() {
    int targetModule = _currentModuleIndex;
    int targetSurvey = _currentSurveyIndex;
    if (targetSurvey > 0) {
      targetSurvey--;
    } else if (targetModule > 0) {
      targetModule--;
      targetSurvey = (_modules[targetModule]['surveys'] as List).length - 1;
    } else {
      widget.onBack();
      return;
    }
    while (targetModule >= 0 &&
        _isAlertSurvey(
          (_modules[targetModule]['surveys'][targetSurvey]['id'] as String),
        )) {
      if (targetSurvey > 0) {
        targetSurvey--;
      } else if (targetModule > 0) {
        targetModule--;
        targetSurvey = (_modules[targetModule]['surveys'] as List).length - 1;
      } else {
        widget.onBack();
        return;
      }
    }
    setState(() {
      _currentModuleIndex = targetModule;
      _currentSurveyIndex = targetSurvey;
      _startAtEndForCurrentSurvey = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProgress) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    int m = _currentModuleIndex;
    int s = _currentSurveyIndex;
    while (m < _modules.length) {
      final surveys = _modules[m]['surveys'] as List;
      if (s >= surveys.length) {
        m++;
        s = 0;
        continue;
      }
      final sid = surveys[s]['id'] as String;
      if (!_alertSurveysCompleted.contains(sid)) break;
      s++;
      if (s >= surveys.length) {
        m++;
        s = 0;
      }
    }
    if (m >= _modules.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onComplete(_allAnswers);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (m != _currentModuleIndex || s != _currentSurveyIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentModuleIndex = m;
            _currentSurveyIndex = s;
            _startAtEndForCurrentSurvey = false;
          });
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
      moduleAnswers = Map<String, dynamic>.from(rawModuleAnswers);
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
        body: Center(child: Text('Brak pytań w ankiecie: ${survey.id}')),
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
      surveySubmissionId: surveyId,
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
