import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

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
  State<ClickableQuestionTextWidget> createState() => _ClickableQuestionTextWidgetState();
}

class _ClickableQuestionTextWidgetState extends State<ClickableQuestionTextWidget> {
  String? _selectedKeyword;
  OverlayEntry? _overlayEntry;
  final GlobalKey _tooltipKey = GlobalKey();
  TapGestureRecognizer? _keywordTapRecognizer;

  @override
  void dispose() {
    _removeOverlay();
    _keywordTapRecognizer?.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _selectedKeyword = null;
  }

  // Extract keyword from question text (everything after "Jak często jesz/-asz" or "Jak często spożywasz/-asz")
  String? _extractKeyword(String text) {
    final patterns = [
      // Obsługuje zarówno starą formę "jesz/-asz", jak i uproszczoną "jesz".
      RegExp(r'Jak często jesz(?:/-asz)? (.+?)\?'),
      // Analogicznie dla "spożywasz/-asz" vs "spożywasz".
      RegExp(r'Jak często spożywasz(?:/-asz)? (.+?)\?'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }
    return null;
  }

  void _showTooltip(String keyword, BuildContext context, Offset position) {
    if (widget.tooltipText == null || widget.tooltipText!.isEmpty) return;

    _removeOverlay();

    setState(() {
      _selectedKeyword = keyword;
    });

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
            left: tooltipX.clamp(tooltipPadding, screenSize.width - tooltipMaxWidth - tooltipPadding),
            top: tooltipY,
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxWidth: tooltipMaxWidth),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: tooltipBg,
                  border: Border.all(
                    color: primary,
                    width: 2,
                  ),
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
    final keyword = _extractKeyword(widget.questionText);
    final primary = Theme.of(context).colorScheme.primary;

    if (keyword == null || widget.tooltipText == null || widget.tooltipText!.isEmpty) {
      // No keyword found or no tooltip text, just show regular text
      return Text(
        widget.questionText,
        textAlign: TextAlign.center,
        style: widget.textStyle,
      );
    }

    // Split text into parts: before keyword, keyword, after keyword
    final keywordIndex = widget.questionText.indexOf(keyword);
    if (keywordIndex == -1) {
      return Text(
        widget.questionText,
        textAlign: TextAlign.center,
        style: widget.textStyle,
      );
    }

    final beforeKeyword = widget.questionText.substring(0, keywordIndex);
    final afterKeyword = widget.questionText.substring(keywordIndex + keyword.length);

    _keywordTapRecognizer?.dispose();
    _keywordTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        // Get the position of the keyword in the text
        final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          // Calculate approximate position of keyword (centered in text)
          final screenSize = MediaQuery.of(context).size;
          final globalPosition = renderBox.localToGlobal(Offset.zero);
          final tapPosition = Offset(screenSize.width / 2, globalPosition.dy + renderBox.size.height / 2);
          _showTooltip(keyword, context, tapPosition);
        }
      };

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: widget.textStyle,
        children: [
          TextSpan(text: beforeKeyword),
          TextSpan(
            text: keyword,
            recognizer: _keywordTapRecognizer,
            style: (widget.textStyle ?? const TextStyle()).copyWith(
              decoration: TextDecoration.underline,
              decorationColor: primary,
              decorationThickness: 2,
              color: primary,
            ),
          ),
          TextSpan(text: afterKeyword),
        ],
      ),
    );
  }
}

