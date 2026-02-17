import 'package:flutter/material.dart';

class TableQuestionWidget extends StatefulWidget {
  final Map<String, String?> selectedValues;
  final Function(String rowKey, String columnKey) onChanged;
  final List<String> rows;
  final List<String> columns;
  final Map<String, String>? rowLabels;
  final Map<String, String>? columnLabels;
  final Map<String, String>? rowTooltips;

  const TableQuestionWidget({
    super.key,
    required this.selectedValues,
    required this.onChanged,
    required this.rows,
    required this.columns,
    this.rowLabels,
    this.columnLabels,
    this.rowTooltips,
  });

  @override
  State<TableQuestionWidget> createState() => _TableQuestionWidgetState();
}

class _TableQuestionWidgetState extends State<TableQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1,
        ),
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                ...widget.columns.map((column) => Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      widget.columnLabels?[column] ?? column,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          ...widget.rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            final isLast = index == widget.rows.length - 1;

            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: isLast
                      ? BorderSide.none
                      : BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.rowLabels?[row]?.split('\n').first ?? row,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (widget.rowTooltips?[row] != null) ...[
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide(
                                        color: Theme.of(context).colorScheme.secondary,
                                        width: 2,
                                      ),
                                    ),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.rowLabels?[row]?.split('\n').first ?? row,
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context).colorScheme.onPrimary,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Theme.of(context).colorScheme.onPrimary,
                                          ),
                                          onPressed: () => Navigator.of(context).pop(),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                    content: Text(
                                      widget.rowTooltips![row]!,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.info_outline,
                                size: 20,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  ...widget.columns.map((column) {
                    final isSelected = widget.selectedValues[row] == column;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.onChanged(row, column);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                width: 1,
                              ),
                            ),
                            color: isSelected
                                ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Icon(
                              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

