import 'package:braves_cog/features/cognitive_games/data/datasources/cognitive_game_remote_data_source.dart';

class CognitiveMockDataSource implements CognitiveRemoteDataSource {
  @override
  Future<void> saveTestResult(Map<String, dynamic> payload) async {
    await Future.delayed(const Duration(seconds: 1));
    print('🛠️ [MOCK] Zapisano wynik gry: ${payload['testType']}');
  }
}
