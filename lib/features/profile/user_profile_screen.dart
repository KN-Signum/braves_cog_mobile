import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;

    if (profileState.isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
            strokeWidth: 3,
          ),
        ),
      );
    }

    final age = _calculateAge(profile.birthYear);
    final bmi = _calculateBMI(profile.height, profile.weight);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Twój profil',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildBasicInfo(context, age, bmi, profile),
            const SizedBox(height: 16),
            _buildHealthInfo(context, profile),
            const SizedBox(height: 16),
            _buildPersonalInfo(context, profile),
          ],
        ),
      ),
    );
  }

  int _calculateAge(int? birthYear) {
    if (birthYear == null) return 0;
    return DateTime.now().year - birthYear;
  }

  double _calculateBMI(int? height, int? weight) {
    if (height == null || weight == null || height == 0) {
      return 0;
    }
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Niedowaga';
    if (bmi < 25) return 'Prawidłowa';
    if (bmi < 30) return 'Nadwaga';
    return 'Otyłość';
  }

  Color _getBMIColor(BuildContext context, double bmi) {
    if (bmi < 18.5) return Theme.of(context).colorScheme.secondary;
    if (bmi < 25) return const Color(0xFF4CAF50); // green
    if (bmi < 30) return const Color(0xFFFFA726); // orange
    return const Color(0xFFEF5350); // red
  }

  Widget _buildBasicInfo(
    BuildContext context,
    int age,
    double bmi,
    dynamic profile,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        // prostokątne brzegi (bez zaokrągleń)
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            '$age lat',
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                Icons.height,
                '${profile.height ?? '--'} cm',
                'Wzrost',
              ),
              _buildStatItem(
                context,
                Icons.monitor_weight,
                '${profile.weight ?? '--'} kg',
                'Waga',
              ),
            ],
          ),
          if (bmi > 0) ...[
            const SizedBox(height: 24),
            _buildBMIIndicator(context, bmi),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildBMIIndicator(BuildContext context, double bmi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBMIColor(context, bmi).withValues(alpha: 0.15),
        borderRadius: BorderRadius.zero,
        border: Border.all(color: _getBMIColor(context, bmi), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BMI',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                bmi.toStringAsFixed(1),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: _getBMIColor(context, bmi),
                ),
              ),
            ],
          ),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _getBMIColor(context, bmi),
              borderRadius: BorderRadius.zero,
            ),
            child: Center(
              child: Text(
                _getBMICategory(bmi),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthInfo(BuildContext context, dynamic profile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informacje zdrowotne',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            'Papierosy',
            profile.smokingCigarettes ?? false ? 'Tak' : 'Nie',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            'Alkohol',
            profile.drinkingAlcohol ?? false ? 'Tak' : 'Nie',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            'Inne używki',
            profile.otherSubstances ?? false ? 'Tak' : 'Nie',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Alergie', 'Brak', isLast: true),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(BuildContext context, dynamic profile) {
    final sexLabels = {
      'female': 'Kobieta',
      'male': 'Mężczyzna',
      'prefer-not-to-say': 'Wolę nie mówić',
    };

    final educationLabels = {
      'primary': 'Podstawowe',
      'vocational': 'Zawodowe',
      'secondary': 'Średnie',
      'higher': 'Wyższe',
      'other': 'Inne',
    };

    final disabilityLabels = {
      'none': 'Brak',
      'light': 'Lekki',
      'moderate': 'Umiarkowany',
      'significant': 'Znaczny',
      'prefer-not-to-say': 'Wolę nie mówić',
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informacje osobiste',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            'Płeć\nbiologiczna',
            sexLabels[profile.biologicalSex.value] ?? 'Nie podano',
          ),
          _buildInfoRow(
            context,
            'Tożsamość\npłciowa',
            sexLabels[profile.genderIdentity] ?? 'Nie podano',
          ),
          _buildInfoRow(
            context,
            'Wykształcenie',
            educationLabels[profile.education.value] ??
                profile.educationOther ??
                'Nie podano',
          ),
          _buildInfoRow(
            context,
            'Niepełno\nsprawność',
            disabilityLabels[profile.disability] ?? 'Nie podano',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 12),
          Divider(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            thickness: 2,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
