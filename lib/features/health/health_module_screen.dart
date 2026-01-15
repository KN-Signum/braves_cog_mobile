import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../onboarding/widgets/medication_autocomplete.dart';
import 'widgets/specialization_autocomplete.dart';

class HealthData {
  bool doctorVisited;
  String? specialization;
  String? symptoms;
  String? diagnosis;
  String? procedures;
  String? takingMeds;
  bool medsChanged;
  List<String> medicationNames;
  List<String> adverseEvents;
  List<String> adverseEventsOther;
  int sleepHours;
  String? sleepQuality;
  int sleepWakings;
  int activityMinutes;
  List<String> activityTypes;
  List<String> nutrition;
  List<String> nutritionOther;

  HealthData({
    this.doctorVisited = false,
    this.specialization,
    this.symptoms,
    this.diagnosis,
    this.procedures,
    this.takingMeds,
    this.medsChanged = false,
    List<String>? medicationNames,
    this.adverseEvents = const [],
    this.adverseEventsOther = const [],
    this.sleepHours = 0,
    this.sleepQuality,
    this.sleepWakings = 0,
    this.activityMinutes = 0,
    this.activityTypes = const [],
    this.nutrition = const [],
    this.nutritionOther = const [],
  }) : medicationNames = medicationNames ?? [];

  Map<String, dynamic> toJson() => {
        'doctorVisited': doctorVisited,
        'specialization': specialization,
        'symptoms': symptoms,
        'diagnosis': diagnosis,
        'procedures': procedures,
        'takingMeds': takingMeds,
        'medsChanged': medsChanged,
        'medicationNames': medicationNames,
        'adverseEvents': adverseEvents,
        'adverseEventsOther': adverseEventsOther,
        'sleepHours': sleepHours,
        'sleepQuality': sleepQuality,
        'sleepWakings': sleepWakings,
        'activityMinutes': activityMinutes,
        'activityTypes': activityTypes,
        'nutrition': nutrition,
        'nutritionOther': nutritionOther,
        'submittedAt': DateTime.now().toIso8601String(),
      };
}

class HealthModuleScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HealthModuleScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  State<HealthModuleScreen> createState() => _HealthModuleScreenState();
}

class _HealthModuleScreenState extends State<HealthModuleScreen> {
  int _currentStep = 0;
  final int _totalSteps = 8;
  
  late HealthData _healthData;

