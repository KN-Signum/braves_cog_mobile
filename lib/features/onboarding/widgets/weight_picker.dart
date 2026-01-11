import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class WeightPicker extends StatelessWidget {
  final String value;
  final Function(String) onChange;

  const WeightPicker({
    Key? key,
    required this.value,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weights = List.generate(151, (index) => (40 + index).toString());
    final initialIndex = weights.indexOf(value);

    return Container(
      height: 200,
      width: 200,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        diameterRatio: 1.5,
        controller: FixedExtentScrollController(
          initialItem: initialIndex >= 0 ? initialIndex : weights.indexOf('70'),
        ),
        onSelectedItemChanged: (index) {
          onChange(weights[index]);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= weights.length) return null;
            final weight = weights[index];
            final isSelected = weight == value;
            
            return Center(
              child: Text(
                '$weight kg',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: isSelected ? 32 : 24,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.5),
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

