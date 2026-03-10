import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:braves_cog/core/providers/theme_provider.dart';
import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:braves_cog/features/profile/domain/entities/user_type.dart';
// import 'package:braves_cog/features/settings/get_help_screen.dart';

class SettingsScreen extends ConsumerWidget {
  final VoidCallback onLogout;

  const SettingsScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userType = ref.watch(profileProvider).profile.type;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Ustawienia',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (userType == UserType.normalCog)
            _buildThemeSwitchTile(context, ref),
          _buildGroupThemeVariantTile(context, ref),
          _buildSettingsTile(
            context: context,
            icon: Icons.help_outline,
            title: 'Uzyskaj pomoc',
            subtitle: 'Numery alarmowe i wsparcie',
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => GetHelpScreen(),
              //   ),
              // );
            },
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.notifications,
            title: 'Powiadomienia',
            subtitle: 'Zarządzaj powiadomieniami',
            onTap: () {},
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.privacy_tip,
            title: 'Prywatność',
            subtitle: 'Zarządzaj danymi osobowymi',
            onTap: () {},
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.info,
            title: 'O aplikacji',
            subtitle: 'Wersja 1.0.0',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              onLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9D2525),
              minimumSize: const Size(double.infinity, 56),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              'Wyloguj się',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSwitchTile(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    final accentColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minVerticalPadding: 16,
        leading: Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.zero,
          ),
          child: Icon(
            isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: accentColor,
            size: 24,
          ),
        ),
        title: Text(
          'Motyw aplikacji',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        subtitle: null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isDarkMode ? 'Ciemny' : 'Jasny',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
              activeTrackColor: accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupThemeVariantTile(BuildContext context, WidgetRef ref) {
    final userType = ref.watch(profileProvider).profile.type;
    if (userType == UserType.normalCog) {
      return const SizedBox.shrink();
    }

    final variant = ref.watch(groupThemeVariantProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final accentColor = isDarkMode
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final variantLabel = variant == GroupThemeVariant.standard
        ? 'Standardowy'
        : 'Dostosowany';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minVerticalPadding: 16,
        leading: Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.zero,
          ),
          child: Icon(Icons.palette_outlined, color: accentColor, size: 24),
        ),
        title: Text(
          'Motyw',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        subtitle: null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              variantLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: variant == GroupThemeVariant.customized,
              onChanged: (value) {
                final next = value
                    ? GroupThemeVariant.customized
                    : GroupThemeVariant.standard;
                ref.read(groupThemeVariantProvider.notifier).setVariant(next);
              },
              activeTrackColor: accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final accentColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minVerticalPadding: 16,
        leading: Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.zero,
          ),
          child: Icon(icon, color: accentColor, size: 24),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: textColor.withValues(alpha: 0.5),
          size: 24,
        ),
        onTap: onTap,
      ),
    );
  }
}
