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
  State<SegmentScaleQuestionWidget> createState() => _SegmentScaleQuestionWidgetState();
}

class _SegmentScaleQuestionWidgetState extends State<SegmentScaleQuestionWidget> {
  List<Color> get _colors {
    final baseColors = [
      Colors.green.shade900,
      Colors.green.shade800,
      Colors.green.shade600,
      Colors.lightGreen.shade500,
      Colors.lightGreen.shade300,
      Colors.yellow.shade400,
      Colors.orange.shade200,
      Colors.orange.shade400,
      Colors.red.shade400,
      Colors.red.shade700,
    ];
    return widget.reversed ? baseColors.reversed.toList() : baseColors;
  }

  @override
  Widget build(BuildContext context) {
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
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: _colors[index],
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: isSelected ? 3 : 0,
                    ),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Center(
                    child: Text(
                      '$segmentValue',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isSelected ? Theme.of(context).colorScheme.onPrimary : Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _colors.first,
              ),
            ),
            Text(
              widget.maxLabel ?? '10',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _colors.last,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

