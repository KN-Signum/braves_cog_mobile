import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/features/cognitive_games/data/mappers/rp_result_mapper.dart';
import 'package:braves_cog/features/cognitive_games/domain/entities/cognitive_game_result.dart';
import 'package:braves_cog/features/cognitive_games/presentation/providers/cognitive_game_provider.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_package/research_package.dart';
import '../../../cognition_config.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  static const Map<String, CognitiveTestType> _stepMap = {
    'stroop_ffect_step': CognitiveTestType.stroop,
    'trail_making_step': CognitiveTestType.trailMaking,
    'flanker_step': CognitiveTestType.flanker,
    'RVIP_step': CognitiveTestType.rvip,
    'tapping_step': CognitiveTestType.tapping,
    'corsi_block_step': CognitiveTestType.corsiBlock,
    'reaction_time_step': CognitiveTestType.reactionTime,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(profileProvider);

    debugPrint(
      '👤 [GamesScreen] authUser: ${authState.user?.email} | authId: ${authState.user?.id}',
    );
    debugPrint(
      '👤 [GamesScreen] profile.id: ${profileState.profile.id} | isLoading: ${profileState.isLoading}',
    );

    return Scaffold(
      backgroundColor: ColorScheme.of(context).surface,
      appBar: AppBar(
        backgroundColor: ColorScheme.of(context).primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Trening Poznawczy',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.psychology,
                  size: 64,
                  color: ColorScheme.of(context).primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Twój Profil Poznawczy',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorScheme.of(context).primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Rozpocznij nasz wspólny trening. Przejdziesz przez serię 7 krótkich ćwiczeń, które pomogą nam lepiej zrozumieć i wesprzeć Twoją koncentrację, pamięć oraz szybkość reakcji.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatBox('Ostatni trening', 'Wczoraj'),
                    Container(
                      width: 1,
                      height: 40,
                      color: ColorScheme.of(context).secondary,
                    ),
                    _buildStatBox('Ukończone sesje', '12'),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 20,
                      color: Color(0xFF0F2847),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Szacowany czas: ~12 minut',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F2847),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _launchFullSequence(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorScheme.of(context).primary,
                    foregroundColor: ColorScheme.of(context).surface,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'ROZPOCZNIJ SEKWENCJĘ',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F2847),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  void _launchFullSequence(BuildContext context, WidgetRef ref) {
    final List<RPStep> steps = [];

    _stepMap.forEach((stepId, testType) {
      steps.add(_getStepById(stepId));
    });

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
          onComplete: (result) => _processSequenceResults(ref, result),
        ),
      ),
    );
  }

  void _processSequenceResults(WidgetRef ref, RPTaskResult taskResult) {
    try {
      final authState = ref.read(authProvider);
      final userId = authState.user?.id;

      if (userId == null) {
        debugPrint('❌ [GamesScreen] Brak zalogowanego użytkownika — wyniki nie zostaną zapisane');
        return;
      }

      debugPrint(
        '📊 [GamesScreen] Przetwarzanie wyników dla użytkownika: $userId',
      );

      final List<CognitiveTestResult> collectedResults = [];
      final fullJson = taskResult.toJson();
      final resultsNode = fullJson['results'] as Map<String, dynamic>?;

      if (resultsNode == null) return;

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
          '📊 [GamesScreen] Wysyłanie ${collectedResults.length} wyników...',
        );
        ref
            .read(cognitiveGamesProvider.notifier)
            .saveSequenceResults(collectedResults);
      }
    } catch (e) {
      debugPrint("❌ Krytyczny błąd przetwarzania wyników: $e");
    }
  }

  RPStep _getStepById(String identifier) {
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
  final void Function(RPTaskResult) onComplete;

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
