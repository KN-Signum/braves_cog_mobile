import 'package:braves_cog/features/cognitive_games/data/mappers/rp_result_mapper.dart';
import 'package:braves_cog/features/cognitive_games/domain/entities/cognitive_game_result.dart';
import 'package:braves_cog/features/cognitive_games/presentation/providers/cognitive_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_package/research_package.dart';
import '../../../cognition_config.dart';

class GamesScreen extends ConsumerWidget {
  final VoidCallback? onBack;

  const GamesScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(70),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            if (onBack != null) {
              onBack?.call();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Gry Kognitywne',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.psychology,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Gry Treningowe',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wybierz grę aby rozpocząć trening poznawczy',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Stroop Test
          _GameCard(
            title: 'Test Stroopa',
            description: 'Trening kontroli uwagi i hamowania impulsów',
            icon: Icons.palette,
            color: ColorScheme.of(context).primary,
            onTap: () => _launchStroopTest(context, ref),
          ),

          // Trail Making Test
          _GameCard(
            title: 'Test Łączenia Punktów',
            description: 'Szybkość przetwarzania i elastyczność poznawcza',
            icon: Icons.timeline,
            color: ColorScheme.of(context).primary,
            onTap: () => _launchTrailMakingTest(context, ref),
          ),

          // Flanker Test
          _GameCard(
            title: 'Test Flankera',
            description: 'Uwaga selektywna i kontrola poznawcza',
            icon: Icons.arrow_forward,
            color: ColorScheme.of(context).primary,
            onTap: () => _launchFlankerTest(context, ref),
          ),

          // Rapid Visual Processing
          _GameCard(
            title: 'Szybkie Przetwarzanie Wzrokowe',
            description: 'Uwaga wzrokowa i czujność',
            icon: Icons.visibility,
            color: ColorScheme.of(context).primary,
            onTap: () => _launchRapidVisualTest(context, ref),
          ),

          // Tapping Test
          _GameCard(
            title: 'Test Stukania',
            description: 'Koordynacja ruchowa i szybkość reakcji',
            icon: Icons.touch_app,
            color: ColorScheme.of(context).primary,
            onTap: () => _launchTappingTest(context, ref),
          ),

          // Corsi Block
          _GameCard(
            title: 'Test Bloków Corsi',
            description: 'Pamięć robocza przestrzenna',
            icon: Icons.grid_4x4,
            color: ColorScheme.of(context).primary,
            onTap: () => _launchCorsiBlockTest(context, ref),
          ),

          // Reaction Time
          _GameCard(
            title: 'Test Czasu Reakcji',
            description: 'Szybkość reakcji na bodźce wzrokowe',
            icon: Icons.timer,
            color: ColorScheme.of(context).primary,
            onTap: () => _launchReactionTimeTest(context, ref),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _launchStroopTest(BuildContext context, WidgetRef ref) {
    _launchSingleTest(
      context,
      stroopEffect,
      'Test Stroopa',
      ref,
      CognitiveTestType.stroop,
    );
  }

  void _launchTrailMakingTest(BuildContext context, WidgetRef ref) {
    _launchSingleTest(
      context,
      trailMaking,
      'Test Łączenia Punktów',
      ref,
      CognitiveTestType.trailMaking,
    );
  }

  void _launchFlankerTest(BuildContext context, WidgetRef ref) {
    _launchSingleTest(
      context,
      flanker,
      'Test Flankera',
      ref,
      CognitiveTestType.flanker,
    );
  }

  void _launchRapidVisualTest(BuildContext context, WidgetRef ref) {
    _launchSingleTest(
      context,
      rapidVisualInfoProcessing,
      'Szybkie Przetwarzanie Wzrokowe',
      ref,
      CognitiveTestType.rvip,
    );
  }

  void _launchTappingTest(BuildContext context, WidgetRef ref) {
    _launchSingleTest(
      context,
      tapping,
      'Test Stukania',
      ref,
      CognitiveTestType.tapping,
    );
  }

  void _launchCorsiBlockTest(BuildContext context, WidgetRef ref) {
    _launchSingleTest(
      context,
      corsiBlockTapping,
      'Test Bloków Corsi',
      ref,
      CognitiveTestType.corsiBlock,
    );
  }

  void _launchReactionTimeTest(BuildContext context, WidgetRef ref) {
    _launchSingleTest(
      context,
      reactionTime,
      'Test Czasu Reakcji',
      ref,
      CognitiveTestType.reactionTime,
    );
  }

  void _launchSingleTest(
    BuildContext context,
    RPActivityStep activityStep,
    String title,
    WidgetRef ref,
    CognitiveTestType testType,
  ) {
    // Create a task with instruction, activity, and completion steps
    final instructionStep = RPInstructionStep(
      identifier: 'instruction_${activityStep.identifier}',
      title: title,
      text: _getInstructionText(activityStep.identifier),
    );

    final completionStep = RPCompletionStep(
      identifier: 'completion_${activityStep.identifier}',
      title: 'Ukończono!',
      text: 'Świetna robota! Test został ukończony.',
    );

    final task = RPOrderedTask(
      identifier: 'task_${activityStep.identifier}',
      steps: [instructionStep, activityStep, completionStep],
    );

    // Navigate to a dedicated task screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _CognitiveTaskScreen(
          task: task,
          onComplete: (result) => _processAndSaveResults(
            context,
            ref,
            result,
            testType,
            activityStep.identifier,
          ),
        ),
      ),
    );
  }

  String _getInstructionText(String identifier) {
    switch (identifier) {
      case 'stroop_effect_step':
        return 'Zobaczysz słowa kolorów napisane różnymi kolorami. '
            'Twoim zadaniem jest wybrać KOLOR tekstu, a nie czytać słowo. '
            'Odpowiadaj jak najszybciej i najdokładniej.';
      case 'trail_making_step':
        return 'Połącz liczby i litery w odpowiedniej kolejności. '
            'Przełączaj się między liczbami i literami (1-A-2-B-3-C...). '
            'Wykonaj zadanie jak najszybciej bez błędów.';
      case 'flanker_step':
        return 'Zobaczysz strzałki na ekranie. Wskaż kierunek środkowej strzałki, '
            'ignorując strzałki po bokach. Odpowiadaj szybko i dokładnie.';
      case 'RVIP_step':
        return 'Cyfry będą pojawiać się jedna po drugiej. '
            'Stuknij ekran gdy zobaczysz sekwencję: 3-5-7 lub 2-4-6. '
            'Zachowaj czujność przez cały test.';
      case 'tapping_step':
        return 'Stukaj naprzemiennie w dwa przyciski tak szybko jak możesz. '
            'Utrzymuj stały rytm przez cały test.';
      case 'corsi_block_step':
        return 'Zapamiętaj kolejność w jakiej zaświecają się bloki, '
            'a następnie powtórz tę sekwencję. '
            'Sekwencje stają się coraz dłuższe.';
      case 'reaction_time_step':
        return 'Gdy zobaczysz pojawiający się bodziec, stuknij ekran tak szybko jak możesz. '
            'Test mierzy Twój czas reakcji. Bądź gotowy i reaguj natychmiast!';
      default:
        return 'Postępuj zgodnie z instrukcjami na ekranie.';
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  // void _showResults(BuildContext context, RPTaskResult result) {
  //   final Map<String, dynamic> jsonMap = result.toJson();

  //   const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  //   final String jsonString = encoder.convert(jsonMap);

  //   debugPrint("================ RESULT START ================");
  //   printWrapped(jsonString);
  //   debugPrint("================ RESULT END ================");

  //   final activityResults = result.results.values.whereType<RPActivityResult>();

  //   if (activityResults.isNotEmpty) {
  //     final firstResult = activityResults.first;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Test ukończony! ${firstResult.results.length} wyników zapisanych.',
  //         ),
  //         duration: const Duration(seconds: 3),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Test ukończony!'),
  //         duration: Duration(seconds: 2),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   }
  // }
  void _processAndSaveResults(
    BuildContext context,
    WidgetRef ref,
    RPTaskResult result,
    CognitiveTestType testType,
    String stepIdentifier,
  ) {
    try {
      debugPrint('🎮 [GamesScreen] Rozpoczęcie zapisu wyników...');
      debugPrint(
        '🎮 [GamesScreen] Test type: $testType, Step: $stepIdentifier',
      );

      // 1. Zmapuj surowy wynik na czysty obiekt domeny
      final cleanResult = RPResultMapper.fromRPTaskResult(
        taskResult: result,
        userId: 'temp_user_id',
        testType: testType,
        stepIdentifier: stepIdentifier,
      );

      debugPrint('🎮 [GamesScreen] Wynik zmapowany: ${cleanResult.testType}');

      // 2. Wywołaj zapis przez Riverpod
      debugPrint('🎮 [GamesScreen] Wysyłanie do notifier...');
      ref.read(cognitiveGamesProvider.notifier).saveResult(cleanResult);
      debugPrint('🎮 [GamesScreen] Wynik wysłany do notifier!');

      // 3. Pokaż komunikat użytkownikowi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ukończono! Trwa zapisywanie wyników...'),
          backgroundColor: Color(0xFF00D4E6), // Cyan
        ),
      );
    } catch (e) {
      debugPrint('❌ [GamesScreen] Błąd mapowania wyników: $e');
      debugPrint('❌ [GamesScreen] StackTrace: ${StackTrace.current}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd: $e'), backgroundColor: Colors.red),
      );
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
          task: task,
          onSubmit: (result) {
            // RPUITask automatically pops the route, so we just call the callback
            onComplete(result);
          },
          onCancel: ([result]) {
            // RPUITask automatically pops on cancel too
            // No action needed, just let it close
          },
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GameCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(width: 1.0, color: ColorScheme.of(context).primary),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: ColorScheme.of(context).secondary,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 5.0,
                      color: ColorScheme.of(context).primary.withAlpha(30),
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFC515667),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFC515667)),
            ],
          ),
        ),
      ),
    );
  }
}
