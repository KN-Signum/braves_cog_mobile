import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class HeightPicker extends StatelessWidget {
  final String value;
  final Function(String) onChange;

  const HeightPicker({
    Key? key,
    required this.value,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heights = List.generate(121, (index) => (120 + index).toString());
    final initialIndex = heights.indexOf(value);

    return Container(
      height: 200,
      width: 200,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        diameterRatio: 1.5,
        controller: FixedExtentScrollController(
          initialItem: initialIndex >= 0 ? initialIndex : heights.indexOf('170'),
        ),
        onSelectedItemChanged: (index) {
          onChange(heights[index]);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= heights.length) return null;
            final height = heights[index];
            final isSelected = height == value;
            
            return Center(
              child: Text(
                '$height cm',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: isSelected ? 32 : 24,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.5),
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

