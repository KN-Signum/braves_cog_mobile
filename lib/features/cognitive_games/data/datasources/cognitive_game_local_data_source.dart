import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

abstract class CognitiveLocalDataSource {
  Future<void> cacheTestResult(Map<String, dynamic> payload);
}

class CognitiveLocalDataSourceImpl implements CognitiveLocalDataSource {
  @override
  Future<void> cacheTestResult(Map<String, dynamic> payload) async {
    try {
      debugPrint('💾 [CognitiveLocalDataSource] Zapisywanie wyniku gry...');
      
      // Pobierz katalog dokumentów aplikacji
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${directory.path}/cognitive_results');
      
      // Utwórz katalog jeśli nie istnieje
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
        debugPrint('📁 [CognitiveLocalDataSource] Utworzono katalog: ${cacheDir.path}');
      }
      
      // Utwórz nazwę pliku z timestamp'em i typem testu
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final testType = payload['testType'] ?? 'unknown';
      final filename = 'result_${testType}_$timestamp.txt';
      final file = File('${cacheDir.path}/$filename');
      
      // Sformatuj payload do czytelnego formatu
      final content = _formatPayload(payload);
      
      // Napisz do pliku
      await file.writeAsString(content);
      
      debugPrint('✅ [CognitiveLocalDataSource] Wynik zapisany: ${file.path}');
      debugPrint('📝 Rozmiar pliku: ${await file.length()} bajtów');
    } catch (e) {
      debugPrint('❌ [CognitiveLocalDataSource] Błąd zapisu: $e');
    }
  }
  
  /// Formatuj payload na czytelny string
  String _formatPayload(Map<String, dynamic> payload) {
    final buffer = StringBuffer();
    
    buffer.writeln('═' * 80);
    buffer.writeln('COGNITIVE TEST RESULT');
    buffer.writeln('═' * 80);
    buffer.writeln('Timestamp: ${DateTime.now()}');
    buffer.writeln('');
    buffer.writeln('TEST INFORMATION:');
    buffer.writeln('-' * 80);
    
    // Wyświetl podstawowe informacje
    payload.forEach((key, value) {
      if (key == 'rawData' || key == 'metrics') {
        // Pomiń zagnieżdżone dane na razie
        return;
      }
      buffer.writeln('$key: $value');
    });
    
    buffer.writeln('');
    buffer.writeln('METRICS:');
    buffer.writeln('-' * 80);
    if (payload.containsKey('metrics') && payload['metrics'] is Map) {
      final metrics = payload['metrics'] as Map<String, dynamic>;
      metrics.forEach((key, value) {
        buffer.writeln('$key: $value');
      });
    }
    
    buffer.writeln('');
    buffer.writeln('RAW DATA:');
    buffer.writeln('-' * 80);
    if (payload.containsKey('rawData') && payload['rawData'] is Map) {
      final rawData = payload['rawData'] as Map<String, dynamic>;
      _formatMap(rawData, buffer, indent: 0);
    }
    
    buffer.writeln('');
    buffer.writeln('═' * 80);
    buffer.writeln('END OF RESULT');
    buffer.writeln('═' * 80);
    
    return buffer.toString();
  }
  
  /// Rekurencyjnie formatuj zagnieżdżone mapy
  void _formatMap(Map<String, dynamic> map, StringBuffer buffer, {int indent = 0}) {
    final indentStr = '  ' * indent;
    
    map.forEach((key, value) {
      if (value is Map) {
        buffer.writeln('$indentStr$key:');
        _formatMap(value as Map<String, dynamic>, buffer, indent: indent + 1);
      } else if (value is List) {
        buffer.writeln('$indentStr$key: [');
        for (final item in value) {
          if (item is Map) {
            _formatMap(item as Map<String, dynamic>, buffer, indent: indent + 1);
          } else {
            buffer.writeln('$indentStr  $item');
          }
        }
        buffer.writeln('$indentStr]');
      } else {
        buffer.writeln('$indentStr$key: $value');
      }
    });
  }
}
