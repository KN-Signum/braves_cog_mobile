import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/features/cognitive_games/presentation/cognitive_games_launcher.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

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
                  onPressed: () => CognitiveGamesLauncher.launchFullSequence(
                    context,
                    ref,
                    null,
                  ),
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
