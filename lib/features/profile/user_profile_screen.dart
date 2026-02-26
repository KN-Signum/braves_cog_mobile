import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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
            const SizedBox(height: 16),
            _buildHelpSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context) {
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
            'Uzyskaj pomoc',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Text(
            'Jeśli przeżywasz trudny moment, odczuwasz silne napięcie emocjonalne lub masz myśli, które Cię niepokoją, nie musisz radzić sobie z tym samodzielnie. '
            'W tej zakładce znajdziesz numery alarmowe i kontakty do bezpłatnych form wsparcia, dostępnych wtedy, gdy potrzebujesz rozmowy, porady lub natychmiastowej pomocy. '
            'Jeśli czujesz, że możesz być w niebezpieczeństwie w tej chwili, skontaktuj się z numerem alarmowym 112 lub 999.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Poniżej znajdują się pomocne adresy alarmowe:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          _buildHelpRow(
            context,
            'Numer alarmowy 112 — europejski numer alarmowy (bezpośrednie zagrożenie życia lub zdrowia)',
          ),
          _buildHelpRow(context, 'Numer alarmowy 999 — pogotowie ratunkowe'),
          _buildHelpRow(
            context,
            'Numer wsparcia kryzysowego dla dorosłych 800 70 2222 — Centrum Wsparcia dla Osób w Kryzysie Psychicznym',
          ),
          _buildHelpRow(
            context,
            'Numer telefonu zaufania dla dorosłych 116 123 — Ogólnopolska Poradnia Telefoniczna dla Osób Przeżywających Kryzys Emocjonalny',
          ),
          _buildHelpRow(
            context,
            'Numer wsparcia dla dzieci i młodzieży 116 111 — Telefon Zaufania dla Dzieci i Młodzieży (telefon, czat, e-mail)',
          ),
          _buildHelpRow(
            context,
            'Numer wsparcia dla rodziców i nauczycieli 800 100 100 — Fundacja „Dajemy Dzieciom Siłę” (anonimowa pomoc telefoniczna i online w sprawach bezpieczeństwa dzieci)',
          ),
          _buildHelpRow(
            context,
            'Numer wsparcia dla osób doświadczających przemocy 800 120 002 — Ogólnopolskie Pogotowie dla Ofiar Przemocy w Rodzinie „Niebieska Linia”',
          ),
          const SizedBox(height: 24),
          Text(
            'Jak skorzystać z pomocy we Wrocławiu?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Poniżej znajdziesz zestawienie bezpłatnych form pomocy psychicznej dostępnych we Wrocławiu w ramach interwencji kryzysowej oraz systemu publicznej opieki zdrowotnej (NFZ). '
            'Są to miejsca, do których możesz zgłosić się bez skierowania, jeśli przeżywasz kryzys psychiczny, silne obciążenie emocjonalne lub potrzebujesz pilnej konsultacji ze specjalistą. '
            'Jeśli nie wiesz, od czego zacząć, interwencja kryzysowa i telefony zaufania i alarmowe są właściwym pierwszym krokiem w sytuacjach nagłych lub bardzo trudnych. '
            'Centra Zdrowia Psychicznego (NFZ) zapewniają dalszą diagnostykę i leczenie psychiatryczne oraz psychologiczne.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Interwencja kryzysowa (samorząd):',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          _buildPlaceBlock(
            context,
            name: 'Nadodrzańskie Centrum Wsparcia (MOPS Wrocław)',
            address: 'ul. Rydygiera 43A, 50-248 Wrocław',
            phone: '71 796 40 85',
            url:
                'https://mops.wroclaw.pl/o-nas/komorki-organizacyjne-mops/2645-nadodrzanskie-centrum-wsparcia',
            description:
                'Całodobowa, bezpłatna interwencja kryzysowa; wsparcie psychologiczne, interwencyjne i socjalne w nagłych kryzysach życiowych',
          ),
          const SizedBox(height: 16),
          Text(
            'Centrum Zdrowia Psychicznego (NFZ):',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          _buildPlaceBlock(
            context,
            name: 'Dolnośląskie Centrum Zdrowia Psychicznego',
            address: 'Wybrzeże J. Conrada-Korzeniowskiego 18, 50-226 Wrocław',
            phone: '71 776 62 00',
            url: 'https://dczp.wroclaw.pl',
            description:
                'Punkt zgłoszeniowo-koordynacyjny CZP; pomoc psychiatryczna i psychologiczna bez skierowania',
          ),
          const SizedBox(height: 12),
          _buildPlaceBlock(
            context,
            name:
                'Centrum Zdrowia Psychicznego – Stalowa (SP ZOZ Wrocław-Fabryczna)',
            address: 'ul. Stalowa 50, 53-433 Wrocław',
            phone: '71 369 90 60',
            url:
                'https://www.spzoz.wroc.pl/przychodnie/centrum-zdrowia-psychicznego-plus',
            description: 'Pomoc ambulatoryjna i środowiskowa w ramach NFZ',
          ),
          const SizedBox(height: 16),
          Text(
            'Poradnia Zdrowia Psychicznego (NFZ):',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          _buildPlaceBlock(
            context,
            name: 'Poradnia Zdrowia Psychicznego',
            address: 'ul. Ludwika Pasteura 4, 50-367 Wrocław',
            phone: '71 784 01 20',
            url: 'https://usk.wroc.pl',
            description:
                'Ambulatoryjna opieka psychiatryczna dla dorosłych w ramach NFZ',
          ),
          const SizedBox(height: 16),
          Text(
            'Centrum Zdrowia Psychicznego (NFZ):',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          _buildPlaceBlock(
            context,
            name:
                'Centrum Zdrowia Psychicznego – Legnicka (SP ZOZ Wrocław-Fabryczna)',
            address: 'ul. Legnicka 59/U12, 54-203 Wrocław',
            phone: '71 355 65 18',
            url:
                'https://www.spzoz.wroc.pl/przychodnie/centrum-zdrowia-psychicznego-plus',
            description: 'Punkt pierwszego kontaktu CZP',
          ),
        ],
      ),
    );
  }

  Widget _buildHelpRow(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.4,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget _buildPlaceBlock(
    BuildContext context, {
    required String name,
    required String address,
    required String phone,
    required String url,
    required String description,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: theme.colorScheme.primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
          const SizedBox(height: 4),
          Text('Adres: $address', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text('Telefon: $phone', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Text(
              url,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.blue.shade700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Zakres wsparcia: $description',
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }

  int _calculateAge(String? birthYear) {
    if (birthYear == null || birthYear.isEmpty) return 0;
    return DateTime.now().year - int.parse(birthYear);
  }

  double _calculateBMI(String? height, String? weight) {
    if (height == null || weight == null || height.isEmpty || weight.isEmpty) {
      return 0;
    }
    final heightInMeters = int.parse(height) / 100;
    final weightInKg = int.parse(weight);
    return weightInKg / (heightInMeters * heightInMeters);
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
            sexLabels[profile.biologicalSex] ?? 'Nie podano',
          ),
          _buildInfoRow(
            context,
            'Tożsamość\npłciowa',
            sexLabels[profile.genderIdentity] ?? 'Nie podano',
          ),
          _buildInfoRow(
            context,
            'Wykształcenie',
            educationLabels[profile.education] ??
                profile.education ??
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
