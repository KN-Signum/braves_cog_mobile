import 'package:flutter/material.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  final VoidCallback onHealthClick;
  final VoidCallback onTestsClick;

  const HomeScreen({
    super.key,
    required this.onHealthClick,
    required this.onTestsClick,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Użytkowniku';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('user-credentials');
    if (credentials != null) {
      setState(() => _userName = 'Agata');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.displaySmall,
                        children: [
                          const TextSpan(text: 'Witaj z powrotem,\n'),
                          TextSpan(
                            text: _userName,
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const TextSpan(text: '!'),
                        ],
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingXl),

                    // Feeling Section
                    Text(
                      'Jak się dzisiaj czujesz?',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: AppTheme.spacingMd),

                    // Health Survey Button
                    _buildHealthSurveyCard(),
                    SizedBox(height: AppTheme.spacingXl),

                    // Psychological Tests Section
                    Text(
                      'Testy psychologiczne',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: AppTheme.spacingMd),

                    _buildTestCard(
                      title: 'Testy jednorazowe',
                      description:
                          'Badanie jednorazowe oceniające aktualny stan',
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                      iconColor: Theme.of(context).colorScheme.secondary,
                      icon: Icons.psychology,
                    ),
                    SizedBox(height: AppTheme.spacingMd),

                    _buildTestCard(
                      title: 'Testy wielokrotne',
                      description: 'Monitorowanie postępów w czasie',
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      iconColor: Theme.of(context).colorScheme.primary,
                      icon: Icons.assignment,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSurveyCard() {
    return GestureDetector(
      onTap: widget.onHealthClick,
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wypełnij ankietę',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Sprawdź swoje zdrowie i samopoczucie',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
              ),
              child: Icon(
                Icons.fitness_center,
                size: 40,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard({
    required String title,
    required String description,
    required Color color,
    required Color iconColor,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: widget.onTestsClick,
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
          border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingSm),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: AppTheme.spacingMd),
                  Row(
                    children: [
                      Text(
                        'Rozpocznij',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: iconColor),
                      ),
                      SizedBox(width: AppTheme.spacingSm),
                      Icon(Icons.arrow_forward, color: iconColor, size: 20),
                    ],
                  ),
                ],
              ),
            ),
            Icon(icon, size: 60, color: iconColor),
          ],
        ),
      ),
    );
  }


}
