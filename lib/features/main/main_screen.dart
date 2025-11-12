import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/menu/menu_screen.dart';
import 'package:braves_cog/features/health/health_screen.dart';
import 'package:braves_cog/features/cognitive_tests/cognitive_tests_screen.dart';
import 'package:braves_cog/features/games/games_screen.dart';
import 'package:braves_cog/features/profile/profile_screen.dart';

// Bottom navigation state provider
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static final List<Widget> _pages = [
    const MenuScreen(),
    const HealthScreen(),
    const CognitiveTestsScreen(),
    const GamesScreen(),
    const ProfileScreen(),
  ];

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Zdrowie'),
    BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Testy'),
    BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Gry'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
        items: _navItems,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
