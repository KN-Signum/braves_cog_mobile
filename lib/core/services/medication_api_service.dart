import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

/// Struktura opisująca lek i dostępne dawki (moce preparatu).
class MedicationEntry {
  final String name;
  final List<String> strengths;

  const MedicationEntry({
    required this.name,
    required this.strengths,
  });
}

class MedicationApiService {
  static const String _assetPath = 'lib/features/health/drugs.json';

  static List<MedicationEntry>? _cachedEntries;

  /// Zwraca listę unikalnych nazw leków (Nazwy powszechnie stosowane – kolumna C).
  Future<List<String>> getMedications() async {
    final entries = await _loadEntries();
    final names = entries.map((e) => e.name).toSet().toList()..sort();
    return names;
  }

  /// Zwraca listę dawek (mocy preparatu – kolumna H) dla podanej nazwy leku.
  Future<List<String>> getStrengthsFor(String name) async {
    final entries = await _loadEntries();
    final normalizedName = name.trim().toLowerCase();

    final strengths = <String>{};
    for (final entry in entries) {
      if (entry.name.toLowerCase() == normalizedName) {
        strengths.addAll(entry.strengths);
      }
    }

    final list = strengths.toList()..sort();
    return list;
  }

  Future<List<MedicationEntry>> _loadEntries() async {
    if (_cachedEntries != null) {
      return _cachedEntries!;
    }

    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final Map<String, dynamic> data = json.decode(jsonString);

      final entries = <MedicationEntry>[];
      data.forEach((key, value) {
        final name = key.toString().trim();
        if (name.isEmpty) return;
        final strengthsList = (value as List)
            .map((v) => v.toString().trim())
            .where((s) => s.isNotEmpty)
            .toList();
        if (strengthsList.isEmpty) return;
        strengthsList.sort();
        entries.add(
          MedicationEntry(
            name: name,
            strengths: strengthsList,
          ),
        );
      });

      entries.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      _cachedEntries = entries;
      return _cachedEntries!;
    } catch (e) {
      debugPrint('MedicationApiService: błąd podczas odczytu JSON: $e');
      _cachedEntries = const [];
      return _cachedEntries!;
    }
  }
}
