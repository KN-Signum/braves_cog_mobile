import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GetHelpScreen extends StatelessWidget {
  const GetHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Uzyskaj pomoc',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildHelpContent(context),
      ),
    );
  }

  Widget _buildHelpContent(BuildContext context) {
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
            'Numer wsparcia dla osób doświadczających przemocy 800 120 002 — Ogólnopolskie Pogotowie dla Ofiar Przemocy w Rodzinie „Niebieska Linia"',
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
}
