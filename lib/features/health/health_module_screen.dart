import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/features/health/domain/entities/health_data_entity.dart';
import 'package:braves_cog/features/health/presentation/providers/health_form_provider.dart';

import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../onboarding/widgets/medication_autocomplete.dart';
import 'widgets/specialization_autocomplete.dart';

class HealthModuleScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const HealthModuleScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  ConsumerState<HealthModuleScreen> createState() => _HealthModuleScreenState();
}

class _HealthModuleScreenState extends ConsumerState<HealthModuleScreen> {
  final int _totalSteps = 8;

  final _specializationController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _proceduresController = TextEditingController();

  Future<void> _submitData() async {
    await ref.read(healthFormProvider.notifier).submit();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Dane zdrowotne zapisane!')));
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthFormProvider);
    final currentStep = state.currentStep;
    final totalSteps = _totalSteps;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: AppTheme.primaryColor,
                      size: 28,
                    ),
                    onPressed: _handleBack,
                    style: IconButton.styleFrom(
                      shape: const CircleBorder(),
                      side: BorderSide(color: AppTheme.primaryColor, width: 2),
                      minimumSize: const Size(44, 44),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Moduł zdrowia',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryColor,
                                letterSpacing: -0.1,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${((currentStep + 1) / totalSteps * 100).round()}%',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: (currentStep + 1) / totalSteps,
                            backgroundColor: AppTheme.lightBackgroundColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.accentColor,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildStepContent(state.data, currentStep),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => _handleNext(state.data, currentStep),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: state.isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentStep == totalSteps - 1 ? 'Wyślij' : 'Dalej',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.inverseTextColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.arrow_forward,
                          color: AppTheme.inverseTextColor,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed(HealthDataEntity data, int step) {
    switch (step) {
      case 0: // Doctor Visit
        if (data.doctorVisited) {
          return data.specialization?.isNotEmpty == true &&
              data.symptoms?.isNotEmpty == true &&
              data.diagnosis?.isNotEmpty == true &&
              data.procedures?.isNotEmpty == true;
        }
        return true;

      case 1: // Medications
        if (data.takingMeds == 'prescribed' || data.takingMeds == 'otc') {
          return data.medicationNames.isNotEmpty &&
              data.medicationNames.every((med) => med.isNotEmpty);
        }
        return data.takingMeds != null;

      case 2:
        if (data.adverseEvents.isEmpty) return false;
        if (data.adverseEvents.contains('Inne')) {
          return data.adverseEventsOther.isNotEmpty &&
              data.adverseEventsOther.every((item) => item.isNotEmpty);
        }
        return true;

      case 3:
        return true;

      case 4:
        return data.sleepQuality != null;

      case 5:
        return true;

      case 6:
        return data.activityTypes.isNotEmpty;

      case 7:
        if (data.nutrition.isEmpty) return false;
        if (data.nutrition.contains('Inne')) {
          return data.nutritionOther.isNotEmpty &&
              data.nutritionOther.every((item) => item.isNotEmpty);
        }
        return true;

      default:
        return true;
    }
  }

  void _handleNext(HealthDataEntity data, int step) {
    if (!_canProceed(data, step)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Proszę wypełnić wszystkie wymagane pola',
            style: GoogleFonts.inter(fontSize: 14),
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (step < _totalSteps - 1) {
      ref.read(healthFormProvider.notifier).nextStep();
    } else {
      _submitData();
    }
  }

  void _handleBack() {
    final step = ref.read(healthFormProvider).currentStep;
    if (step > 0) {
      ref.read(healthFormProvider.notifier).previousStep();
    } else {
      widget.onBack();
    }
  }

  Widget _buildStepContent(HealthDataEntity data, int currentStep) {
    switch (currentStep) {
      case 0:
        return _buildDoctorVisitStep(data);
      case 1:
        return _buildMedicationsStep(data);
      case 2:
        return _buildAdverseEventsStep(data);
      case 3:
        return _buildSleepHoursStep(data);
      case 4:
        return _buildSleepQualityStep(data);
      case 5:
        return _buildSleepWakingsStep(data);
      case 6:
        return _buildActivityStep(data);
      case 7:
        return _buildNutritionStep(data);
      default:
        return const SizedBox();
    }
  }

  Widget _buildDoctorVisitStep(HealthDataEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Czy byłeś/aś u lekarza w ostatnim tygodniu?',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildChoiceButton(
                'Tak',
                data.doctorVisited == true,
                () => ref
                    .read(healthFormProvider.notifier)
                    .updateData(data.copyWith(doctorVisited: true)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChoiceButton(
                'Nie',
                data.doctorVisited == false,
                () => ref
                    .read(healthFormProvider.notifier)
                    .updateData(data.copyWith(doctorVisited: false)),
              ),
            ),
          ],
        ),
        if (data.doctorVisited) ...[
          const SizedBox(height: 24),
          SpecializationAutocomplete(
            initialValue: data.specialization,
            onChanged: (value) {
              ref
                  .read(healthFormProvider.notifier)
                  .updateData(data.copyWith(specialization: value));
              _specializationController.text = value;
            },
            label: 'Specjalizacja lekarza',
            hint: 'np. Kardiolog, Dermatolog',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Objawy',
            _symptomsController,
            (value) => ref
                .read(healthFormProvider.notifier)
                .updateData(data.copyWith(symptoms: value)),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Diagnoza',
            _diagnosisController,
            (value) => ref
                .read(healthFormProvider.notifier)
                .updateData(data.copyWith(diagnosis: value)),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Zalecone procedury',
            _proceduresController,
            (value) => ref
                .read(healthFormProvider.notifier)
                .updateData(data.copyWith(procedures: value)),
            maxLines: 3,
          ),
        ],
      ],
    );
  }

  Widget _buildMedicationsStep(HealthDataEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Czy przyjmujesz jakieś leki?',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        ...[
          ('prescribed', 'Przepisane przez lekarza'),
          ('otc', 'Bez recepty'),
          ('none', 'Nie przyjmuję'),
          ('prefer-not-to-say', 'Wolę nie mówić'),
        ].map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildChoiceButton(
              option.$2,
              data.takingMeds == option.$1,
              () => ref
                  .read(healthFormProvider.notifier)
                  .updateData(data.copyWith(takingMeds: option.$1)),
            ),
          ),
        ),
        if (data.takingMeds == 'prescribed' || data.takingMeds == 'otc') ...[
          const SizedBox(height: 24),
          ...data.medicationNames.asMap().entries.map((entry) {
            final index = entry.key;
            final medication = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: MedicationAutocomplete(
                      key: ValueKey('health_medication_$index'),
                      initialValue: medication,
                      onChanged: (value) {
                        final newNames = List<String>.from(
                          data.medicationNames,
                        );
                        newNames[index] = value;
                        ref
                            .read(healthFormProvider.notifier)
                            .updateData(
                              data.copyWith(medicationNames: newNames),
                            );
                      },
                      label: 'Lek ${index + 1}',
                      hint: 'Wpisz nazwę leku (np. Amotaks)',
                    ),
                  ),
                  if (data.medicationNames.length > 1) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        final newNames = List<String>.from(
                          data.medicationNames,
                        );
                        newNames.removeAt(index);
                        ref
                            .read(healthFormProvider.notifier)
                            .updateData(
                              data.copyWith(medicationNames: newNames),
                            );
                      },
                      icon: Icon(Icons.remove_circle, color: Colors.red[400]),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(44, 44),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              final newNames = List<String>.from(data.medicationNames);
              newNames.add('');
              ref
                  .read(healthFormProvider.notifier)
                  .updateData(data.copyWith(medicationNames: newNames));
            },
            icon: const Icon(Icons.add),
            label: Text(
              data.medicationNames.isEmpty ? 'Dodaj lek' : 'Dodaj kolejny lek',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: AppTheme.primaryColor,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000),
              ),
              elevation: 0,
            ),
          ),
          if (data.medicationNames.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Kliknij przycisk aby dodać lek',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.primaryColor.withOpacity(0.6),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildAdverseEventsStep(HealthDataEntity data) {
    final events = [
      'Brak',
      'Ból głowy',
      'Nudności',
      'Zawroty głowy',
      'Zmęczenie',
      'Bezsenność',
      'Inne',
    ];

    void updateAdverseEvents(String event) {
      if (event == 'Brak') {
        if (data.adverseEvents.contains('Brak')) {
          ref
              .read(healthFormProvider.notifier)
              .updateData(
                data.copyWith(adverseEvents: [], adverseEventsOther: []),
              );
        } else {
          ref
              .read(healthFormProvider.notifier)
              .updateData(
                data.copyWith(adverseEvents: ['Brak'], adverseEventsOther: []),
              );
        }
      } else if (event == 'Inne') {
        if (data.adverseEvents.contains('Inne')) {
          final newEvents = data.adverseEvents
              .where((e) => e != 'Inne')
              .toList();
          ref
              .read(healthFormProvider.notifier)
              .updateData(
                data.copyWith(adverseEvents: newEvents, adverseEventsOther: []),
              );
        } else {
          final newEvents = [
            ...data.adverseEvents.where((e) => e != 'Brak'),
            'Inne',
          ];
          final newOther = data.adverseEventsOther.isEmpty
              ? ['']
              : data.adverseEventsOther;
          ref
              .read(healthFormProvider.notifier)
              .updateData(
                data.copyWith(
                  adverseEvents: newEvents,
                  adverseEventsOther: newOther,
                ),
              );
        }
      } else {
        if (data.adverseEvents.contains(event)) {
          final newEvents = data.adverseEvents
              .where((e) => e != event)
              .toList();
          ref
              .read(healthFormProvider.notifier)
              .updateData(data.copyWith(adverseEvents: newEvents));
        } else {
          final newEvents = [
            ...data.adverseEvents.where((e) => e != 'Brak'),
            event,
          ];
          ref
              .read(healthFormProvider.notifier)
              .updateData(data.copyWith(adverseEvents: newEvents));
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Czy wystąpiły jakieś działania niepożądane?',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        ...events.map(
          (event) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMultiChoiceButton(
              event,
              data.adverseEvents.contains(event),
              () => updateAdverseEvents(event),
            ),
          ),
        ),
        if (data.adverseEvents.contains('Inne')) ...[
          const SizedBox(height: 16),
          ...data.adverseEventsOther.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 343),
                      child: TextField(
                        controller: TextEditingController(text: item)
                          ..selection = TextSelection.fromPosition(
                            TextPosition(offset: item.length),
                          ),
                        onChanged: (value) {
                          final newOther = List<String>.from(
                            data.adverseEventsOther,
                          );
                          newOther[index] = value;
                          ref
                              .read(healthFormProvider.notifier)
                              .updateData(
                                data.copyWith(adverseEventsOther: newOther),
                              );
                        },
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppTheme.primaryColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Inne działanie niepożądane ${index + 1}',
                          hintText: 'Wpisz działanie niepożądane',
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
                            borderSide: BorderSide(
                              color: AppTheme.lightBackgroundColor,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: AppTheme.lightBackgroundColor,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: AppTheme.accentColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (data.adverseEventsOther.length > 1) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        final newOther = List<String>.from(
                          data.adverseEventsOther,
                        );
                        newOther.removeAt(index);
                        ref
                            .read(healthFormProvider.notifier)
                            .updateData(
                              data.copyWith(adverseEventsOther: newOther),
                            );
                      },
                      icon: Icon(Icons.remove_circle, color: Colors.red[400]),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(44, 44),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              final newOther = List<String>.from(data.adverseEventsOther);
              newOther.add('');
              ref
                  .read(healthFormProvider.notifier)
                  .updateData(data.copyWith(adverseEventsOther: newOther));
            },
            icon: const Icon(Icons.add),
            label: Text(
              data.adverseEventsOther.isEmpty ? 'Dodaj' : 'Dodaj kolejne',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: AppTheme.primaryColor,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSleepHoursStep(HealthDataEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ile godzin spałeś/aś ostatniej nocy?',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 48),
        Center(
          child: Text(
            '${data.sleepHours}h',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        Slider(
          value: data.sleepHours.toDouble(),
          min: 0,
          max: 12,
          divisions: 12,
          label: '${data.sleepHours}h',
          activeColor: AppTheme.accentColor,
          inactiveColor: AppTheme.lightBackgroundColor,
          onChanged: (value) {
            ref
                .read(healthFormProvider.notifier)
                .updateData(data.copyWith(sleepHours: value.toInt()));
          },
        ),
      ],
    );
  }

  Widget _buildSleepQualityStep(HealthDataEntity data) {
    final qualities = [
      ('excellent', 'Doskonała', Icons.sentiment_very_satisfied),
      ('good', 'Dobra', Icons.sentiment_satisfied),
      ('fair', 'Średnia', Icons.sentiment_neutral),
      ('poor', 'Słaba', Icons.sentiment_dissatisfied),
      ('worst', 'Najgorsza', Icons.sentiment_very_dissatisfied),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jak oceniasz jakość swojego snu?',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        ...qualities.map(
          (quality) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildChoiceButtonWithIcon(
              quality.$2,
              quality.$3,
              data.sleepQuality == quality.$1,
              () => ref
                  .read(healthFormProvider.notifier)
                  .updateData(data.copyWith(sleepQuality: quality.$1)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSleepWakingsStep(HealthDataEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ile razy obudziłeś/aś się w nocy?',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 48),
        Center(
          child: Text(
            '${data.sleepWakings}x',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        Slider(
          value: data.sleepWakings.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          label: '${data.sleepWakings}x',
          activeColor: AppTheme.accentColor,
          inactiveColor: AppTheme.lightBackgroundColor,
          onChanged: (value) {
            ref
                .read(healthFormProvider.notifier)
                .updateData(data.copyWith(sleepWakings: value.toInt()));
          },
        ),
      ],
    );
  }

  Widget _buildActivityStep(HealthDataEntity data) {
    final activities = [
      'Brak',
      'Spacer',
      'Bieganie',
      'Rower',
      'Siłownia',
      'Joga',
      'Pływanie',
      'Inne',
    ];

    final bool hasActivity =
        data.activityTypes.isNotEmpty && !data.activityTypes.contains('Brak');

    void updateActivity(String activity) {
      if (activity == 'Brak') {
        if (data.activityTypes.contains('Brak')) {
          ref
              .read(healthFormProvider.notifier)
              .updateData(data.copyWith(activityTypes: []));
        } else {
          ref
              .read(healthFormProvider.notifier)
              .updateData(
                data.copyWith(activityTypes: ['Brak'], activityMinutes: 0),
              );
        }
      } else {
        if (data.activityTypes.contains(activity)) {
          final newTypes = data.activityTypes
              .where((a) => a != activity)
              .toList();
          final newMinutes = (newTypes.isEmpty || newTypes.contains('Brak'))
              ? 0
              : data.activityMinutes;

          ref
              .read(healthFormProvider.notifier)
              .updateData(
                data.copyWith(
                  activityTypes: newTypes,
                  activityMinutes: newMinutes,
                ),
              );
        } else {
          final newTypes = [
            ...data.activityTypes.where((a) => a != 'Brak'),
            activity,
          ];
          final newMinutes = data.activityMinutes == 0
              ? 5
              : data.activityMinutes;

          ref
              .read(healthFormProvider.notifier)
              .updateData(
                data.copyWith(
                  activityTypes: newTypes,
                  activityMinutes: newMinutes,
                ),
              );
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rodzaj aktywności fizycznej:',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        ...activities.map(
          (activity) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMultiChoiceButton(
              activity,
              data.activityTypes.contains(activity),
              () => updateActivity(activity),
            ),
          ),
        ),
        if (hasActivity) ...[
          const SizedBox(height: 32),
          Text(
            'Jak długo byłeś/aś aktywny/a fizycznie?',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${data.activityMinutes} min',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          Slider(
            value: data.activityMinutes.toDouble().clamp(5.0, 180.0),
            min: 5,
            max: 180,
            divisions: 35,
            label: '${data.activityMinutes} min',
            activeColor: AppTheme.accentColor,
            inactiveColor: AppTheme.lightBackgroundColor,
            onChanged: (value) {
              ref
                  .read(healthFormProvider.notifier)
                  .updateData(data.copyWith(activityMinutes: value.toInt()));
            },
          ),
        ],
      ],
    );
  }

  Widget _buildNutritionStep(HealthDataEntity data) {
    final options = [
      'Zdrowa dieta',
      'Fast food',
      'Słodycze',
      'Alkohol',
      'Papierosy',
      'Suplementy',
      'Inne',
    ];

    void updateNutrition(String option) {
      if (option == 'Inne') {
        if (data.nutrition.contains('Inne')) {
          final newNutrition = data.nutrition
              .where((n) => n != 'Inne')
              .toList();
          ref
              .read(healthFormProvider.notifier)
              .updateData(
                data.copyWith(nutrition: newNutrition, nutritionOther: []),
              );
        } else {
          final newNutrition = [...data.nutrition, 'Inne'];
          final newOther = data.nutritionOther.isEmpty
              ? ['']
              : data.nutritionOther;
          ref
              .read(healthFormProvider.notifier)
              .updateData(
                data.copyWith(
                  nutrition: newNutrition,
                  nutritionOther: newOther,
                ),
              );
        }
      } else {
        if (data.nutrition.contains(option)) {
          final newNutrition = data.nutrition
              .where((n) => n != option)
              .toList();
          ref
              .read(healthFormProvider.notifier)
              .updateData(data.copyWith(nutrition: newNutrition));
        } else {
          final newNutrition = [...data.nutrition, option];
          ref
              .read(healthFormProvider.notifier)
              .updateData(data.copyWith(nutrition: newNutrition));
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Odżywianie i używki (ostatni tydzień):',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMultiChoiceButton(
              option,
              data.nutrition.contains(option),
              () => updateNutrition(option),
            ),
          ),
        ),
        if (data.nutrition.contains('Inne')) ...[
          const SizedBox(height: 16),
          ...data.nutritionOther.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 343),
                      child: TextField(
                        controller: TextEditingController(text: item)
                          ..selection = TextSelection.fromPosition(
                            TextPosition(offset: item.length),
                          ),
                        onChanged: (value) {
                          final newOther = List<String>.from(
                            data.nutritionOther,
                          );
                          newOther[index] = value;
                          ref
                              .read(healthFormProvider.notifier)
                              .updateData(
                                data.copyWith(nutritionOther: newOther),
                              );
                        },
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppTheme.primaryColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Inne ${index + 1}',
                          hintText: 'Wpisz inne',
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
                            borderSide: BorderSide(
                              color: AppTheme.lightBackgroundColor,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: AppTheme.lightBackgroundColor,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: AppTheme.accentColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (data.nutritionOther.length > 1) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        final newOther = List<String>.from(data.nutritionOther);
                        newOther.removeAt(index);
                        ref
                            .read(healthFormProvider.notifier)
                            .updateData(
                              data.copyWith(nutritionOther: newOther),
                            );
                      },
                      icon: Icon(Icons.remove_circle, color: Colors.red[400]),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(44, 44),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              final newOther = List<String>.from(data.nutritionOther);
              newOther.add('');
              ref
                  .read(healthFormProvider.notifier)
                  .updateData(data.copyWith(nutritionOther: newOther));
            },
            icon: const Icon(Icons.add),
            label: Text(
              data.nutritionOther.isEmpty ? 'Dodaj' : 'Dodaj kolejne',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: AppTheme.primaryColor,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Function(String) onChanged, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          style: GoogleFonts.inter(fontSize: 16, color: AppTheme.primaryColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppTheme.lightBackgroundColor,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppTheme.lightBackgroundColor,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppTheme.accentColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentColor
                : AppTheme.lightBackgroundColor,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButtonWithIcon(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentColor
                : AppTheme.lightBackgroundColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor,
              size: 32,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiChoiceButton(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentColor
                : AppTheme.lightBackgroundColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
