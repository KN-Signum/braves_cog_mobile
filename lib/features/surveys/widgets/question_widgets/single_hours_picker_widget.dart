import 'package:flutter/material.dart';

class SingleHoursPickerWidget extends StatefulWidget {
  final int? hours;
  final Function(int?) onChanged;
  final int maxHours;

  const SingleHoursPickerWidget({
    super.key,
    this.hours,
    required this.onChanged,
    this.maxHours = 23,
  });

  @override
  State<SingleHoursPickerWidget> createState() => _SingleHoursPickerWidgetState();
}

class _SingleHoursPickerWidgetState extends State<SingleHoursPickerWidget> {
  late FixedExtentScrollController _hoursController;
  int _selectedHours = 0;

  @override
  void initState() {
    super.initState();
    _selectedHours = widget.hours ?? 0;
    _hoursController = FixedExtentScrollController(initialItem: _selectedHours);
  }

  @override
  void didUpdateWidget(SingleHoursPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hours != widget.hours) {
      _selectedHours = widget.hours ?? 0;
      _hoursController.jumpToItem(_selectedHours);
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hoursList = List.generate(widget.maxHours + 1, (index) => index);
    
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
            controller: _hoursController,
            itemExtent: 50,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              if (index >= 0 && index < hoursList.length) {
                setState(() {
                  _selectedHours = hoursList[index];
                });
                widget.onChanged(_selectedHours);
              }
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index >= hoursList.length) return null;
                final hour = hoursList[index];
                final isSelected = hour == _selectedHours;

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
                        '$hour',
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
                        'godz.',
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
              childCount: hoursList.length,
            ),
          ),
        ),
      ),
    );
  }
}
















