import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class UserProfileScreen extends StatefulWidget {
  final VoidCallback onBack;

  const UserProfileScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic> _profileData = {};
  bool _isLoading = true;
  bool _showWeightReminder = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('user-profile');
    
    if (stored != null) {
      final data = jsonDecode(stored);
      setState(() {
        _profileData = data;
        _isLoading = false;
      });

      if (data['lastWeightUpdate'] != null) {
        final lastUpdate = DateTime.parse(data['lastWeightUpdate']);
        final daysSinceUpdate = DateTime.now().difference(lastUpdate).inDays;
        if (daysSinceUpdate >= 180) {
          setState(() => _showWeightReminder = true);
        }
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  int _calculateAge(String? birthYear) {
    if (birthYear == null || birthYear.isEmpty) return 0;
    return DateTime.now().year - int.parse(birthYear);
  }

  double _calculateBMI(String? height, String? weight) {
    if (height == null || weight == null || height.isEmpty || weight.isEmpty) {
      return 0;
    }
    final heightInMeters = int.parse(height) / 100;
    final weightInKg = int.parse(weight);
    return weightInKg / (heightInMeters * heightInMeters);
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Niedowaga';
    if (bmi < 25) return 'Prawidłowa';
    if (bmi < 30) return 'Nadwaga';
    return 'Otyłość';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return AppTheme.accentColor;
    if (bmi < 25) return const Color(0xFF4CAF50); // zielony dla prawidłowej wagi
    if (bmi < 30) return const Color(0xFFFFA726); // pomarańczowy
    return const Color(0xFFEF5350); // czerwony
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/braves_logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 32),
              CircularProgressIndicator(
                color: AppTheme.accentColor,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      );
    }

    final age = _calculateAge(_profileData['birthYear']);
    final bmi = _calculateBMI(_profileData['height'], _profileData['weight']);

    return Scaffold(
      backgroundColor: AppTheme.lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: AppTheme.primaryColor, size: 28),
          onPressed: widget.onBack,
        ),
        title: Text(
          'Twój profil',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_showWeightReminder) _buildWeightReminder(),
            _buildBasicInfo(age, bmi),
            const SizedBox(height: 16),
            _buildHealthInfo(),
            const SizedBox(height: 16),
            _buildPersonalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightReminder() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA726).withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFA726), width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFFFA726), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Minęło już 6 miesięcy od ostatniej aktualizacji wagi. Zaktualizuj swoje dane!',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(int age, double bmi) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.lightBackgroundColor,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            '$age lat',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                Icons.height,
                '${_profileData['height'] ?? '--'} cm',
                'Wzrost',
              ),
              _buildStatItem(
                Icons.monitor_weight,
                '${_profileData['weight'] ?? '--'} kg',
                'Waga',
              ),
            ],
          ),
          if (bmi > 0) ...[
            const SizedBox(height: 24),
            _buildBMIIndicator(bmi),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: AppTheme.accentColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildBMIIndicator(double bmi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBMIColor(bmi).withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _getBMIColor(bmi), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BMI',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              Text(
                bmi.toStringAsFixed(1),
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: _getBMIColor(bmi),
                ),
              ),
            ],
          ),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _getBMIColor(bmi),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                _getBMICategory(bmi),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthInfo() {
    String smokingInfo = 'Nie';
    if (_profileData['smokingCigarettes'] == true) {
      smokingInfo = 'Tak';
      if (_profileData['smokingFrequency']?.isNotEmpty ?? false) {
        smokingInfo += ' (${_profileData['smokingFrequency']})';
      }
    }

    String alcoholInfo = 'Nie';
    if (_profileData['drinkingAlcohol'] == true) {
      alcoholInfo = 'Tak';
      if (_profileData['alcoholFrequency']?.isNotEmpty ?? false) {
        alcoholInfo += ' (${_profileData['alcoholFrequency']})';
      }
    }

    String otherSubstancesInfo = 'Nie';
    if (_profileData['otherSubstances'] == true) {
      otherSubstancesInfo = 'Tak';
      if (_profileData['otherSubstancesName']?.isNotEmpty ?? false) {
        otherSubstancesInfo += ' - ${_profileData['otherSubstancesName']}';
        if (_profileData['otherSubstancesFrequency']?.isNotEmpty ?? false) {
          otherSubstancesInfo += ' (${_profileData['otherSubstancesFrequency']})';
        }
      }
    }

    String allergiesInfo = 'Brak';
    if (_profileData['allergies'] != null && (_profileData['allergies'] as List).isNotEmpty) {
      final allergiesList = (_profileData['allergies'] as List)
          .where((a) => a?.toString().isNotEmpty ?? false)
          .toList();
      if (allergiesList.isNotEmpty) {
        allergiesInfo = allergiesList.join(', ');
      }
    }

    String medicationsInfo = 'Brak';
    if (_profileData['medications'] != null && (_profileData['medications'] as List).isNotEmpty) {
      final medicationsList = (_profileData['medications'] as List)
          .where((m) => m?.toString().isNotEmpty ?? false)
          .toList();
      if (medicationsList.isNotEmpty) {
        medicationsInfo = medicationsList.join(', ');
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.lightBackgroundColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informacje zdrowotne',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          if (_profileData['currentIllness']?.isNotEmpty ?? false) ...[
            _buildInfoRow(
              'Choroba obecna',
              _profileData['currentIllness'],
            ),
            const SizedBox(height: 12),
          ],
          
          if (_profileData['chronicDiseases']?.isNotEmpty ?? false) ...[
            _buildInfoRow(
              'Choroby przewlekłe',
              _profileData['chronicDiseases'],
            ),
            const SizedBox(height: 12),
          ],
          
          _buildInfoRow('Papierosy', smokingInfo),
          const SizedBox(height: 12),
          
          _buildInfoRow('Alkohol', alcoholInfo),
          const SizedBox(height: 12),
          
          _buildInfoRow('Inne używki', otherSubstancesInfo),
          
          const SizedBox(height: 12),
          _buildInfoRow('Alergie', allergiesInfo),
          
          const SizedBox(height: 12),
          _buildInfoRow('Leki na stałe', medicationsInfo),
          
          if ((_profileData['currentIllness']?.isEmpty ?? true) &&
              (_profileData['chronicDiseases']?.isEmpty ?? true) &&
              !(_profileData['smokingCigarettes'] ?? false) &&
              !(_profileData['drinkingAlcohol'] ?? false) &&
              !(_profileData['otherSubstances'] ?? false) &&
              (_profileData['allergies']?.isEmpty ?? true) &&
              (_profileData['medications']?.isEmpty ?? true)) ...[
            const SizedBox(height: 8),
            Text(
              'Brak danych zdrowotnych z onboardingu',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppTheme.primaryColor.withOpacity(0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    final sexLabels = {
      'female': 'Kobieta',
      'male': 'Mężczyzna',
      'prefer-not-to-say': 'Wolę nie mówić',
    };

    final educationLabels = {
      'podstawowe': 'Podstawowe',
      'zawodowe': 'Zawodowe',
      'srednie': 'Średnie',
      'wyzsze-licencjat': 'Licencjat',
      'wyzsze-magister': 'Magister',
      'wyzsze-doktor': 'Doktor',
    };

    final disabilityLabels = {
      'none': 'Brak',
      'lekki': 'Lekki',
      'umiarkowany': 'Umiarkowany',
      'znaczny': 'Znaczny',
      'prefer-not-to-say': 'Wolę nie mówić',
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.lightBackgroundColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informacje osobiste',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Płeć biologiczna',
            sexLabels[_profileData['biologicalSex']] ?? 'Nie podano',
          ),
          _buildInfoRow(
            'Tożsamość płciowa',
            sexLabels[_profileData['genderIdentity']] ?? 
                _profileData['genderIdentityOther'] ?? 
                'Nie podano',
          ),
          _buildInfoRow(
            'Wykształcenie',
            educationLabels[_profileData['education']] ?? 
                _profileData['educationOther'] ?? 
                'Nie podano',
          ),
          _buildInfoRow(
            'Niepełnosprawność',
            disabilityLabels[_profileData['disability']] ?? 'Nie podano',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryColor.withOpacity(0.6),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 12),
          Divider(color: AppTheme.lightBackgroundColor, thickness: 2),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

