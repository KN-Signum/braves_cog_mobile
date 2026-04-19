import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_package/research_package.dart';
import 'package:braves_cog/features/cognitive_games/data/mappers/rp_result_mapper.dart';
import 'package:braves_cog/features/cognitive_games/domain/entities/cognitive_game_result.dart';
import 'package:braves_cog/features/cognitive_games/presentation/providers/cognitive_game_provider.dart';
import '../cognition_config.dart';

class CognitiveGamesLauncher {
  static const Map<String, CognitiveTestType> _stepMap = {
    'stroop_ffect_step': CognitiveTestType.stroop,
    'trail_making_step': CognitiveTestType.trailMaking,
    'flanker_step': CognitiveTestType.flanker,
    'RVIP_step': CognitiveTestType.rvip,
    'tapping_step': CognitiveTestType.tapping,
    'corsi_block_step': CognitiveTestType.corsiBlock,
    'reaction_time_step': CognitiveTestType.reactionTime,
  };

  static void launchFullSequence(
    BuildContext context,
    WidgetRef ref,
    VoidCallback? onComplete,
  ) {
    final List<RPStep> steps = [];

    _stepMap.forEach((stepId, testType) {
      steps.add(_getStepById(stepId));
    });

    steps.shuffle();

    steps.add(
      RPCompletionStep(
        identifier: 'sequence_completion',
        title: 'Świetna robota!',
        text: 'Dziękujemy za Twój wkład w badania. Trening został ukończony.',
      ),
    );

    final task = RPOrderedTask(
      identifier: 'full_cognitive_sequence',
      steps: steps,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _CognitiveTaskScreen(
          task: task,
          onComplete: (result) async {
            final saved = await _processSequenceResults(ref, result);
            // Pop the fullscreen task route FIRST so the navigation
            // stack returns to the caller before onComplete fires.
            if (context.mounted) Navigator.of(context).pop();
            if (saved) {
              onComplete?.call();
            }
            // On failure: the user is back on FinalScreen and can retry.
            // No SnackBar here — context is potentially deactivated after pop.
          },
        ),
      ),
    );
  }

  static Future<bool> _processSequenceResults(
    WidgetRef ref,
    RPTaskResult taskResult,
  ) async {
    try {
      final authState = ref.read(authProvider);
      final userId = authState.user?.id;

      if (userId == null) {
        debugPrint('❌ Użytkownik nie zalogowany');
        return false;
      }

      final List<CognitiveTestResult> collectedResults = [];
      final fullJson = taskResult.toJson();
      final resultsNode = fullJson['results'] as Map<String, dynamic>?;

      if (resultsNode == null) {
        debugPrint('❌ Brak wyników z testu');
        return false;
      }

      _stepMap.forEach((stepId, testType) {
        if (resultsNode.containsKey(stepId)) {
          try {
            final cleanResult = RPResultMapper.fromRPTaskResult(
              taskResult: taskResult,
              userId: userId,
              testType: testType,
              stepIdentifier: stepId,
            );
            collectedResults.add(cleanResult);
          } catch (e) {
            debugPrint('❌ Błąd mapowania kroku $stepId: $e');
          }
        }
      });

      if (collectedResults.isEmpty) {
        debugPrint('❌ Brak wyników do zapisania');
        return false;
      }

      debugPrint(
        '📊 [CognitiveGamesLauncher] Wysyłanie ${collectedResults.length} wyników...',
      );

      final saved = await ref
          .read(cognitiveGamesProvider.notifier)
          .saveSequenceResults(collectedResults);

      return saved;
    } catch (e) {
      debugPrint("❌ Krytyczny błąd przetwarzania wyników: $e");
      return false;
    }
  }

  /// New method with structured feedback for FinalScreen and GamesScreen
  static void launchFullSequenceWithFeedback({
    required BuildContext context,
    required WidgetRef ref,
    required VoidCallback onSuccess,
    required Function(String errorMessage) onError,
  }) {
    final List<RPStep> steps = [];

    _stepMap.forEach((stepId, testType) {
      steps.add(_getStepById(stepId));
    });

    steps.shuffle();

    steps.add(
      RPCompletionStep(
        identifier: 'sequence_completion',
        title: 'Świetna robota!',
        text: 'Dziękujemy za Twój wkład w badania. Trening został ukończony.',
      ),
    );

    final task = RPOrderedTask(
      identifier: 'full_cognitive_sequence',
      steps: steps,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _CognitiveTaskScreen(
          task: task,
          onComplete: (result) async {
            final processResult = await _processSequenceResultsWithFeedback(
              ref,
              result,
            );

            // Pop the fullscreen task route first
            if (context.mounted) Navigator.of(context).pop();

            // Call appropriate callback
            if (processResult.success) {
              onSuccess();
            } else {
              onError(processResult.errorMessage ?? 'Nieznany błąd');
            }
          },
        ),
      ),
    );
  }

  static Future<ProcessSequenceResult> _processSequenceResultsWithFeedback(
    WidgetRef ref,
    RPTaskResult taskResult,
  ) async {
    try {
      final authState = ref.read(authProvider);
      final userId = authState.user?.id;

      if (userId == null) {
        return ProcessSequenceResult(
          success: false,
          errorMessage: 'Użytkownik nie zalogowany',
        );
      }

      final List<CognitiveTestResult> collectedResults = [];
      final List<String> mappingErrors = [];
      final fullJson = taskResult.toJson();
      final resultsNode = fullJson['results'] as Map<String, dynamic>?;

      if (resultsNode == null) {
        return ProcessSequenceResult(
          success: false,
          errorMessage: 'Brak wyników z testu',
        );
      }

      // Collect results and track errors
      _stepMap.forEach((stepId, testType) {
        if (resultsNode.containsKey(stepId)) {
          try {
            final cleanResult = RPResultMapper.fromRPTaskResult(
              taskResult: taskResult,
              userId: userId,
              testType: testType,
              stepIdentifier: stepId,
            );
            collectedResults.add(cleanResult);
          } catch (e) {
            debugPrint('❌ Błąd mapowania kroku $stepId: $e');
            mappingErrors.add('$stepId: $e');
          }
        }
      });

      if (collectedResults.isEmpty) {
        final errorMsg = mappingErrors.isNotEmpty
            ? 'Błędy mapowania: ${mappingErrors.join(", ")}'
            : 'Brak wyników do zapisania';
        return ProcessSequenceResult(success: false, errorMessage: errorMsg);
      }

      debugPrint(
        '📊 [CognitiveGamesLauncher] Wysyłanie ${collectedResults.length} wyników (błędy mapowania: ${mappingErrors.length})...',
      );

      final saveResult = await ref
          .read(cognitiveGamesProvider.notifier)
          .saveSequenceResultsWithFeedback(collectedResults);

      if (saveResult.success) {
        return ProcessSequenceResult(
          success: true,
          savedCount: saveResult.savedCount,
        );
      } else {
        return ProcessSequenceResult(
          success: false,
          errorMessage: saveResult.errorMessage ?? 'Błąd zapisu wyników',
        );
      }
    } catch (e) {
      debugPrint("❌ Krytyczny błąd przetwarzania wyników: $e");
      return ProcessSequenceResult(
        success: false,
        errorMessage: 'Krytyczny błąd: $e',
      );
    }
  }

  static RPStep _getStepById(String identifier) {
    switch (identifier) {
      case 'stroop_ffect_step':
        return stroopEffect;
      case 'trail_making_step':
        return trailMaking;
      case 'flanker_step':
        return flanker;
      case 'RVIP_step':
        return rapidVisualInfoProcessing;
      case 'tapping_step':
        return tapping;
      case 'corsi_block_step':
        return corsiBlockTapping;
      case 'reaction_time_step':
        return reactionTime;
      default:
        throw Exception('Nieznany krok: $identifier');
    }
  }
}

class _CognitiveTaskScreen extends StatelessWidget {
  final RPOrderedTask task;
  final Future<void> Function(RPTaskResult) onComplete;

  const _CognitiveTaskScreen({required this.task, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Localizations.override(
        context: context,
        child: RPUITask(
          hideNextButton: true,
          task: task,
          onSubmit: (result) {
            onComplete(result);
          },
        ),
      ),
    );
  }
}

// ─── Result Types for Structured Feedback ───

/// Result from processing a sequence of cognitive games
class ProcessSequenceResult {
  final bool success;
  final String? errorMessage;
  final int savedCount;

  ProcessSequenceResult({
    required this.success,
    this.errorMessage,
    this.savedCount = 0,
  });
}

/// Result from saving sequence results with feedback
class SaveSequenceResultWithFeedback {
  final bool success;
  final String? errorMessage;
  final int savedCount;
  final int failedCount;

  SaveSequenceResultWithFeedback({
    required this.success,
    this.errorMessage,
    this.savedCount = 0,
    this.failedCount = 0,
  });
}
