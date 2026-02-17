import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:braves_cog/core/providers/shared_preferences_provider.dart';
import 'package:braves_cog/features/profile/domain/entities/user_type.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadThemeMode();
  }

  static const String _themeModeKey = 'theme_mode';

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey);

    if (themeModeString != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeModeString,
        orElse: () => ThemeMode.light,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.toString());
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(newMode);
  }
}

enum GroupThemeVariant { standard, customized }

final groupThemeVariantProvider =
    StateNotifierProvider<GroupThemeVariantNotifier, GroupThemeVariant>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final userType = ref.watch(profileProvider).profile.type;
  return GroupThemeVariantNotifier(prefs: prefs, userType: userType);
});

class GroupThemeVariantNotifier extends StateNotifier<GroupThemeVariant> {
  final SharedPreferences prefs;
  final UserType userType;

  GroupThemeVariantNotifier({required this.prefs, required this.userType})
      : super(GroupThemeVariant.standard) {
    _load();
  }

  static const String _keyPrefix = 'group_theme_variant_';

  String get _key => '$_keyPrefix${userType.value}';

  void _load() {
    if (userType == UserType.normalCog) {
      state = GroupThemeVariant.standard;
      return;
    }

    final raw = prefs.getString(_key);

    if (raw == null) {
      state = GroupThemeVariant.customized;
      return;
    }

    state = raw == 'customized'
        ? GroupThemeVariant.customized
        : GroupThemeVariant.standard;
  }

  Future<void> setVariant(GroupThemeVariant variant) async {
    if (userType == UserType.normalCog) {
      state = GroupThemeVariant.standard;
      return;
    }

    state = variant;
    await prefs.setString(
      _key,
      variant == GroupThemeVariant.customized ? 'customized' : 'standard',
    );
  }
}
