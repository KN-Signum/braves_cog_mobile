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

  const HoursMinutesPickerWidget({
    super.key,
    this.hours,
    this.minutes,
    required this.onChanged,
    this.maxHours = 24,
    this.maxMinutes = 59,
    this.enabled = true,
    this.minMinutesIfZeroHours = 0,
  });

  @override
  State<HoursMinutesPickerWidget> createState() =>
      _HoursMinutesPickerWidgetState();
}

class _HoursMinutesPickerWidgetState extends State<HoursMinutesPickerWidget> {
  int _selectedHours = 0;
  int _selectedMinutes = 0;

  @override
  void initState() {
    super.initState();
    _selectedHours = widget.hours ?? 0;
    _selectedMinutes = widget.minutes ?? 0;

    final minMinute = _selectedHours == 0 ? widget.minMinutesIfZeroHours : 0;
    if (_selectedMinutes < minMinute) {
      _selectedMinutes = minMinute;
    }
  }

  @override
  void didUpdateWidget(HoursMinutesPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hours != widget.hours ||
        oldWidget.minutes != widget.minutes) {
      _selectedHours = widget.hours ?? 0;
      _selectedMinutes = widget.minutes ?? 0;

      final minMinute = _selectedHours == 0 ? widget.minMinutesIfZeroHours : 0;
      if (_selectedMinutes < minMinute) {
        _selectedMinutes = minMinute;
      }
    }
  }

  String _formatTime(int hours, int minutes) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  Future<void> _showPickerDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return _HoursMinutesPickerDialog(
          initialHours: _selectedHours,
          initialMinutes: _selectedMinutes,
          maxHours: widget.maxHours,
          maxMinutes: widget.maxMinutes,
          minMinutesIfZeroHours: widget.minMinutesIfZeroHours,
          onChanged: (hours, minutes) {
            setState(() {
              _selectedHours = hours;
              _selectedMinutes = minutes;
            });
            widget.onChanged(hours, minutes);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final bgActive = Color.lerp(secondary, Colors.white, 0.5);
    final fieldBg = bgActive ?? Theme.of(context).scaffoldBackgroundColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, 220.0);
        return Center(
          child: GestureDetector(
            onTap: widget.enabled ? () => _showPickerDialog(context) : null,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: widget.enabled ? 1 : 0.6,
              child: Container(
                width: size,
                height: size,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: fieldBg,
                  border: Border.all(color: primary, width: 2),
                  borderRadius: BorderRadius.zero,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(_selectedHours, _selectedMinutes),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: primary,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(Icons.access_time, color: primary, size: 28),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HoursMinutesPickerDialog extends StatefulWidget {
  final int initialHours;
  final int initialMinutes;
  final int maxHours;
  final int maxMinutes;
  final int minMinutesIfZeroHours;
  final Function(int, int) onChanged;

  const _HoursMinutesPickerDialog({
    required this.initialHours,
    required this.initialMinutes,
    required this.maxHours,
    required this.maxMinutes,
    required this.minMinutesIfZeroHours,
    required this.onChanged,
  });

  @override
  State<_HoursMinutesPickerDialog> createState() =>
      _HoursMinutesPickerDialogState();
}

class _HoursMinutesPickerDialogState extends State<_HoursMinutesPickerDialog> {
  late FixedExtentScrollController _hoursController;
  late FixedExtentScrollController _minutesController;
  late int _selectedHours;
  late int _selectedMinutes;

  @override
  void initState() {
    super.initState();
    _selectedHours = widget.initialHours;
    _selectedMinutes = widget.initialMinutes;

    final minMinute = _selectedHours == 0 ? widget.minMinutesIfZeroHours : 0;
    _hoursController = FixedExtentScrollController(initialItem: _selectedHours);

    final initialMinuteIndex = (_selectedMinutes - minMinute).clamp(
      0,
      widget.maxMinutes - minMinute,
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
  Widget build(BuildContext context) {
    final hoursList = List.generate(widget.maxHours + 1, (index) => index);
    final minMinute = _selectedHours == 0 ? widget.minMinutesIfZeroHours : 0;
    final minutesList = List.generate(
      widget.maxMinutes - minMinute + 1,
      (index) => index + minMinute,
    );
    final primary = Theme.of(context).colorScheme.primary;

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
                            final newMinMinute = _selectedHours == 0
                                ? widget.minMinutesIfZeroHours
                                : 0;
                            if (_selectedMinutes < newMinMinute) {
                              _selectedMinutes = newMinMinute;
                            }

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted) return;
                              final minuteIndex =
                                  _selectedMinutes - newMinMinute;
                              _minutesController.jumpToItem(
                                minuteIndex.clamp(
                                  0,
                                  widget.maxMinutes - newMinMinute,
                                ),
                              );
                            });
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
                              style: Theme.of(context).textTheme.displaySmall
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
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
                              style: Theme.of(context).textTheme.displaySmall
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
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Gotowe'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
