import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class YearPicker extends StatelessWidget {
  final String value;
  final Function(String) onChange;
  final int minYear;
  final int maxYear;
  final int defaultYear;

  const YearPicker({
    Key? key,
    required this.value,
    required this.onChange,
    this.minYear = 1925,
    required this.maxYear,
    this.defaultYear = 1990,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final years = List.generate(
      maxYear - minYear + 1,
      (index) => (maxYear - index).toString(),
    );

    final initialIndex = years.indexOf(value);

    return Container(
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
            
            return Center(
              child: Text(
                year,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: isSelected ? 32 : 24,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.5),
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

