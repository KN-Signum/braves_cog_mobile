import 'package:flutter/material.dart';

class IconOption {
  final String value;
  final String label;
  final IconData icon;

  IconOption({required this.value, required this.label, required this.icon});
}

class IconOptionGrid extends StatelessWidget {
  final List<IconOption> options;
  final String value;
  final Function(String) onChange;
  final int columns;

  const IconOptionGrid({
    super.key,
    required this.options,
    required this.value,
    required this.onChange,
    this.columns = 2,
  });

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
            width:
                (MediaQuery.of(context).size.width -
                    64 -
                    (12 * (columns - 1))) /
                columns,
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  option.icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  option.label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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
