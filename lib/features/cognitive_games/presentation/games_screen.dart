import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/features/cognitive_games/presentation/cognitive_games_launcher.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CognitiveStats {
  final int completedSessions;
  final DateTime? lastSessionAt;

  const CognitiveStats({required this.completedSessions, this.lastSessionAt});
}

final cognitiveStatsProvider = FutureProvider<CognitiveStats>((ref) async {
  final authState = ref.watch(authProvider);
  final userId = authState.user?.id;

  if (userId == null) {
    return const CognitiveStats(completedSessions: 0, lastSessionAt: null);
  }

  final rows = await Supabase.instance.client
      .from('cognitive_test_results')
      .select('completed_at')
      .eq('user_id', userId)
      .order('completed_at', ascending: true);

  final completedAtValues = rows
      .map((row) => row['completed_at']?.toString())
      .whereType<String>()
      .map(DateTime.tryParse)
      .whereType<DateTime>()
      .toList();

  if (completedAtValues.isEmpty) {
    return const CognitiveStats(completedSessions: 0, lastSessionAt: null);
  }

  // One session = whole batch of games.
  // We infer sessions by clustering test results that happened close in time.
  // A gap > 2h starts a new session.
  var sessionCount = 0;
  DateTime? previous;

  for (final completedAt in completedAtValues) {
    if (previous == null ||
        completedAt.toUtc().difference(previous.toUtc()).inMinutes > 120) {
      sessionCount++;
    }
    previous = completedAt;
  }

  return CognitiveStats(
    completedSessions: sessionCount,
    lastSessionAt: completedAtValues.last,
  );
});

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  String _formatLastTraining(DateTime? lastSessionAt) {
    if (lastSessionAt == null) return '-';

    final local = lastSessionAt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final localDate = DateTime(local.year, local.month, local.day);
    if (localDate == today) {
      return 'Dzisiaj';
    }

    if (localDate == yesterday) {
      return 'Wczoraj';
    }

    return DateFormat('dd.MM.yyyy').format(local);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(profileProvider);
    final statsAsync = ref.watch(cognitiveStatsProvider);

    final lastTrainingLabel = statsAsync.maybeWhen(
      data: (stats) => _formatLastTraining(stats.lastSessionAt),
      orElse: () => '...',
    );

    final completedSessionsLabel = statsAsync.maybeWhen(
      data: (stats) => '${stats.completedSessions}',
      orElse: () => '...',
    );

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
                    _buildStatBox('Ostatni trening', lastTrainingLabel),
                    Container(
                      width: 1,
                      height: 40,
                      color: ColorScheme.of(context).secondary,
                    ),
                    _buildStatBox('Ukończone sesje', completedSessionsLabel),
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
                      'Szacowany czas: ~10 minut',
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
                  onPressed: () {
                    CognitiveGamesLauncher.launchFullSequenceWithFeedback(
                      context: context,
                      ref: ref,
                      onSuccess: () {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('✅ Sesja została zapisana!'),
                            backgroundColor: Colors.green.shade600,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      onError: (errorMessage) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('❌ Błąd: $errorMessage'),
                            backgroundColor: Colors.red.shade600,
                            action: SnackBarAction(
                              label: 'Spróbuj ponownie',
                              textColor: Colors.white,
                              onPressed: () {
                                // User can retry by tapping again
                              },
                            ),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      },
                    );
                  },
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
}
