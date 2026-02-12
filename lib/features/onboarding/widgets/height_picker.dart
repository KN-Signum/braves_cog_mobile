import 'package:flutter/material.dart';

class HeightPicker extends StatelessWidget {
  final String height;
  final Function(String) onHeightChanged;

  const HeightPicker({
    super.key,
    required this.height,
    required this.onHeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    final heights = List.generate(121, (index) => (120 + index).toString());
    final initialIndex = heights.indexOf(height);

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        diameterRatio: 1.5,
        controller: FixedExtentScrollController(
          initialItem: initialIndex >= 0
              ? initialIndex
              : heights.indexOf('170'),
        ),
        onSelectedItemChanged: (index) {
          onHeightChanged(heights[index]);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= heights.length) return null;
            final currentHeight = heights[index];
            final isSelected = currentHeight == height;

            return Center(
              child: Text(
                '$currentHeight cm',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: isSelected ? 32 : 24,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withAlpha(128),
                ),
              ),
            );
          },
          childCount: heights.length,
        ),
      ),
    );
  }
}