  final _specializationController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _proceduresController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _healthData = HealthData();
  }

  @override
  void dispose() {
    _specializationController.dispose();
    _symptomsController.dispose();
    _diagnosisController.dispose();
    _proceduresController.dispose();
    super.dispose();
  }

  Future<void> _saveHealthData() async {
    final prefs = await SharedPreferences.getInstance();
    final healthHistory = prefs.getStringList('health-history') ?? [];
    healthHistory.add(jsonEncode(_healthData.toJson()));
    await prefs.setStringList('health-history', healthHistory);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dane zdrowotne zapisane!')),
    );
    widget.onBack();
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0: // Doctor Visit
        if (_healthData.doctorVisited) {
          return _healthData.specialization?.isNotEmpty == true &&
                 _healthData.symptoms?.isNotEmpty == true &&
                 _healthData.diagnosis?.isNotEmpty == true &&
                 _healthData.procedures?.isNotEmpty == true;
        }
        return true; // Jeśli nie był u lekarza, może przejść dalej
        
      case 1: // Medications
        if (_healthData.takingMeds == 'prescribed' || _healthData.takingMeds == 'otc') {
          return _healthData.medicationNames.isNotEmpty &&
                 _healthData.medicationNames.every((med) => med.isNotEmpty);
        }
        return _healthData.takingMeds != null;
        
      case 2:
        if (_healthData.adverseEvents.isEmpty) return false;
        if (_healthData.adverseEvents.contains('Inne')) {
          return _healthData.adverseEventsOther.isNotEmpty &&
                 _healthData.adverseEventsOther.every((item) => item.isNotEmpty);
        }
        return true;
        
      case 3:
        return true;
        
      case 4:
        return _healthData.sleepQuality != null;
        
      case 5:
        return true;
        
      case 6:
        return _healthData.activityTypes.isNotEmpty;
        
      case 7:
        if (_healthData.nutrition.isEmpty) return false;
        if (_healthData.nutrition.contains('Inne')) {
          return _healthData.nutritionOther.isNotEmpty &&
                 _healthData.nutritionOther.every((item) => item.isNotEmpty);
        }
        return true;
        
      default:
        return true;
    }
  }

  void _handleNext() {
    if (!_canProceed()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Proszę wypełnić wszystkie wymagane pola',
            style: GoogleFonts.inter(fontSize: 14),
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _saveHealthData();
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    icon: Icon(Icons.chevron_left, color: AppTheme.primaryColor, size: 28),
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
                              '${((_currentStep + 1) / _totalSteps * 100).round()}%',
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
                            value: (_currentStep + 1) / _totalSteps,
                            backgroundColor: AppTheme.lightBackgroundColor,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
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
              child: _buildStepContent(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep == _totalSteps - 1 ? 'Wyślij' : 'Dalej',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.inverseTextColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.arrow_forward, color: AppTheme.inverseTextColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildDoctorVisitStep();
      case 1:
        return _buildMedicationsStep();
      case 2:
        return _buildAdverseEventsStep();
      case 3:
        return _buildSleepHoursStep();
      case 4:
        return _buildSleepQualityStep();
      case 5:
        return _buildSleepWakingsStep();
      case 6:
        return _buildActivityStep();
      case 7:
        return _buildNutritionStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildDoctorVisitStep() {
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
                _healthData.doctorVisited == true,
                () => setState(() => _healthData.doctorVisited = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChoiceButton(
                'Nie',
                _healthData.doctorVisited == false,
                () => setState(() => _healthData.doctorVisited = false),
              ),
            ),
          ],
        ),
        if (_healthData.doctorVisited) ...[
          const SizedBox(height: 24),
          SpecializationAutocomplete(
            initialValue: _healthData.specialization,
            onChanged: (value) {
              setState(() {
                _healthData.specialization = value;
                _specializationController.text = value;
              });
            },
            label: 'Specjalizacja lekarza',
            hint: 'np. Kardiolog, Dermatolog',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Objawy',
            _symptomsController,
            (value) => _healthData.symptoms = value,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Diagnoza',
            _diagnosisController,
            (value) => _healthData.diagnosis = value,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Zalecone procedury',
            _proceduresController,
            (value) => _healthData.procedures = value,
            maxLines: 3,
          ),
        ],
      ],
    );
  }

  Widget _buildMedicationsStep() {
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
        ].map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildChoiceButton(
                option.$2,
                _healthData.takingMeds == option.$1,
                () => setState(() => _healthData.takingMeds = option.$1),
              ),
            )),
        if (_healthData.takingMeds == 'prescribed' || _healthData.takingMeds == 'otc') ...[
          const SizedBox(height: 24),
          ..._healthData.medicationNames.asMap().entries.map((entry) {
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
                        setState(() {
                          _healthData.medicationNames[index] = value;
                        });
                      },
                      label: 'Lek ${index + 1}',
                      hint: 'Wpisz nazwę leku (np. Amotaks)',
                    ),
                  ),
                  if (_healthData.medicationNames.length > 1) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _healthData.medicationNames.removeAt(index);
                        });
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
              setState(() {
                _healthData.medicationNames.add('');
              });
            },
            icon: const Icon(Icons.add),
            label: Text(
              _healthData.medicationNames.isEmpty ? 'Dodaj lek' : 'Dodaj kolejny lek',
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
          if (_healthData.medicationNames.isEmpty)
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

  Widget _buildAdverseEventsStep() {
    final events = [
      'Brak',
      'Ból głowy',
      'Nudności',
      'Zawroty głowy',
      'Zmęczenie',
      'Bezsenność',
      'Inne',
    ];

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
        ...events.map((event) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildMultiChoiceButton(
                event,
                _healthData.adverseEvents.contains(event),
                () {
                  setState(() {
                    if (event == 'Brak') {
                      if (_healthData.adverseEvents.contains('Brak')) {
                        _healthData.adverseEvents = [];
                      } else {
                        _healthData.adverseEvents = ['Brak'];
                        _healthData.adverseEventsOther = [];
                      }
                    } else if (event == 'Inne') {
                      if (_healthData.adverseEvents.contains('Inne')) {
                        _healthData.adverseEvents = 
                            _healthData.adverseEvents.where((e) => e != 'Inne').toList();
                        _healthData.adverseEventsOther = [];
                      } else {
                        _healthData.adverseEvents = [
                          ..._healthData.adverseEvents.where((e) => e != 'Brak'),
                          'Inne'
                        ];
                        if (_healthData.adverseEventsOther.isEmpty) {
                          _healthData.adverseEventsOther = [''];
                        }
                      }
                    } else {
                      if (_healthData.adverseEvents.contains(event)) {
                        _healthData.adverseEvents = 
                            _healthData.adverseEvents.where((e) => e != event).toList();
                      } else {
                        _healthData.adverseEvents = [
                          ..._healthData.adverseEvents.where((e) => e != 'Brak'),
                          event
                        ];
                      }
                    }
                  });
                },
              ),
            )),
        if (_healthData.adverseEvents.contains('Inne')) ...[
          const SizedBox(height: 16),
          ..._healthData.adverseEventsOther.asMap().entries.map((entry) {
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
                          setState(() {
                            _healthData.adverseEventsOther[index] = value;
                          });
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
                        ),
                      ),
                    ),
                  ),
                  if (_healthData.adverseEventsOther.length > 1) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _healthData.adverseEventsOther.removeAt(index);
                        });
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
              setState(() {
                _healthData.adverseEventsOther.add('');
              });
            },
            icon: const Icon(Icons.add),
            label: Text(
              _healthData.adverseEventsOther.isEmpty ? 'Dodaj' : 'Dodaj kolejne',
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

  Widget _buildSleepHoursStep() {
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
            '${_healthData.sleepHours}h',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        Slider(
          value: _healthData.sleepHours.toDouble(),
          min: 0,
          max: 12,
          divisions: 12,
          label: '${_healthData.sleepHours}h',
          activeColor: AppTheme.accentColor,
          inactiveColor: AppTheme.lightBackgroundColor,
          onChanged: (value) {
            setState(() => _healthData.sleepHours = value.toInt());
          },
        ),
      ],
    );
  }

  Widget _buildSleepQualityStep() {
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
        ...qualities.map((quality) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildChoiceButtonWithIcon(
                quality.$2,
                quality.$3,
                _healthData.sleepQuality == quality.$1,
                () => setState(() => _healthData.sleepQuality = quality.$1),
              ),
            )),
      ],
    );
  }

  Widget _buildSleepWakingsStep() {
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
            '${_healthData.sleepWakings}x',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        Slider(
          value: _healthData.sleepWakings.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          label: '${_healthData.sleepWakings}x',
          activeColor: AppTheme.accentColor,
          inactiveColor: AppTheme.lightBackgroundColor,
          onChanged: (value) {
            setState(() => _healthData.sleepWakings = value.toInt());
          },
        ),
      ],
    );
  }

  Widget _buildActivityStep() {
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

    final bool hasActivity = _healthData.activityTypes.isNotEmpty && 
                             !_healthData.activityTypes.contains('Brak');

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
        ...activities.map((activity) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildMultiChoiceButton(
                activity,
                _healthData.activityTypes.contains(activity),
                () {
                  setState(() {
                    if (activity == 'Brak') {
                      if (_healthData.activityTypes.contains('Brak')) {
                        _healthData.activityTypes = [];
                      } else {
                        _healthData.activityTypes = ['Brak'];
                        _healthData.activityMinutes = 0;
                      }
                    } else {
                      if (_healthData.activityTypes.contains(activity)) {
                        _healthData.activityTypes =
                            _healthData.activityTypes.where((a) => a != activity).toList();
                        if (_healthData.activityTypes.isEmpty || 
                            _healthData.activityTypes.contains('Brak')) {
                          _healthData.activityMinutes = 0;
                        }
                      } else {
                        _healthData.activityTypes = [
                          ..._healthData.activityTypes.where((a) => a != 'Brak'),
                          activity
                        ];
                        if (_healthData.activityMinutes == 0) {
                          _healthData.activityMinutes = 5;
                        }
                      }
                    }
                  });
                },
              ),
            )),
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
              '${_healthData.activityMinutes} min',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          Slider(
            value: _healthData.activityMinutes.toDouble().clamp(5.0, 180.0),
            min: 5,
            max: 180,
            divisions: 35,
            label: '${_healthData.activityMinutes} min',
            activeColor: AppTheme.accentColor,
            inactiveColor: AppTheme.lightBackgroundColor,
            onChanged: (value) {
              setState(() => _healthData.activityMinutes = value.toInt());
            },
          ),
        ],
      ],
    );
  }

  Widget _buildNutritionStep() {
    final foods = [
      'Owoce',
      'Warzywa',
      'Białko (mięso, ryby)',
      'Nabiał',
      'Produkty pełnoziarniste',
      'Fast food',
      'Słodycze',
      'Inne',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Co jadłeś/aś dzisiaj?',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Zaznacz wszystkie grupy produktów',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 24),
        ...foods.map((food) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildMultiChoiceButton(
                food,
                _healthData.nutrition.contains(food),
                () {
                  setState(() {
                    if (food == 'Inne') {
                      if (_healthData.nutrition.contains('Inne')) {
                        _healthData.nutrition =
                            _healthData.nutrition.where((f) => f != 'Inne').toList();
                        _healthData.nutritionOther = [];
                      } else {
                        _healthData.nutrition = [..._healthData.nutrition, 'Inne'];
                        if (_healthData.nutritionOther.isEmpty) {
                          _healthData.nutritionOther = [''];
                        }
                      }
                    } else {
                      if (_healthData.nutrition.contains(food)) {
                        _healthData.nutrition =
                            _healthData.nutrition.where((f) => f != food).toList();
                      } else {
                        _healthData.nutrition = [..._healthData.nutrition, food];
                      }
                    }
                  });
                },
              ),
            )),
        if (_healthData.nutrition.contains('Inne')) ...[
          const SizedBox(height: 16),
          ..._healthData.nutritionOther.asMap().entries.map((entry) {
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
                          setState(() {
                            _healthData.nutritionOther[index] = value;
                          });
                        },
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppTheme.primaryColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Inne produkty ${index + 1}',
                          hintText: 'Wpisz produkt',
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
                        ),
                      ),
                    ),
                  ),
                  if (_healthData.nutritionOther.length > 1) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _healthData.nutritionOther.removeAt(index);
                        });
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
              setState(() {
                _healthData.nutritionOther.add('');
              });
            },
            icon: const Icon(Icons.add),
            label: Text(
              _healthData.nutritionOther.isEmpty ? 'Dodaj' : 'Dodaj kolejny',
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
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppTheme.primaryColor,
          ),
          decoration: InputDecoration(
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
            color: isSelected ? AppTheme.accentColor : AppTheme.lightBackgroundColor,
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
      String label, IconData icon, bool isSelected, VoidCallback onTap) {
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
            color: isSelected ? AppTheme.accentColor : AppTheme.lightBackgroundColor,
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
                color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiChoiceButton(String label, bool isSelected, VoidCallback onTap) {
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
            color: isSelected ? AppTheme.accentColor : AppTheme.lightBackgroundColor,
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
                color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

