import 'package:flutter/material.dart';
import 'dart:math' as math;

class HoursMinutesPickerWidget extends StatefulWidget {
  final int? hours;
  final int? minutes;
  final Function(int?, int?) onChanged;
  final int maxHours;
  final int maxMinutes;
  final bool enabled;
  final int minMinutesIfZeroHours;
  final bool openOnInit;

  const HoursMinutesPickerWidget({
    super.key,
    this.hours,
    this.minutes,
    required this.onChanged,
    this.maxHours = 24,
    this.maxMinutes = 59,
    this.enabled = true,
    this.minMinutesIfZeroHours = 0,
    this.openOnInit = false,
  });

  @override
  State<HoursMinutesPickerWidget> createState() =>
      _HoursMinutesPickerWidgetState();
}

class _HoursMinutesPickerWidgetState extends State<HoursMinutesPickerWidget> {
  late FixedExtentScrollController _hoursController;
  late FixedExtentScrollController _minutesController;
  late int _selectedHours;
  late int _selectedMinutes;

  @override
  void initState() {
    super.initState();
    _selectedHours = widget.hours ?? 0;
    _selectedMinutes = widget.minutes ?? widget.minMinutesIfZeroHours;

    _hoursController = FixedExtentScrollController(initialItem: _selectedHours);

    final initialMinuteIndex = _selectedMinutes.clamp(
      0,
      widget.maxMinutes,
    );
    _minutesController = FixedExtentScrollController(
      initialItem: initialMinuteIndex,
    );
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HoursMinutesPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hours != widget.hours ||
        oldWidget.minutes != widget.minutes) {
      _selectedHours = widget.hours ?? 0;
      _selectedMinutes = widget.minutes ?? widget.minMinutesIfZeroHours;

      _hoursController.jumpToItem(_selectedHours);
      final minuteIndex = _selectedMinutes.clamp(
        0,
        widget.maxMinutes,
      );
      _minutesController.jumpToItem(minuteIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hoursList = List.generate(widget.maxHours + 1, (index) => index);
    final minutesList =
        List.generate(widget.maxMinutes + 1, (index) => index);
    final primary = Theme.of(context).colorScheme.primary;
    final fieldBg = Theme.of(context).scaffoldBackgroundColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Wybierz czas',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    // Hours picker
                    Expanded(
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
                            widget.onChanged(_selectedHours, _selectedMinutes);
                          }
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            if (index < 0 || index >= hoursList.length) {
                              return null;
                            }
                            final hour = hoursList[index];
                            final isSelected = hour == _selectedHours;

                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest
                                    : Colors.transparent,
                              ),
                              child: Text(
                                hour.toString().padLeft(2, '0'),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontSize: isSelected ? 32 : 24,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? primary
                                          : primary.withAlpha(128),
                                    ),
                              ),
                            );
                          },
                          childCount: hoursList.length,
                        ),
                      ),
                    ),
                    // Separator ":"
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        ':',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: primary,
                                ),
                      ),
                    ),
                    // Minutes picker
                    Expanded(
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
                            widget.onChanged(_selectedHours, _selectedMinutes);
                          }
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            if (index < 0 || index >= minutesList.length) {
                              return null;
                            }
                            final minute = minutesList[index];
                            final isSelected = minute == _selectedMinutes;

                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest
                                    : Colors.transparent,
                              ),
                              child: Text(
                                minute.toString().padLeft(2, '0'),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontSize: isSelected ? 32 : 24,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? primary
                                          : primary.withAlpha(128),
                                    ),
                              ),
                            );
                          },
                          childCount: minutesList.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
