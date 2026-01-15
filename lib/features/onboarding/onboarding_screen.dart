import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/year_picker.dart' as custom_pickers;
import 'widgets/height_picker.dart';
import 'widgets/weight_picker.dart';
import 'widgets/icon_option_grid.dart';
import 'widgets/medication_autocomplete.dart';

enum OnboardingStage {
  logo,
  welcome,
  intro,
  profile,
  consentsIntro,
  consents,
  final_,
}

class ProfileData {
  String birthYear;
  String height;
  String weight;
  String currentIllness;
  String chronicDiseases;
  bool smokingCigarettes;
  String smokingFrequency;
  bool drinkingAlcohol;
  String alcoholFrequency;
  bool otherSubstances;
  String otherSubstancesName;
  String otherSubstancesFrequency;
  List<String> allergies;
  List<String> medications;
  String biologicalSex;
  String genderIdentity;
  String genderIdentityOther;
  String education;
  String educationOther;
  String disability;

  ProfileData({
    this.birthYear = '1990',
    this.height = '170',
    this.weight = '70',
    this.currentIllness = '',
    this.chronicDiseases = '',
    this.smokingCigarettes = false,
    this.smokingFrequency = '',
    this.drinkingAlcohol = false,
    this.alcoholFrequency = '',
    this.otherSubstances = false,
    this.otherSubstancesName = '',
    this.otherSubstancesFrequency = '',
    List<String>? allergies,
    List<String>? medications,
    this.biologicalSex = '',
    this.genderIdentity = '',
    this.genderIdentityOther = '',
    this.education = '',
    this.educationOther = '',
    this.disability = '',
  }) : allergies = allergies ?? [],
       medications = medications ?? [];

  Map<String, dynamic> toJson() => {
        'birthYear': birthYear,
        'height': height,
        'weight': weight,
        'currentIllness': currentIllness,
        'chronicDiseases': chronicDiseases,
        'smokingCigarettes': smokingCigarettes,
        'smokingFrequency': smokingFrequency,
        'drinkingAlcohol': drinkingAlcohol,
        'alcoholFrequency': alcoholFrequency,
        'otherSubstances': otherSubstances,
        'otherSubstancesName': otherSubstancesName,
        'otherSubstancesFrequency': otherSubstancesFrequency,
        'allergies': allergies,
        'medications': medications,
        'biologicalSex': biologicalSex,
        'genderIdentity': genderIdentity,
        'genderIdentityOther': genderIdentityOther,
        'education': education,
        'educationOther': educationOther,
        'disability': disability,
        'lastWeightUpdate': DateTime.now().toIso8601String(),
      };
}

class ConsentsData {
  bool dataCollection;
  bool adverseEventsMonitoring;
  bool wantsAdverseEventsMonitoring;
  bool pushNotifications;

  ConsentsData({
    this.dataCollection = true,
    this.adverseEventsMonitoring = true,
    this.wantsAdverseEventsMonitoring = true,
    this.pushNotifications = true,
  });

