import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MedicationApiService {
  static const String _cacheKey = 'medications_cache';
  static const String _cacheTimestampKey = 'medications_cache_timestamp';
  static const int _cacheDurationDays = 7;

  Future<List<String>> getMedications() async {
    try {
      final cachedMedications = await _getCachedMedications();
      if (cachedMedications != null && cachedMedications.isNotEmpty) {
        return cachedMedications;
      }

      final apiMedications = await _fetchFromApi();
      if (apiMedications.isNotEmpty) {
        await _cacheMedications(apiMedications);
        return apiMedications;
      }

      return _getStaticMedications();
    } catch (e) {
      print('Error fetching medications: $e');
      final cachedMedications = await _getCachedMedicationsIgnoreExpiry();
      if (cachedMedications != null && cachedMedications.isNotEmpty) {
        return cachedMedications;
      }
      return _getStaticMedications();
    }
  }

  Future<List<String>> _fetchFromApi() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.example.com/medications'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        if (data is List) {
          final medications = <String>{};
          for (var item in data) {
            if (item is Map && item.containsKey('name')) {
              medications.add(item['name'].toString().trim());
            }
          }
          return medications.toList()..sort();
        }
      }

      return [];
    } catch (e) {
      print('API fetch error: $e');
      return [];
    }
  }

  Future<List<String>?> _getCachedMedications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_cacheTimestampKey);
      
      if (timestamp != null) {
        final cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        final difference = now.difference(cacheDate).inDays;
        
        if (difference < _cacheDurationDays) {
          final cached = prefs.getStringList(_cacheKey);
          if (cached != null && cached.isNotEmpty) {
            return cached;
          }
        }
      }
      
      return null;
    } catch (e) {
      print('Cache read error: $e');
      return null;
    }
  }

  Future<List<String>?> _getCachedMedicationsIgnoreExpiry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_cacheKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> _cacheMedications(List<String> medications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_cacheKey, medications);
      await prefs.setInt(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Cache write error: $e');
    }
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheTimestampKey);
  }

  List<String> _getStaticMedications() {
    return [
      'Acard', 'Acenokumarol', 'Acetaminophen', 'Aescin',
      'Amoksycylina', 'Amotaks', 'Amoksiklav', 'Amlodipina',
      'Apap', 'Aspirin', 'Atoris', 'Atorwastatyna',
      'Betaloc', 'Betahistyna', 'Biofenac', 'Biosotal',
      'Bisocard', 'Bisoprolol', 'Bondronat',
      'Captopril', 'Carvedilol', 'Cefuroxim', 'Citalopram',
      'Claritine', 'Clopidogrel', 'Concor',
      'Dexamethason', 'Dexamethasone', 'Diclofenac',
      'Digoxin', 'Duspatalin',
      'Edarbi', 'Enalapril', 'Entresto', 'Espumisan', 'Euthyrox',
      'Flegamina', 'Fluconazole', 'Furosemid',
      'Gabapentin', 'Glucophage', 'Groprinosin',
      'Hydrochlorothiazid', 'Hydroxyzine',
      'Ibuprofen', 'Ibufen', 'Insulin', 'Irbesartan', 'Isoptin',
      'Ketonal',
      'Lacidofil', 'Lamotrigine', 'Lantus', 'Letrox',
      'Levothyroxine', 'Lipanthyl', 'Lisinopril', 'Losartan', 'Lozap',
      'Metformax', 'Metformin', 'Metformina', 'Metoprolol', 'Milurit',
      'Nalgesin', 'Nebilet', 'Nebivolol', 'Nolpaza', 'Noliprel',
      'Omeprazol', 'Omnic',
      'Panangin', 'Pantoprazol', 'Paracetamol', 'Perindopril',
      'Polopiryna', 'Polprazol', 'Prestarium', 'Propranolol',
      'Ramipril', 'Ranitidin', 'Roswera', 'Rosuvastatin',
      'Rosuvastatyna', 'Rutinoscorbin',
      'Salbutamol', 'Sertraline', 'Siofor', 'Simvastatin',
      'Simvastatyna', 'Spironolacton', 'Stadorm',
      'Tamsulosin', 'Telmisartan', 'Torasemid', 'Tolperison',
      'Tramadol', 'Tritace',
      'Valsartan', 'Ventolin', 'Vitamin D', 'Vitamin B12', 'Vitamin C',
      'Warfarin',
      'Xarelto',
      'Zoloft',
    ];
  }
}
