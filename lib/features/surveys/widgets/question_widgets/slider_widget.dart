import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SliderQuestionWidget extends StatefulWidget {
  final double value;
  final Function(double) onChanged;
  final double min;
  final double max;
  final double? step;
  final String? unit;
  final String? label;
  final Color? startColor;
  final Color? endColor;
  final String? minLabel;
  final String? maxLabel;
  final bool showMarkers;
  final Map<String, String>? valueLabels;

  const SliderQuestionWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.step,
    this.unit,
    this.label,
    this.startColor,
    this.endColor,
    this.minLabel,
    this.maxLabel,
    this.showMarkers = false,
    this.valueLabels,
  });

  @override
  State<SliderQuestionWidget> createState() => _SliderQuestionWidgetState();
}

class _SliderQuestionWidgetState extends State<SliderQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    final divisions = widget.step != null
        ? ((widget.max - widget.min) / widget.step!).round()
        : null;

    if (widget.showMarkers) {
      return _buildSliderWithMarkers(context, divisions);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Center(
          child: Text(
            '${widget.value.toStringAsFixed(widget.step != null && widget.step! < 1 ? 2 : 0)}${widget.unit ?? ''}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackShape: widget.startColor != null && widget.endColor != null
                ? GradientRectSliderTrackShape(
                    gradient: LinearGradient(
                      colors: [
                        widget.startColor!,
                        widget.endColor!,
                      ],
                    ),
                    darkenInactive: false,
                  )
                : null,
            activeTrackColor: widget.startColor ?? Theme.of(context).colorScheme.secondary,
            inactiveTrackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            thumbColor: Theme.of(context).colorScheme.secondary,
            overlayColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: widget.value,
            min: widget.min,
            max: widget.max,
            divisions: divisions,
            label: '${widget.value.toStringAsFixed(widget.step != null && widget.step! < 1 ? 2 : 0)}${widget.unit ?? ''}',
            onChanged: (value) {
              setState(() {
                widget.onChanged(value);
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.minLabel ?? '${widget.min}${widget.unit ?? ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: widget.startColor ?? Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              widget.maxLabel ?? '${widget.max}${widget.unit ?? ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: widget.endColor ?? Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSliderWithMarkers(BuildContext context, int? divisions) {
    final activeColor = Theme.of(context).colorScheme.secondary;
    final inactiveColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final int currentValue = widget.value.round();
    final int minValue = widget.min.toInt();
    final int maxValue = widget.max.toInt();
    final int markerCount = maxValue - minValue + 1;
    final screenWidth = MediaQuery.of(context).size.width;
    final trackWidth = screenWidth - 120; // marginesy, żeby skrajne pozycje nie były ucięte
    final markerIndex = currentValue - minValue;
    final thumbPosition = markerCount > 1
        ? (markerIndex / (markerCount - 1)) * trackWidth
        : trackWidth / 2;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTapDown: (details) {
              final tapX = details.localPosition.dx;
              final normalizedX = (tapX / trackWidth).clamp(0.0, 1.0);
              final newValue = minValue + (normalizedX * (maxValue - minValue));
              final roundedValue = newValue.round().toDouble();
              widget.onChanged(
                roundedValue.clamp(minValue.toDouble(), maxValue.toDouble()),
              );
            },
            onPanUpdate: (details) {
              final tapX = details.localPosition.dx;
              final normalizedX = (tapX / trackWidth).clamp(0.0, 1.0);
              final newValue = minValue + (normalizedX * (maxValue - minValue));
              final roundedValue = newValue.round().toDouble();
              widget.onChanged(
                roundedValue.clamp(minValue.toDouble(), maxValue.toDouble()),
              );
            },
            child: SizedBox(
              width: trackWidth,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(trackWidth, 4),
                    painter: _SliderTrackPainter(
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      markerCount: markerCount,
                      activeMarkerCount: currentValue - minValue + 1,
                      trackHeight: 4,
                      markerSize: 8,
                      thumbPosition: thumbPosition,
                    ),
                  ),
                  Positioned(
                    left: thumbPosition - 10,
                    top: -8,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: activeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: trackWidth,
            height: 24,
            child: Stack(
              clipBehavior: Clip.none,
            children: List.generate(markerCount, (index) {
              final markerValue = minValue + index;
                final valueThumbPosition = markerCount > 1
                    ? (index / (markerCount - 1)) * trackWidth
                    : trackWidth / 2;

                final isSelected = markerValue == currentValue;
                final baseStyle = Theme.of(context).textTheme.bodySmall ??
                    const TextStyle(fontSize: 12);

                final labelText =
                    widget.valueLabels?[markerValue.toString()] ?? '$markerValue';

                final textStyle = baseStyle.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? activeColor
                      : Theme.of(context).colorScheme.outline,
                );

                final textPainter = TextPainter(
                  text: TextSpan(
                    text: labelText,
                    style: textStyle,
                  ),
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                );
                textPainter.layout();
                final textWidth = textPainter.width;

                return Positioned(
                  left: valueThumbPosition - textWidth / 2,
                  top: 0,
                  child: Text(
                    labelText,
                    style: textStyle,
                ),
              );
            }),
            ),
          ),
        ),
      ],
    );
  }
}

class _SliderTrackPainter extends CustomPainter {
  final Color activeColor;
  final Color inactiveColor;
  final int markerCount;
  final int activeMarkerCount;
  final double trackHeight;
  final double markerSize;
  final double thumbPosition;

  _SliderTrackPainter({
    required this.activeColor,
    required this.inactiveColor,
    required this.markerCount,
    required this.activeMarkerCount,
    required this.trackHeight,
    required this.markerSize,
    required this.thumbPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final trackPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.fill;

    final activeTrackPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    final trackY = size.height / 2;
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, trackY - trackHeight / 2, size.width, trackHeight),
      Radius.zero,
    );

    canvas.drawRRect(trackRect, trackPaint);

    final activeWidth = thumbPosition.clamp(0.0, size.width);
    if (activeWidth > 0) {
      final activeRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, trackY - trackHeight / 2, activeWidth, trackHeight),
        Radius.zero,
      );
      canvas.drawRRect(activeRect, activeTrackPaint);
    }

    final markerPaint = Paint()
      ..style = PaintingStyle.fill;

    for (int i = 0; i < markerCount; i++) {
      final isActive = i < activeMarkerCount;
      markerPaint.color = isActive ? activeColor : inactiveColor;

      final markerX = markerCount > 1 ? (i / (markerCount - 1)) * size.width : size.width / 2;
      final markerY = trackY;

      canvas.drawCircle(
        Offset(markerX, markerY),
        markerSize / 2,
        markerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_SliderTrackPainter oldDelegate) {
    return oldDelegate.activeMarkerCount != activeMarkerCount ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.thumbPosition != thumbPosition;
  }
}

class GradientRectSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  final LinearGradient gradient;
  final bool darkenInactive;

  const GradientRectSliderTrackShape({
    required this.gradient,
    this.darkenInactive = true,
  });

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);

    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final ColorTween inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint rightTrackPaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final Rect leftTrackSegment = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );
    final Rect rightTrackSegment = Rect.fromLTRB(
      thumbCenter.dx,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
    );

    context.canvas.drawRect(leftTrackSegment, activePaint);
    context.canvas.drawRect(rightTrackSegment, rightTrackPaint);
  }
}



