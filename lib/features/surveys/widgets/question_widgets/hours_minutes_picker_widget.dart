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
  State<HoursMinutesPickerWidget> createState() => _HoursMinutesPickerWidgetState();
}

class _HoursMinutesPickerWidgetState extends State<HoursMinutesPickerWidget> {
  late FixedExtentScrollController _hoursController;
  late FixedExtentScrollController _minutesController;
  int _selectedHours = 0;
  int _selectedMinutes = 0;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedHours = widget.hours ?? 0;
    _selectedMinutes = widget.minutes ?? 0;
    _hoursController = FixedExtentScrollController(initialItem: _selectedHours);
    _minutesController = FixedExtentScrollController(initialItem: _selectedMinutes);
  }

  @override
  void didUpdateWidget(HoursMinutesPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled && !widget.enabled && _isExpanded) {
      // When disabled (e.g. "Nie wiem" / freeze), collapse picker.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _isExpanded = false;
        });
      });
    }
    if (oldWidget.hours != widget.hours || oldWidget.minutes != widget.minutes) {
      _selectedHours = widget.hours ?? 0;
      _selectedMinutes = widget.minutes ?? 0;

      // Jeśli 0 godzin – minimalnie minMinutesIfZeroHours minut (np. 10 dla aktywności fizycznej).
      final minMinute = _selectedHours == 0 ? widget.minMinutesIfZeroHours : 0;
      if (_selectedMinutes < minMinute) {
        _selectedMinutes = minMinute;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _hoursController.jumpToItem(_selectedHours);
        final minuteIndex = _selectedMinutes - minMinute;
        _minutesController.jumpToItem(minuteIndex.clamp(0, widget.maxMinutes - minMinute));
      });
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  String _formatTime(int hours, int minutes) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final hoursList = List.generate(widget.maxHours + 1, (index) => index);
    // Dla 0 godzin możemy ograniczyć minuty (np. 10–59); domyślnie 0–59.
    final minMinute = _selectedHours == 0 ? widget.minMinutesIfZeroHours : 0;
    final minutesList = List.generate(
      widget.maxMinutes - minMinute + 1,
      (index) => index + minMinute,
    );

    final primary = Theme.of(context).colorScheme.primary;
    // Używamy tego samego koloru tła co w zaznaczonych odpowiedziach:
    // kolor paska postępu (secondary) zmieszany w 50% z bielą.
    final secondary = Theme.of(context).colorScheme.secondary;
    final bgActive = Color.lerp(secondary, Colors.white, 0.5);
    // Zawsze pokazujemy niebieskawa ramkę z wypełnieniem (nie tylko po rozwinięciu).
    final fieldBg = bgActive ?? Theme.of(context).scaffoldBackgroundColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, 220.0);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pole tekstowe z czasem (duży kwadrat, klikalne)
            Center(
              child: GestureDetector(
                onTap: widget.enabled
                    ? () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      }
                    : null,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: widget.enabled ? 1 : 0.6,
                  child: Container(
                    width: size,
                    height: size,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: fieldBg,
                      border: Border.all(
                        color: primary,
                        width: 2,
                      ),
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
                        Icon(
                          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: primary,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Rozwijany picker
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: (_isExpanded && widget.enabled) ? 300 : 0,
              // Uwaga: nie ustawiamy clipBehavior tutaj, bo AnimatedContainer
              // tworzy wewnętrzny Container bez decoration i z clipem != none
              // powodowałoby to asercję:
              // 'decoration != null || clipBehavior == Clip.none'
              child: (_isExpanded && widget.enabled)
                  ? Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.zero,
                      ),
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
                                // Dostosuj minuty jeśli przy 0h były < minMinutesIfZeroHours.
                                final newMinMinute = _selectedHours == 0
                                    ? widget.minMinutesIfZeroHours
                                    : 0;
                                if (_selectedMinutes < newMinMinute) {
                                  _selectedMinutes = newMinMinute;
                                }

                                // Zsynchronizuj widok minut z nową wartością.
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  final minuteIndex = _selectedMinutes - newMinMinute;
                                  _minutesController.jumpToItem(
                                    minuteIndex.clamp(0, widget.maxMinutes - newMinMinute),
                                  );
                                });
                              });
                              widget.onChanged(_selectedHours, _selectedMinutes);
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
                                child: Text(
                                  hour.toString().padLeft(2, '0'),
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontSize: isSelected ? 32 : 24,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.primary.withAlpha(128),
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
                                child: Text(
                                  minute.toString().padLeft(2, '0'),
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontSize: isSelected ? 32 : 24,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.primary.withAlpha(128),
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
                )
              : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}





