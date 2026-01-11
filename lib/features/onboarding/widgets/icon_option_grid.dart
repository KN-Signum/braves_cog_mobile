import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class IconOption {
  final String value;
  final String label;
  final IconData icon;

  IconOption({
    required this.value,
    required this.label,
    required this.icon,
  });
}

class IconOptionGrid extends StatelessWidget {
  final List<IconOption> options;
  final String value;
  final Function(String) onChange;
  final int columns;

  const IconOptionGrid({
    Key? key,
    required this.options,
    required this.value,
    required this.onChange,
    this.columns = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final isSelected = value == option.value;
        return GestureDetector(
          onTap: () => onChange(option.value),
          child: Container(
            width: (MediaQuery.of(context).size.width - 64 - (12 * (columns - 1))) / columns,
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.accentColor : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? AppTheme.accentColor : AppTheme.lightBackgroundColor,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.accentColor.withOpacity(0.25),
                        blurRadius: 0,
                        spreadRadius: 4,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  option.icon,
                  size: 32,
                  color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  option.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

