import 'package:braves_cog/features/cognitive_games/domain/entities/test_metrics.dart';

enum CognitiveTestType {
  stroop,
  trailMaking,
  flanker,
  rvip,
  tapping,
  corsiBlock,
  reactionTime,
}

class CognitiveTestResult {
  final String id;
  final String userId;
  final CognitiveTestType testType;
  final DateTime completedAt;
  final TestMetrics metrics;
  final Map<String, dynamic> rawData;

  CognitiveTestResult({
    required this.id,
    required this.userId,
    required this.testType,
    required this.completedAt,
    required this.metrics,
    required this.rawData,
  });
}
