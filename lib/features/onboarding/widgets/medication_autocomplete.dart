import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/medication_api_service.dart';

/// Widget z autouzupełnianiem dla leków
/// Pobiera dane z oficjalnego API Rejestru Wyrobów Medycznych
/// Źródło: Rejestr Produktów Leczniczych dopuszczonych do obrotu w Polsce
class MedicationAutocomplete extends StatefulWidget {
  final String? initialValue;
  final Function(String) onChanged;
  final String label;
  final String hint;

  const MedicationAutocomplete({
    Key? key,
    this.initialValue,
    required this.onChanged,
    required this.label,
    required this.hint,
  }) : super(key: key);

  @override
  State<MedicationAutocomplete> createState() => _MedicationAutocompleteState();
}

class _MedicationAutocompleteState extends State<MedicationAutocomplete> {
  final MedicationApiService _apiService = MedicationApiService();
  List<String> _medications = [];
  bool _isLoading = true;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue ?? '');
    _loadMedications();
  }

  @override
  void didUpdateWidget(MedicationAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Aktualizuj kontroler gdy initialValue się zmieni
    if (widget.initialValue != oldWidget.initialValue && 
        widget.initialValue != _textController.text) {
      _textController.text = widget.initialValue ?? '';
    }
  }

  Future<void> _loadMedications() async {
    try {
      final medications = await _apiService.getMedications();
      if (mounted) {
        setState(() {
          _medications = medications;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading medications: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: _textController,
      focusNode: FocusNode(),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty || _isLoading) {
          return const Iterable<String>.empty();
        }
        
        final searchText = textEditingValue.text.toLowerCase();
        
        // Używaj danych z API (lub statycznej listy jako fallback)
        return _medications.where((medication) {
          return medication.toLowerCase().contains(searchText);
        }).take(10); // Pokazuj maksymalnie 10 podpowiedzi
      },
      onSelected: (String selection) {
        _textController.text = selection;
        widget.onChanged(selection);
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppTheme.primaryColor,
          ),
          onChanged: (value) {
            widget.onChanged(value);
          },
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              color: AppTheme.primaryColor.withOpacity(0.5),
            ),
            labelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppTheme.lightBackgroundColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppTheme.lightBackgroundColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppTheme.accentColor, width: 2),
            ),
            suffixIcon: Icon(
              Icons.medication,
              color: AppTheme.accentColor,
            ),
          ),
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<String> onSelected,
        Iterable<String> options,
      ) {
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 250,
                  maxWidth: MediaQuery.of(context).size.width - 64,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.lightBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            onSelected(option);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.medication_outlined,
                                  color: AppTheme.accentColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

