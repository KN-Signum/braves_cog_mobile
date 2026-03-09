abstract class CognitiveRemoteDataSource {
  Future<void> saveTestResult(Map<String, dynamic> payload);
}

class CognitiveApiDataSource implements CognitiveRemoteDataSource {
  // final ApiClient _apiClient;
  // CognitiveApiDataSource(this._apiClient);

  @override
  Future<void> saveTestResult(Map<String, dynamic> payload) async {
    // await _apiClient.post('/cognitive-results', body: payload);
  }
}
