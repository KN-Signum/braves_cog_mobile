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
            if (saved) {
              onComplete?.call();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Nie udało się zapisać wyników gier. Spróbuj ponownie.',
                  ),
                ),
              );
            }
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
        debugPrint(
          '❌ [GamesScreen] Brak zalogowanego użytkownika — wyniki nie zostaną zapisane',
        );
        return false;
      }

      final List<CognitiveTestResult> collectedResults = [];
      final fullJson = taskResult.toJson();
      final resultsNode = fullJson['results'] as Map<String, dynamic>?;

      if (resultsNode == null) return false;

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

      if (collectedResults.isNotEmpty) {
        debugPrint(
          '📊 [CognitiveGamesLauncher] Wysyłanie ${collectedResults.length} wyników...',
        );
        final saved = await ref
            .read(cognitiveGamesProvider.notifier)
            .saveSequenceResults(collectedResults);
        return saved;
      }
      return false;
    } catch (e) {
      debugPrint("❌ Krytyczny błąd przetwarzania wyników: $e");
      return false;
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
