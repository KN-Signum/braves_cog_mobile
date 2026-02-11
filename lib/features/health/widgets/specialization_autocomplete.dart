import 'package:flutter/material.dart';


class SpecializationAutocomplete extends StatefulWidget {
  final String? initialValue;
  final Function(String) onChanged;
  final String label;
  final String hint;

  const SpecializationAutocomplete({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.label = 'Specjalizacja lekarza',
    this.hint = 'Wpisz specjalizację',
  });

  @override
  State<SpecializationAutocomplete> createState() => _SpecializationAutocompleteState();
}

class _SpecializationAutocompleteState extends State<SpecializationAutocomplete> {
  late TextEditingController _controller;
  
  static const List<String> _specializations = [
    'Alergologia',
    'Anestezjologia i intensywna terapia',
    'Audiologia i foniatria',
    'Chirurgia dziecięca',
    'Chirurgia klatki piersiowej',
    'Chirurgia naczyniowa',
    'Chirurgia ogólna',
    'Chirurgia onkologiczna',
    'Chirurgia plastyczna',
    'Chirurgia szczękowo-twarzowa',
    'Choroby płuc',
    'Choroby wewnętrzne',
    'Dermatologia i wenerologia',
    'Diabetologia',
    'Endokrynologia',
    'Gastroenterologia',
    'Genetyka kliniczna',
    'Geriatria',
    'Ginekologia onkologiczna',
    'Hematologia',
    'Immunologia kliniczna',
    'Intensywna terapia',
    'Kardiochirurgia',
    'Kardiologia',
    'Medycyna nuklearna',
    'Medycyna paliatywna',
    'Medycyna ratunkowa',
    'Medycyna rodzinna',
    'Medycyna sportowa',
    'Medycyna pracy',
    'Nefrologia',
    'Neonatologia',
    'Neurochirurgia',
    'Neurologia',
    'Okulistyka',
    'Onkologia i hematologia dziecięca',
    'Onkologia kliniczna',
    'Ortopedia i traumatologia',
    'Otorynolaryngologia',
    'Pediatria',
    'Położnictwo i ginekologia',
    'Psychiatria',
    'Psychiatria dzieci i młodzieży',
    'Radiologia i diagnostyka obrazowa',
    'Radioterapia onkologiczna',
    'Reumatologia',
    'Seksuologia',
    'Toksykologia kliniczna',
    'Transplantologia kliniczna',
    'Urologia',
    'Urologia dziecięca',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(SpecializationAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && 
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: _controller,
      focusNode: FocusNode(),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return _specializations.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        _controller.text = selection;
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
          onChanged: widget.onChanged,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
            ),
          ),
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<String> onSelected,
        Iterable<String> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200, maxWidth: 343),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest, width: 2),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: options.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onSelected(option);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            option,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ),
        );
      },
    );
  }
}

