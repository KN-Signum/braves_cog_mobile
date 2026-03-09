import 'package:flutter/material.dart';

class IconOption<T> {
  final T value;
  final String label;
  final IconData icon;

  IconOption({required this.value, required this.label, required this.icon});
}

class IconOptionGrid<T> extends StatelessWidget {
  final List<IconOption<T>> options;
  final T value;
  final Function(T) onChange;
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
    final theme = Theme.of(context);
    final progressColor = theme.colorScheme.secondary;
    // Tło: kolor paska postępu zmieszany 50/50 z białym
    final selectedBackground = Color.lerp(progressColor, Colors.white, 0.5)!;

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
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? selectedBackground
                  : theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(option.icon, size: 36, color: theme.colorScheme.primary),
                const SizedBox(height: 8),
                Text(
                  option.label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
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