  Map<String, dynamic> toJson() => {
        'dataCollection': dataCollection,
        'adverseEventsMonitoring': adverseEventsMonitoring,
        'wantsAdverseEventsMonitoring': wantsAdverseEventsMonitoring,
        'pushNotifications': pushNotifications,
      };
}

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  OnboardingStage _stage = OnboardingStage.logo;
  int _profileStep = 0;
  int _consentsStep = 0;

  late ProfileData _profileData;
  late ConsentsData _consents;

  final int totalProfileSteps = 11;
  final int totalConsentsSteps = 3;

  @override
  void initState() {
    super.initState();
    _profileData = ProfileData();
    _consents = ConsentsData();
    _scheduleAutoAdvance();
  }

  @override
  void didUpdateWidget(OnboardingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleAutoAdvance();
  }

  void _scheduleAutoAdvance() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoAdvance();
    });
  }

  void _autoAdvance() {
    if (_stage == OnboardingStage.logo) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _stage = OnboardingStage.welcome);
          _scheduleAutoAdvance();
        }
      });
    } else if (_stage == OnboardingStage.welcome) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _stage = OnboardingStage.intro);
          _scheduleAutoAdvance();
        }
      });
    } else if (_stage == OnboardingStage.intro) {
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) {
          setState(() => _stage = OnboardingStage.profile);
          _scheduleAutoAdvance();
        }
      });
    } else if (_stage == OnboardingStage.consentsIntro) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _stage = OnboardingStage.consents);
          _scheduleAutoAdvance();
        }
      });
    } else if (_stage == OnboardingStage.final_) {
      Future.delayed(const Duration(milliseconds: 2500), () async {
        await _saveData();
        widget.onComplete();
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user-profile', jsonEncode(_profileData.toJson()));
    await prefs.setString('user-consents', jsonEncode(_consents.toJson()));
    await prefs.setBool('onboarding-completed', true);
  }

  bool _canProceedProfile() {
    switch (_profileStep) {
      case 0:
        return _profileData.birthYear.isNotEmpty;
      case 1:
        return _profileData.height.isNotEmpty;
      case 2:
        return _profileData.weight.isNotEmpty;
      case 3:
        return true;
      case 4:
        return true;
      case 5: // Alergie
        return true;
      case 6: // Leki na stałe
        return true;
      case 7: // Płeć biologiczna
        return _profileData.biologicalSex.isNotEmpty;
      case 8: // Tożsamość płciowa
        if (_profileData.genderIdentity == 'other') {
          return _profileData.genderIdentityOther.isNotEmpty;
        }
        return _profileData.genderIdentity.isNotEmpty;
      case 9: // Wykształcenie
        if (_profileData.education == 'other') {
          return _profileData.educationOther.isNotEmpty;
        }
        return _profileData.education.isNotEmpty;
      case 10: // Niepełnosprawność
        return _profileData.disability.isNotEmpty;
      default:
        return false;
    }
  }

  void _handleProfileNext() {
    if (_profileStep < totalProfileSteps - 1) {
      setState(() => _profileStep++);
    } else {
      setState(() {
        _stage = OnboardingStage.consentsIntro;
      });
      _scheduleAutoAdvance();
    }
  }

  void _handleProfileBack() {
    if (_profileStep > 0) {
      setState(() => _profileStep--);
    }
  }

  void _handleConsentsNext() {
    if (_consentsStep < totalConsentsSteps - 1) {
      setState(() => _consentsStep++);
    } else {
      setState(() {
        _stage = OnboardingStage.final_;
      });
      _scheduleAutoAdvance();
    }
  }

  void _handleConsentsBack() {
    if (_consentsStep > 0) {
      setState(() => _consentsStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_stage) {
      case OnboardingStage.logo:
        return _buildLogoScreen();
      case OnboardingStage.welcome:
        return _buildWelcomeScreen();
      case OnboardingStage.intro:
        return _buildIntroScreen();
      case OnboardingStage.consentsIntro:
        return _buildConsentsIntroScreen();
      case OnboardingStage.final_:
        return _buildFinalScreen();
      case OnboardingStage.profile:
        return _buildProfileScreen();
      case OnboardingStage.consents:
        return _buildConsentsScreen();
    }
  }

  Widget _buildLogoScreen() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Image.asset(
          'assets/images/braves_logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Witaj w projekcie\nBRAVES-Cog',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
              height: 1.27,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroScreen() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Pozwól, że przeprowadzę cię\nprzez kilka formalności',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
              height: 1.33,
              letterSpacing: -0.24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConsentsIntroScreen() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Text(
          'Pora na twoje zgody',
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
            height: 1.33,
            letterSpacing: -0.24,
          ),
        ),
      ),
    );
  }

  Widget _buildFinalScreen() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Text(
          'Witaj w aplikacji\nBRAVES-Cog',
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
            height: 1.27,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileScreen() {
    final stepTitles = [
      'Twój rok urodzenia',
      'Twój wzrost',
      'Twoja waga',
      'Historia medyczna',
      'Używki',
      'Alergie',
      'Leki na stałe',
      'Płeć biologiczna',
      'Tożsamość płciowa',
      'Wykształcenie',
      'Niepełnosprawność'
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  onPressed: _profileStep == 0 ? null : _handleProfileBack,
                  icon: Icon(Icons.chevron_left, size: 24, color: AppTheme.primaryColor),
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
                            'Profil',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryColor,
                              letterSpacing: -0.1,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${((_profileStep + 1) / totalProfileSteps * 100).round()}%',
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
                          value: (_profileStep + 1) / totalProfileSteps,
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

          Positioned.fill(
            top: 148,
            bottom: 100,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    stepTitles[_profileStep],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildProfileStepContent(),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _canProceedProfile() ? _handleProfileNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.5),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _profileStep == totalProfileSteps - 1 ? 'Dalej' : 'Kontynuuj',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.inverseTextColor,
                      letterSpacing: -0.072,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.chevron_right, color: AppTheme.inverseTextColor),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStepContent() {
    switch (_profileStep) {
      case 0:
        return custom_pickers.YearPicker(
          value: _profileData.birthYear,
          onChange: (value) => setState(() => _profileData.birthYear = value),
          maxYear: DateTime.now().year,
        );
      case 1:
        return HeightPicker(
          value: _profileData.height,
          onChange: (value) => setState(() => _profileData.height = value),
        );
      case 2:
        return WeightPicker(
          value: _profileData.weight,
          onChange: (value) => setState(() => _profileData.weight = value),
        );
      case 3:
        return Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 343),
              child: TextField(
                maxLines: 4,
                onChanged: (value) => _profileData.currentIllness = value,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.primaryColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Choroba obecna',
                  hintText: 'Opisz swoją obecną chorobę (opcjonalne)',
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
            const SizedBox(height: 16),
            Container(
              constraints: const BoxConstraints(maxWidth: 343),
              child: TextField(
                maxLines: 4,
                onChanged: (value) => _profileData.chronicDiseases = value,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.primaryColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Choroby przewlekłe',
                  hintText: 'Opisz swoje choroby przewlekłe, przyjmowane leki (opcjonalne)',
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
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubstanceSection(
              title: 'Papierosy',
              value: _profileData.smokingCigarettes,
              onChanged: (value) => setState(() {
                _profileData.smokingCigarettes = value;
                if (!value) _profileData.smokingFrequency = '';
              }),
              frequency: _profileData.smokingFrequency,
              onFrequencyChanged: (value) => setState(() => _profileData.smokingFrequency = value),
            ),
            const SizedBox(height: 24),
            _buildSubstanceSection(
              title: 'Alkohol',
              value: _profileData.drinkingAlcohol,
              onChanged: (value) => setState(() {
                _profileData.drinkingAlcohol = value;
                if (!value) _profileData.alcoholFrequency = '';
              }),
              frequency: _profileData.alcoholFrequency,
              onFrequencyChanged: (value) => setState(() => _profileData.alcoholFrequency = value),
            ),
            const SizedBox(height: 24),
            _buildSubstanceSectionWithName(
              title: 'Inne używki',
              value: _profileData.otherSubstances,
              onChanged: (value) => setState(() {
                _profileData.otherSubstances = value;
                if (!value) {
                  _profileData.otherSubstancesName = '';
                  _profileData.otherSubstancesFrequency = '';
                }
              }),
              substanceName: _profileData.otherSubstancesName,
              onNameChanged: (value) => setState(() => _profileData.otherSubstancesName = value),
              frequency: _profileData.otherSubstancesFrequency,
              onFrequencyChanged: (value) => setState(() => _profileData.otherSubstancesFrequency = value),
            ),
          ],
        );
      case 5:
        // Alergie - dynamiczne pola
        return Column(
          children: [
            ..._profileData.allergies.asMap().entries.map((entry) {
              final index = entry.key;
              final allergy = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 343),
                        child: TextField(
                          controller: TextEditingController(text: allergy)
                            ..selection = TextSelection.fromPosition(
                              TextPosition(offset: allergy.length),
                            ),
                          onChanged: (value) {
                            setState(() {
                              _profileData.allergies[index] = value;
                            });
                          },
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Alergia ${index + 1}',
                            hintText: 'Wpisz alergię',
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
                    if (_profileData.allergies.length > 1) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _profileData.allergies.removeAt(index);
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
                  _profileData.allergies.add('');
                });
              },
              icon: const Icon(Icons.add),
              label: Text(
                _profileData.allergies.isEmpty ? 'Dodaj alergię' : 'Dodaj kolejną alergię',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.primaryColor,
                minimumSize: const Size(343, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
            ),
            if (_profileData.allergies.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Możesz pominąć ten krok jeśli nie masz alergii',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.primaryColor.withOpacity(0.6),
                  ),
                ),
              ),
          ],
        );
      case 6:
        // Leki na stałe - dynamiczne pola
        return Column(
          children: [
            ..._profileData.medications.asMap().entries.map((entry) {
              final index = entry.key;
              final medication = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 343),
                        child: MedicationAutocomplete(
                          key: ValueKey('medication_$index'),
                          initialValue: medication,
                          onChanged: (value) {
                            setState(() {
                              _profileData.medications[index] = value;
                            });
                          },
                          label: 'Lek ${index + 1}',
                          hint: 'Wpisz nazwę leku (np. Amotaks)',
                        ),
                      ),
                    ),
                    if (_profileData.medications.length > 1) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _profileData.medications.removeAt(index);
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
                  _profileData.medications.add('');
                });
              },
              icon: const Icon(Icons.add),
              label: Text(
                _profileData.medications.isEmpty ? 'Dodaj lek' : 'Dodaj kolejny lek',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.primaryColor,
                minimumSize: const Size(343, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
            ),
            if (_profileData.medications.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Możesz pominąć ten krok jeśli nie przyjmujesz leków na stałe',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.primaryColor.withOpacity(0.6),
                  ),
                ),
              ),
          ],
        );
      case 7:
        // Płeć biologiczna
        return IconOptionGrid(
          options: [
            IconOption(value: 'female', label: 'Kobieta', icon: Icons.person),
            IconOption(value: 'male', label: 'Mężczyzna', icon: Icons.person),
            IconOption(value: 'prefer-not-to-say', label: 'Wolę nie mówić', icon: Icons.help_outline),
          ],
          value: _profileData.biologicalSex,
          onChange: (value) => setState(() => _profileData.biologicalSex = value),
          columns: 3,
        );
      case 8:
        // Tożsamość płciowa
        return Column(
          children: [
            IconOptionGrid(
              options: [
                IconOption(value: 'female', label: 'Kobieta', icon: Icons.person),
                IconOption(value: 'male', label: 'Mężczyzna', icon: Icons.person),
                IconOption(value: 'non-binary', label: 'Niebinarna', icon: Icons.people),
                IconOption(value: 'prefer-not-to-say', label: 'Wolę nie mówić', icon: Icons.help_outline),
              ],
              value: _profileData.genderIdentity,
              onChange: (value) => setState(() => _profileData.genderIdentity = value),
            ),
            if (_profileData.genderIdentity == 'other') ...[
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => _profileData.genderIdentityOther = value,
                style: GoogleFonts.inter(fontSize: 16, color: AppTheme.primaryColor),
                decoration: InputDecoration(
                  hintText: 'Wpisz...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppTheme.primaryColor.withOpacity(0.5),
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
            ],
          ],
        );
      case 9:
        // Wykształcenie
        return Column(
          children: [
            IconOptionGrid(
              options: [
                IconOption(value: 'podstawowe', label: 'Podstawowe', icon: Icons.menu_book),
                IconOption(value: 'zawodowe', label: 'Zawodowe', icon: Icons.work),
                IconOption(value: 'srednie', label: 'Średnie', icon: Icons.school),
                IconOption(value: 'wyzsze-licencjat', label: 'Licencjat', icon: Icons.workspace_premium),
                IconOption(value: 'wyzsze-magister', label: 'Magister', icon: Icons.emoji_events),
                IconOption(value: 'wyzsze-doktor', label: 'Doktor', icon: Icons.star),
              ],
              value: _profileData.education,
              onChange: (value) => setState(() => _profileData.education = value),
              columns: 3,
            ),
            if (_profileData.education == 'other') ...[
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => _profileData.educationOther = value,
                style: GoogleFonts.inter(fontSize: 16, color: AppTheme.primaryColor),
                decoration: InputDecoration(
                  hintText: 'Wpisz...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppTheme.primaryColor.withOpacity(0.5),
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
            ],
          ],
        );
      case 10:
        // Niepełnosprawność
        return Column(
          children: [
            'Brak',
            'Lekki',
            'Umiarkowany',
            'Znaczny',
            'Wolę nie mówić'
          ].map((option) {
            final value = {
              'Brak': 'none',
              'Lekki': 'lekki',
              'Umiarkowany': 'umiarkowany',
              'Znaczny': 'znaczny',
              'Wolę nie mówić': 'prefer-not-to-say',
            }[option]!;
            final isSelected = _profileData.disability == value;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                onPressed: () => setState(() => _profileData.disability = value),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? AppTheme.accentColor : Colors.white,
                  foregroundColor: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor,
                  minimumSize: const Size(343, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      color: isSelected ? AppTheme.accentColor : AppTheme.lightBackgroundColor,
                      width: 2,
                    ),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  option,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildSubstanceSection({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required String frequency,
    required Function(String) onFrequencyChanged,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 343),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.lightBackgroundColor, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Nie',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: !value ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  Switch(
                    value: value,
                    onChanged: onChanged,
                    activeColor: AppTheme.accentColor,
                  ),
                  Text(
                    'Tak',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: value ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (value) ...[
            const SizedBox(height: 16),
            Text(
              'Jak często?',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            ...[
              '1-2 dziennie',
              '3 lub więcej razy dziennie',
              'Raz w tygodniu',
              'Okazjonalnie'
            ].map((option) {
              final isSelected = frequency == option;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onFrequencyChanged(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.accentColor.withOpacity(0.2) : AppTheme.lightBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppTheme.accentColor : AppTheme.lightBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? AppTheme.accentColor : AppTheme.primaryColor.withOpacity(0.3),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          option,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.primaryColor,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildSubstanceSectionWithName({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required String substanceName,
    required Function(String) onNameChanged,
    required String frequency,
    required Function(String) onFrequencyChanged,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 343),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.lightBackgroundColor, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Nie',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: !value ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  Switch(
                    value: value,
                    onChanged: onChanged,
                    activeColor: AppTheme.accentColor,
                  ),
                  Text(
                    'Tak',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: value ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (value) ...[
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: substanceName)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: substanceName.length),
                ),
              onChanged: onNameChanged,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppTheme.primaryColor,
              ),
              decoration: InputDecoration(
                labelText: 'Nazwa używki',
                hintText: 'np. Kawa, energia drink',
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
                fillColor: AppTheme.lightBackgroundColor,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.accentColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Jak często?',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            ...[
              '1-2 dziennie',
              '3 lub więcej razy dziennie',
              'Raz w tygodniu',
              'Okazjonalnie'
            ].map((option) {
              final isSelected = frequency == option;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onFrequencyChanged(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.accentColor.withOpacity(0.2) : AppTheme.lightBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppTheme.accentColor : AppTheme.lightBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? AppTheme.accentColor : AppTheme.primaryColor.withOpacity(0.3),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          option,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.primaryColor,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildConsentsScreen() {
    final consentTitles = [
      'Monitorowanie działań\nniepożądanych',
      'Zgody i oświadczenia',
      'Powiadomienia PUSH'
    ];

    final consentDescriptions = [
      'Czy wyrażasz zgodę na monitorowanie działań niepożądanych?',
      'Czy wyrażasz zgodę na przetwarzanie danych osobowych w celach badawczych?',
      'Czy chcesz otrzymywać powiadomienia przypominające o wypełnieniu ankiet?'
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  onPressed: _consentsStep == 0 ? null : _handleConsentsBack,
                  icon: Icon(Icons.chevron_left, size: 24, color: AppTheme.primaryColor),
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
                            'Zgody',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryColor,
                              letterSpacing: -0.1,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${((_consentsStep + 1) / totalConsentsSteps * 100).round()}%',
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
                          value: (_consentsStep + 1) / totalConsentsSteps,
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

          Positioned.fill(
            top: 148,
            bottom: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    consentTitles[_consentsStep],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    consentDescriptions[_consentsStep],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor.withOpacity(0.7),
                      letterSpacing: -0.048,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildConsentsStepContent(),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _handleConsentsNext,
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
                    _consentsStep == totalConsentsSteps - 1 ? 'Zakończ' : 'Kontynuuj',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.inverseTextColor,
                      letterSpacing: -0.072,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.chevron_right, color: AppTheme.inverseTextColor),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentsStepContent() {
    bool? currentValue;
    Function(bool) onChange;

    switch (_consentsStep) {
      case 0:
        currentValue = _consents.adverseEventsMonitoring;
        onChange = (value) => setState(() => _consents.adverseEventsMonitoring = value);
        break;
      case 1:
        currentValue = _consents.dataCollection;
        onChange = (value) => setState(() => _consents.dataCollection = value);
        break;
      case 2:
        currentValue = _consents.pushNotifications;
        onChange = (value) => setState(() => _consents.pushNotifications = value);
        break;
      default:
        currentValue = true;
        onChange = (_) {};
    }

    final yesText = _consentsStep == 2 ? 'Tak, chcę otrzymywać powiadomienia' : 'Tak, wyrażam zgodę';
    final noText = _consentsStep == 2 ? 'Nie, dziękuję' : 'Nie, nie wyrażam zgody';

    return Column(
      children: [
        _buildConsentButton(
          label: yesText,
          isSelected: currentValue == true,
          onTap: () => onChange(true),
        ),
        const SizedBox(height: 12),
        _buildConsentButton(
          label: noText,
          isSelected: currentValue == false,
          onTap: () => onChange(false),
        ),
      ],
    );
  }

  Widget _buildConsentButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 343,
        height: 56,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppTheme.accentColor : AppTheme.lightBackgroundColor,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.25),
                    blurRadius: 0,
                    spreadRadius: 4,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor,
              letterSpacing: -0.048,
            ),
          ),
        ),
      ),
    );
  }
}

