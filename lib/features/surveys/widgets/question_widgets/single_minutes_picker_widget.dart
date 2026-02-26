import 'package:flutter/material.dart';

class SingleMinutesPickerWidget extends StatefulWidget {
  final int? minutes;
  final Function(int?) onChanged;
  final int maxMinutes;

  const SingleMinutesPickerWidget({
    super.key,
    this.minutes,
    required this.onChanged,
    this.maxMinutes = 59,
  });

  @override
  State<SingleMinutesPickerWidget> createState() => _SingleMinutesPickerWidgetState();
}

class _SingleMinutesPickerWidgetState extends State<SingleMinutesPickerWidget> {
  late FixedExtentScrollController _minutesController;
  int _selectedMinutes = 0;

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.minutes ?? 0;
    _minutesController = FixedExtentScrollController(initialItem: _selectedMinutes);
  }

  @override
  void didUpdateWidget(SingleMinutesPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minutes != widget.minutes) {
      _selectedMinutes = widget.minutes ?? 0;
      _minutesController.jumpToItem(_selectedMinutes);
    }
  }

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutesList = List.generate(widget.maxMinutes + 1, (index) => index);
    
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.zero,
      ),
      child: Center(
        child: SizedBox(
          width: 200,
          child: ListWheelScrollView.useDelegate(
            controller: _minutesController,
            itemExtent: 50,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              if (index >= 0 && index < minutesList.length) {
                setState(() {
                  _selectedMinutes = minutesList[index];
                });
                widget.onChanged(_selectedMinutes);
              }
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index >= minutesList.length) return null;
                final minute = minutesList[index];
                final isSelected = minute == _selectedMinutes;

                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Colors.transparent,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$minute',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: isSelected ? 32 : 24,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary.withAlpha(128),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'min',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: isSelected ? 18 : 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: minutesList.length,
            ),
          ),
        ),
      ),
    );
  }
}
















