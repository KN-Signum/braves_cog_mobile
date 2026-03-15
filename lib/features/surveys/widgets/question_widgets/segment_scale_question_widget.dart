import 'package:flutter/material.dart';

class SegmentScaleQuestionWidget extends StatefulWidget {
  final int value;
  final Function(int) onChanged;
  final String? minLabel;
  final String? maxLabel;
  final bool reversed;

  const SegmentScaleQuestionWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.minLabel,
    this.maxLabel,
    this.reversed = false,
  });

  @override
  State<SegmentScaleQuestionWidget> createState() =>
      _SegmentScaleQuestionWidgetState();
}

class _SegmentScaleQuestionWidgetState
    extends State<SegmentScaleQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.primary;
    final selectedColor = theme.colorScheme.secondary;
    final unselectedBackground = theme.colorScheme.surface;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(10, (index) {
            final segmentValue = index + 1;
            final isSelected = widget.value == segmentValue;
            return Expanded(
              child: GestureDetector(
                onTap: () => widget.onChanged(segmentValue),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? selectedColor : unselectedBackground,
                    border: Border.all(
                      color: borderColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Center(
                    child: Text(
                      '$segmentValue',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: borderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.minLabel ?? '1',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
              widget.maxLabel ?? '10',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
