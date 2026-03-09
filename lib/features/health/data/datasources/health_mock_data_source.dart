import 'package:braves_cog/features/health/data/datasources/health_remote_data_source.dart';
import 'package:braves_cog/features/health/data/models/health_data_model.dart';

class HealthMockDataSource implements HealthRemoteDataSource {
  @override
  Future<void> saveHealthData(HealthDataModel healthData) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate success
  }

  @override
  Future<List<HealthDataModel>> getHealthHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return []; // Return empty list for now or sample data
  }
}
