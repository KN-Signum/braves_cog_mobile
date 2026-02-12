import 'package:flutter/material.dart';

class WeightPicker extends StatelessWidget {
  final String weight;
  final Function(String) onWeightChanged;

  const WeightPicker({
    super.key,
    required this.weight,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    final weights = List.generate(151, (index) => (40 + index).toString());
    final initialIndex = weights.indexOf(weight);

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        diameterRatio: 1.5,
        controller: FixedExtentScrollController(
          initialItem: initialIndex >= 0 ? initialIndex : weights.indexOf('70'),
        ),
        onSelectedItemChanged: (index) {
          onWeightChanged(weights[index]);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= weights.length) return null;
            final itemWeight = weights[index];
            final isSelected = itemWeight == weight;

            return Center(
              child: Text(
                '$itemWeight kg',
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
          childCount: weights.length,
        ),
      ),
    );
  }
}
