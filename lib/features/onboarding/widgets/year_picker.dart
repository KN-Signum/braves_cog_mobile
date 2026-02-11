import 'package:flutter/material.dart';


class YearPicker extends StatelessWidget {
  final String value;
  final Function(String) onChange;
  final int minYear;
  final int maxYear;
  final int defaultYear;

  const YearPicker({
    super.key,
    required this.value,
    required this.onChange,
    this.minYear = 1925,
    required this.maxYear,
    this.defaultYear = 1990,
  });

  @override
  Widget build(BuildContext context) {
    final years = List.generate(
      maxYear - minYear + 1,
      (index) => (maxYear - index).toString(),
    );

    final initialIndex = years.indexOf(value);

    return SizedBox(
      height: 200,
      width: 150,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        diameterRatio: 1.5,
        controller: FixedExtentScrollController(
          initialItem: initialIndex >= 0 ? initialIndex : years.indexOf(defaultYear.toString()),
        ),
        onSelectedItemChanged: (index) {
          onChange(years[index]);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= years.length) return null;
            final year = years[index];
            final isSelected = year == value;
            
            return SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  year,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: isSelected ? 32 : 24,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
              ),
            );
          },
          childCount: years.length,
        ),
      ),
    );
  }
}

