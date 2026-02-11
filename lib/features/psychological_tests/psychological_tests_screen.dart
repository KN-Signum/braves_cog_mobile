import 'package:flutter/material.dart';


class PsychologicalTestsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const PsychologicalTestsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: const Text('Testy psychologiczne'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTestSection(
              title: 'Testy jednorazowe',
              subtitle: 'Testy wypełniane jeden raz w całym badaniu',
              icon: Icons.psychology,
              iconColor: const Color(0xFF6366F1),
              isLocked: true,
            ),
            const SizedBox(height: 24),
            _buildTestSection(
              title: 'Testy cykliczne',
              subtitle: 'Testy wypełniane regularnie',
              icon: Icons.repeat,
              iconColor: const Color(0xFF9BB168),
              isLocked: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool isLocked,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 32, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F3422),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF4F3422).withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLocked) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F4F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE8DDD9),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 48,
                    color: const Color(0xFF4F3422).withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Wkrótce dostępne',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4F3422).withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Testy psychologiczne będą dostępne w kolejnych wersjach aplikacji',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF4F3422).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Planowane testy:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4F3422).withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            ...[
              'Kwestionariusz demograficzny',
              'Test osobowości',
              'Skala satysfakcji z życia',
              'Inwentarz objawów przedmiotowych',
            ].map((test) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F3422).withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        test,
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF4F3422).withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

