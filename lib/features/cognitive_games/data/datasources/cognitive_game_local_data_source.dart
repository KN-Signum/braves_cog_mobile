abstract class CognitiveLocalDataSource {
  Future<void> cacheTestResult(Map<String, dynamic> payload);
}

class CognitiveLocalDataSourceImpl implements CognitiveLocalDataSource {
  // Tutaj np. Hive, SharedPreferences lub Isar
  // final SharedPreferences prefs;
  // CognitiveLocalDataSourceImpl(this.prefs);

  @override
  Future<void> cacheTestResult(Map<String, dynamic> payload) async {
    print('🛠️ [MOCK] Zapisano wynik gry: ${payload['testType']}');
    print(payload);
  }
}
