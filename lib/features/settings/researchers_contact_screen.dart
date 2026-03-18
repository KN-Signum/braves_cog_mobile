import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResearchersContactScreen extends StatelessWidget {
  const ResearchersContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Kontakt do badaczy',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: theme.colorScheme.secondary, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Skontaktuj się z nami przez e-mail',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final uri = Uri(
                    scheme: 'mailto',
                    path: 'braves@pwr.edu.pl',
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
                child: Text(
                  'braves@pwr.edu.pl',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.secondary,
                    decoration: TextDecoration.underline,
                    decorationColor: theme.colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Znajdujemy się tutaj:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Politechnika Wrocławska,\n'
                'Wydział Medyczny,\n'
                'Katedra Neuronauk Klinicznych,\n'
                'ul. Hoene-Wrońskiego 13c,\n'
                '50-376 Wrocław',
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: primary.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Możesz również odwiedzić stronę:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final uri = Uri.parse('https://bravescog.pwr.edu.pl/#Kontakt');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  'https://bravescog.pwr.edu.pl/#Kontakt',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.secondary,
                    decoration: TextDecoration.underline,
                    decorationColor: theme.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

