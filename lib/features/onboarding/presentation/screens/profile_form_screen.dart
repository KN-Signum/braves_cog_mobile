import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:braves_cog/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:braves_cog/features/onboarding/widgets/year_picker.dart'
    as custom_pickers;
import 'package:braves_cog/features/onboarding/widgets/height_picker.dart';
import 'package:braves_cog/features/onboarding/widgets/weight_picker.dart';
import 'package:braves_cog/features/onboarding/widgets/icon_option_grid.dart';
import 'package:braves_cog/features/onboarding/widgets/medication_autocomplete.dart';

class ProfileFormScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBackToLogin;

  const ProfileFormScreen({super.key, this.onBackToLogin});

  @override
  ConsumerState<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends ConsumerState<ProfileFormScreen> {
  int _currentStep = 0;
  final int _totalSteps = 11;

  final _stepTitles = [
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
    'Niepełnosprawność',
  ];

  @override
  void initState() {
    super.initState();
    // Load profile data if needed, or it might be empty initially
  }

  bool _canProceed(UserProfileEntity profile) {
    switch (_currentStep) {
      case 0:
        return profile.birthYear.isNotEmpty;
      case 1:
        return profile.height.isNotEmpty;
      case 2:
        return profile.weight.isNotEmpty;
      case 3:
        return true;
      case 4:
        return true;
      case 5: // Alergie
        return true;
      case 6: // Leki na stałe
        return true;
      case 7: // Płeć biologiczna
        return profile.biologicalSex.isNotEmpty;
      case 8: // Tożsamość płciowa
        if (profile.genderIdentity == 'other') {
          return profile.genderIdentityOther.isNotEmpty;
        }
        return profile.genderIdentity.isNotEmpty;
      case 9: // Wykształcenie
        if (profile.education == 'other') {
          return profile.educationOther.isNotEmpty;
        }
        return profile.education.isNotEmpty;
      case 10: // Niepełnosprawność
        return profile.disability.isNotEmpty;
      default:
        return false;
    }
  }

  void _handleNext(UserProfileEntity profile) {
    if (!_canProceed(profile)) return;

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      // Save profile implicitly handled by provider state update,
      // actual persistence happens at end of onboarding or we can save now.
      ref.read(profileProvider.notifier).updateProfile(profile);
      ref
          .read(onboardingProvider.notifier)
          .setStage(OnboardingStage.consentsIntro);
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      // On first step, go back to login if callback provided
      widget.onBackToLogin?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  onPressed: _handleBack,
                  icon: Icon(
                    Icons.chevron_left,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Profil',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.1,
                              ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: (_currentStep + 1) / _totalSteps,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 44,
                  child: Center(
                    child: Text(
                      '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                    _stepTitles[_currentStep],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildProfileStepContent(profile),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _canProceed(profile)
                  ? () => _handleNext(profile)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                disabledBackgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.5),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep == _totalSteps - 1 ? 'Dalej' : 'Kontynuuj',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onPrimary,
                      letterSpacing: -0.072,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
          ),

          // Progress Dots
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStepContent(UserProfileEntity profile) {
    switch (_currentStep) {
      case 0:
        return custom_pickers.YearPicker(
          value: profile.birthYear,
          onChange: (value) =>
              _updateProfile(profile.copyWith(birthYear: value)),
          maxYear: DateTime.now().year,
        );
      case 1:
        return HeightPicker(
          height: profile.height,
          onHeightChanged: (value) =>
              _updateProfile(profile.copyWith(height: value)),
        );
      case 2:
        return WeightPicker(
          weight: profile.weight,
          onWeightChanged: (value) =>
              _updateProfile(profile.copyWith(weight: value)),
        );
      case 3:
        return Column(
          children: [
            _buildTextField(
              label: 'Choroba obecna',
              hint: 'Opisz swoją obecną chorobę (opcjonalne)',
              value: profile.currentIllness,
              onChanged: (value) =>
                  _updateProfile(profile.copyWith(currentIllness: value)),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Choroby przewlekłe',
              hint:
                  'Opisz swoje choroby przewlekłe, przyjmowane leki (opcjonalne)',
              value: profile.chronicDiseases,
              onChanged: (value) =>
                  _updateProfile(profile.copyWith(chronicDiseases: value)),
            ),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubstanceSection(
              title: 'Papierosy',
              value: profile.smokingCigarettes,
              onChanged: (value) => _updateProfile(
                profile.copyWith(
                  smokingCigarettes: value,
                  smokingFrequency: !value ? '' : profile.smokingFrequency,
                ),
              ),
              frequency: profile.smokingFrequency,
              onFrequencyChanged: (value) =>
                  _updateProfile(profile.copyWith(smokingFrequency: value)),
            ),
            const SizedBox(height: 24),
            _buildSubstanceSection(
              title: 'Alkohol',
              value: profile.drinkingAlcohol,
              onChanged: (value) => _updateProfile(
                profile.copyWith(
                  drinkingAlcohol: value,
                  alcoholFrequency: !value ? '' : profile.alcoholFrequency,
                ),
              ),
              frequency: profile.alcoholFrequency,
              onFrequencyChanged: (value) =>
                  _updateProfile(profile.copyWith(alcoholFrequency: value)),
            ),
            const SizedBox(height: 24),
            _buildSubstanceSectionWithName(
              title: 'Inne używki',
              value: profile.otherSubstances,
              onChanged: (value) => _updateProfile(
                profile.copyWith(
                  otherSubstances: value,
                  otherSubstancesName: !value
                      ? ''
                      : profile.otherSubstancesName,
                  otherSubstancesFrequency: !value
                      ? ''
                      : profile.otherSubstancesFrequency,
                ),
              ),
              substanceName: profile.otherSubstancesName,
              onNameChanged: (value) =>
                  _updateProfile(profile.copyWith(otherSubstancesName: value)),
              frequency: profile.otherSubstancesFrequency,
              onFrequencyChanged: (value) => _updateProfile(
                profile.copyWith(otherSubstancesFrequency: value),
              ),
            ),
          ],
        );
      case 5:
        // Allergies
        return _buildDynamicListSpec(
          title: 'Alergie',
          items: profile.allergies,
          onChanged: (items) =>
              _updateProfile(profile.copyWith(allergies: items)),
          addItemLabel: 'Dodaj alergię',
          hintText: 'Wpisz alergię',
        );
      case 6:
        // Medications - using MedicationAutocomplete
        // Need to adapt MedicationAutocomplete to be used in list or change design?
        // Original code used dynamic list of MedicationAutocomplete widgets
        return Column(
          children: [
            ...profile.medications.asMap().entries.map((entry) {
              final index = entry.key;
              final medication = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: MedicationAutocomplete(
                        initialValue: medication,
                        onChanged: (value) {
                          final newItems = List<String>.from(
                            profile.medications,
                          );
                          newItems[index] = value;
                          _updateProfile(
                            profile.copyWith(medications: newItems),
                          );
                        },
                        label: 'Lek ${index + 1}',
                        hint: 'Wpisz nazwę leku',
                      ),
                    ),
                    if (profile.medications.length > 1) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          final newItems = List<String>.from(
                            profile.medications,
                          );
                          newItems.removeAt(index);
                          _updateProfile(
                            profile.copyWith(medications: newItems),
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
            }),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                final newItems = List<String>.from(profile.medications);
                newItems.add('');
                _updateProfile(profile.copyWith(medications: newItems));
              },
              icon: const Icon(Icons.add),
              label: Text(
                profile.medications.isEmpty ? 'Dodaj lek' : 'Dodaj kolejny lek',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size(343, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
            ),
            if (profile.medications.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Możesz pominąć ten krok jeśli nie przyjmujesz leków na stałe',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
          ],
        );
      case 7:
        return IconOptionGrid(
          options: [
            IconOption(value: 'male', label: 'Mężczyzna', icon: Icons.male),
            IconOption(value: 'female', label: 'Kobieta', icon: Icons.female),
          ],
          value: profile.biologicalSex,
          onChange: (value) =>
              _updateProfile(profile.copyWith(biologicalSex: value)),
        );
      case 8:
        final options = [
          IconOption(value: 'male', label: 'Mężczyzna', icon: Icons.male),
          IconOption(value: 'female', label: 'Kobieta', icon: Icons.female),
          IconOption(
            value: 'non_binary',
            label: 'Niebinarna',
            icon: Icons.transgender,
          ),
          IconOption(value: 'other', label: 'Inna', icon: Icons.person_outline),
          IconOption(
            value: 'prefer_not_to_say',
            label: 'Wolę nie mówić',
            icon: Icons.block,
          ),
        ];
        return Column(
          children: [
            IconOptionGrid(
              options: options,
              value: profile.genderIdentity,
              onChange: (value) =>
                  _updateProfile(profile.copyWith(genderIdentity: value)),
            ),
            if (profile.genderIdentity == 'other') ...[
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Inna tożsamość',
                hint: 'Wpisz tożsamość',
                value: profile.genderIdentityOther,
                onChanged: (value) => _updateProfile(
                  profile.copyWith(genderIdentityOther: value),
                ),
              ),
            ],
          ],
        );
      case 9:
        // Education
        final eduOptions = [
          IconOption(
            value: 'primary',
            label: 'Podstawowe',
            icon: Icons.school_outlined,
          ),
          IconOption(
            value: 'vocational',
            label: 'Zawodowe',
            icon: Icons.build_outlined,
          ),
          IconOption(
            value: 'secondary',
            label: 'Średnie',
            icon: Icons.menu_book,
          ),
          IconOption(value: 'higher', label: 'Wyższe', icon: Icons.school),
          IconOption(value: 'other', label: 'Inne', icon: Icons.more_horiz),
        ];

        return Column(
          children: [
            IconOptionGrid(
              options: eduOptions,
              value: profile.education,
              onChange: (value) =>
                  _updateProfile(profile.copyWith(education: value)),
            ),
            if (profile.education == 'other') ...[
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Inne wykształcenie',
                hint: 'Wpisz wykształcenie',
                value: profile.educationOther,
                onChanged: (value) =>
                    _updateProfile(profile.copyWith(educationOther: value)),
              ),
            ],
          ],
        );
      case 10:
        return IconOptionGrid(
          options: [
            IconOption(
              value: 'none',
              label: 'Brak',
              icon: Icons.accessibility_new,
            ),
            IconOption(value: 'mild', label: 'Lekka', icon: Icons.accessible),
            IconOption(
              value: 'moderate',
              label: 'Umiarkowana',
              icon: Icons.accessible_forward,
            ),
            IconOption(
              value: 'severe',
              label: 'Znaczna',
              icon: Icons.wheelchair_pickup,
            ),
          ],
          value: profile.disability,
          onChange: (value) =>
              _updateProfile(profile.copyWith(disability: value)),
        );
      default:
        return Container();
    }
  }

  void _updateProfile(UserProfileEntity newProfile) {
    ref.read(profileProvider.notifier).updateProfile(newProfile);
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required String value,
    required Function(String) onChanged,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 343),
      child: TextField(
        controller: TextEditingController(text: value)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: value.length),
          ),
        onChanged: onChanged,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          labelStyle: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubstanceSection({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required String frequency,
    required Function(String) onFrequencyChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Switch(
              value: value,
              onChanged: onChanged,
              thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.secondary;
                }
                return null;
              }),
            ),
          ],
        ),
        if (value) ...[
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Częstotliwość',
            hint: 'Np. codziennie, okazjonalnie',
            value: frequency,
            onChanged: onFrequencyChanged,
          ),
        ],
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Switch(
              value: value,
              onChanged: onChanged,
              thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.secondary;
                }
                return null;
              }),
            ),
          ],
        ),
        if (value) ...[
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Nazwa używki',
            hint: 'Np. marihuana',
            value: substanceName,
            onChanged: onNameChanged,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Częstotliwość',
            hint: 'Np. codziennie, okazjonalnie',
            value: frequency,
            onChanged: onFrequencyChanged,
          ),
        ],
      ],
    );
  }

  Widget _buildDynamicListSpec({
    required String title,
    required List<String> items,
    required Function(List<String>) onChanged,
    required String addItemLabel,
    required String hintText,
  }) {
    return Column(
      children: [
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: '$title ${index + 1}',
                    hint: hintText,
                    value: item,
                    onChanged: (value) {
                      final newItems = List<String>.from(items);
                      newItems[index] = value;
                      onChanged(newItems);
                    },
                  ),
                ),
                if (items.length > 1) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      final newItems = List<String>.from(items);
                      newItems.removeAt(index);
                      onChanged(newItems);
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
        }),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            final newItems = List<String>.from(items);
            newItems.add('');
            onChanged(newItems);
          },
          icon: const Icon(Icons.add),
          label: Text(
            items.isEmpty ? addItemLabel : 'Dodaj kolejną',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.primary,
            minimumSize: const Size(343, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
          ),
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Możesz pominąć ten krok jeśli nie dotyczy',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
          ),
      ],
    );
  }
}
