import 'package:flutter/material.dart';

class ClickableQuestionTextWidget extends StatefulWidget {
  final String questionText;
  final String? tooltipText;
  final TextStyle? textStyle;

  const ClickableQuestionTextWidget({
    super.key,
    required this.questionText,
    this.tooltipText,
    this.textStyle,
  });

  @override
  State<ClickableQuestionTextWidget> createState() =>
      _ClickableQuestionTextWidgetState();
}

class _ClickableQuestionTextWidgetState
    extends State<ClickableQuestionTextWidget> {
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showTooltip(BuildContext context, Offset position) {
    if (widget.tooltipText == null || widget.tooltipText!.isEmpty) return;

    _removeOverlay();

    final overlay = Overlay.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    final tooltipBg = Theme.of(context).colorScheme.surfaceContainerHighest;
    final screenSize = MediaQuery.of(context).size;
    const tooltipMaxWidth = 320.0;
    const tooltipPadding = 16.0;

    // Calculate tooltip position (centered horizontally, below keyword)
    final tooltipX = (screenSize.width - tooltipMaxWidth) / 2;
    final tooltipY = position.dy + 40; // Below the keyword

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop to close tooltip on tap
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Tooltip positioned below keyword, centered
          Positioned(
            left: tooltipX.clamp(
              tooltipPadding,
              screenSize.width - tooltipMaxWidth - tooltipPadding,
            ),
            top: tooltipY,
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxWidth: tooltipMaxWidth),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: tooltipBg,
                  border: Border.all(color: primary, width: 2),
                  borderRadius: BorderRadius.zero,
                ),
                child: Text(
                  widget.tooltipText!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    // Jeśli nie ma tekstu tooltipa, pokazujemy sam tekst pytania.
    if (widget.tooltipText == null || widget.tooltipText!.isEmpty) {
      return Text(
        widget.questionText,
        textAlign: TextAlign.center,
        style: widget.textStyle,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            widget.questionText,
            textAlign: TextAlign.center,
            style: widget.textStyle,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            final RenderBox? renderBox =
                context.findRenderObject() as RenderBox?;
            if (renderBox != null) {
              final screenSize = MediaQuery.of(context).size;
              final globalPosition = renderBox.localToGlobal(Offset.zero);
              final tapPosition = Offset(
                screenSize.width / 2,
                globalPosition.dy + renderBox.size.height / 2,
              );
              _showTooltip(context, tapPosition);
            }
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primary, width: 2),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Center(
              child: Text(
                'i',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
