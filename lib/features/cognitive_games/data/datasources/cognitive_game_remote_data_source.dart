import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CognitiveRemoteDataSource {
  Future<void> saveTestResult(Map<String, dynamic> payload);
}

class CognitiveSupabaseDataSource implements CognitiveRemoteDataSource {
  final SupabaseClient supabaseClient;

  CognitiveSupabaseDataSource({required this.supabaseClient});

  @override
  Future<void> saveTestResult(Map<String, dynamic> payload) async {
    await supabaseClient.from('cognitive_test_results').insert({
      'user_id': payload['userId'],
      'test_type': payload['testType'],
      'completed_at': payload['completedAt'],
      'metrics': payload['metrics'],
      'raw_data': payload['rawData'],
    });
  }
}
