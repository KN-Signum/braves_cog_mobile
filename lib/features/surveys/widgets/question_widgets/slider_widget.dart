import 'package:flutter/material.dart';

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



