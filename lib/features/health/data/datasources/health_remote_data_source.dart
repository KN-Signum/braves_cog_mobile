import 'package:braves_cog/features/health/data/models/health_data_model.dart';
import 'package:braves_cog/features/health/domain/entities/health_data_entity.dart';

abstract class HealthRemoteDataSource {
  Future<void> saveHealthData(HealthDataModel healthData);
  Future<List<HealthDataModel>> getHealthHistory();
}
