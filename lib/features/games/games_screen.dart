import 'package:flutter/material.dart';
import 'package:research_package/research_package.dart';
import '../../cognition_config.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gry Kognitywne'), centerTitle: true),
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
            color: Colors.red,
            onTap: () => _launchStroopTest(context),
          ),

          // Trail Making Test
          _GameCard(
            title: 'Test Łączenia Punktów',
            description: 'Szybkość przetwarzania i elastyczność poznawcza',
            icon: Icons.timeline,
            color: Colors.blue,
            onTap: () => _launchTrailMakingTest(context),
          ),

          // Flanker Test
          _GameCard(
            title: 'Test Flankera',
            description: 'Uwaga selektywna i kontrola poznawcza',
            icon: Icons.arrow_forward,
            color: Colors.green,
            onTap: () => _launchFlankerTest(context),
          ),

          // Rapid Visual Processing
          _GameCard(
            title: 'Szybkie Przetwarzanie Wzrokowe',
            description: 'Uwaga wzrokowa i czujność',
            icon: Icons.visibility,
            color: Colors.orange,
            onTap: () => _launchRapidVisualTest(context),
          ),

          // Tapping Test
          _GameCard(
            title: 'Test Stukania',
            description: 'Koordynacja ruchowa i szybkość reakcji',
            icon: Icons.touch_app,
            color: Colors.purple,
            onTap: () => _launchTappingTest(context),
          ),

          // Corsi Block
          _GameCard(
            title: 'Test Bloków Corsi',
            description: 'Pamięć robocza przestrzenna',
            icon: Icons.grid_4x4,
            color: Colors.teal,
            onTap: () => _launchCorsiBlockTest(context),
          ),

          // Reaction Time (NOWA GRA)
          _GameCard(
            title: 'Test Czasu Reakcji',
            description: 'Szybkość reakcji na bodźce wzrokowe',
            icon: Icons.timer,
            color: Colors.amber,
            onTap: () => _launchReactionTimeTest(context),
          ),

          const SizedBox(height: 16),
          // Info card
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Regularne ćwiczenia mogą poprawić funkcje poznawcze',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchStroopTest(BuildContext context) {
    _launchSingleTest(context, stroopEffect, 'Test Stroopa');
  }

  void _launchTrailMakingTest(BuildContext context) {
    _launchSingleTest(context, trailMaking, 'Test Łączenia Punktów');
  }

  void _launchFlankerTest(BuildContext context) {
    _launchSingleTest(context, flanker, 'Test Flankera');
  }

  void _launchRapidVisualTest(BuildContext context) {
    _launchSingleTest(
      context,
      rapidVisualInfoProcessing,
      'Szybkie Przetwarzanie Wzrokowe',
    );
  }

  void _launchTappingTest(BuildContext context) {
    _launchSingleTest(context, tapping, 'Test Stukania');
  }

  void _launchCorsiBlockTest(BuildContext context) {
    _launchSingleTest(context, corsiBlockTapping, 'Test Bloków Corsi');
  }

  void _launchReactionTimeTest(BuildContext context) {
    _launchSingleTest(context, reactionTime, 'Test Czasu Reakcji');
  }

  void _launchSingleTest(
    BuildContext context,
    RPActivityStep activityStep,
    String title,
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
          onComplete: (result) => _showResults(context, result),
        ),
      ),
    );
  }

  String _getInstructionText(String identifier) {
    switch (identifier) {
      case 'stroop_ffect_step':
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

  void _showResults(BuildContext context, RPTaskResult result) {
    // RPUITask already navigated back, so we're already on the games screen
    // Process and display results
    print('Test completed: ${result.identifier}');
    print('Results: ${result.results}');

    // You can extract specific scores from the result
    // Different tests store results differently
    final activityResults = result.results.values.whereType<RPActivityResult>();

    if (activityResults.isNotEmpty) {
      final firstResult = activityResults.first;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Test ukończony! ${firstResult.results.length} wyników zapisanych.',
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test ukończony!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
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
      body: RPUITask(
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
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
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
