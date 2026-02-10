import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/health/data/models/health_data_model.dart';

abstract class HealthLocalDataSource {
  Future<void> cacheHealthData(HealthDataModel healthData);
  Future<List<HealthDataModel>> getCachedHealthHistory();
}

const CACHED_HEALTH_HISTORY = 'health-history';

class HealthLocalDataSourceImpl implements HealthLocalDataSource {
  final SharedPreferences sharedPreferences;

  HealthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheHealthData(HealthDataModel healthData) async {
    final history = await getCachedHealthHistory();
    history.add(healthData);
    
    // Convert to JSON list
    final jsonList = history.map((e) => json.encode(e.toJson())).toList();
    
    await sharedPreferences.setStringList(CACHED_HEALTH_HISTORY, jsonList);
  }

  @override
  Future<List<HealthDataModel>> getCachedHealthHistory() {
    final jsonStringList = sharedPreferences.getStringList(CACHED_HEALTH_HISTORY);
    if (jsonStringList != null) {
      return Future.value(jsonStringList
          .map((str) => HealthDataModel.fromJson(json.decode(str)))
          .toList());
    } else {
      return Future.value([]);
    }
  }
}
