sealed class TestMetrics {}

class StroopMetrics extends TestMetrics {
  final int correctTaps;
  final int mistakes;
  final int totalTrials;

  StroopMetrics({
    required this.correctTaps,
    required this.mistakes,
    required this.totalTrials,
  });
}

class TrailMakingMetrics extends TestMetrics {
  final int completionTimeSeconds;
  final int score;
  final int mistakes;

  TrailMakingMetrics({
    required this.completionTimeSeconds,
    required this.score,
    required this.mistakes,
  });
}

class FlankerMetrics extends TestMetrics {
  final int correctSwipes;
  final int wrongSwipes;
  final int totalTimeSeconds;
  final int score;
  final double meanCongruentTime;
  final double meanIncongruentTime;
  final int congruentTrialsCount;
  final int incongruentTrialsCount;

  FlankerMetrics({
    required this.correctSwipes,
    required this.wrongSwipes,
    required this.totalTimeSeconds,
    required this.score,
    required this.meanCongruentTime,
    required this.meanIncongruentTime,
    required this.congruentTrialsCount,
    required this.incongruentTrialsCount,
  });
}

class RvipMetrics extends TestMetrics {
  final int correctTaps;
  final int incorrectTaps;
  final bool passedSequences;
  final List<double> delaysOnCorrectTaps;

  RvipMetrics({
    required this.correctTaps,
    required this.incorrectTaps,
    required this.passedSequences,
    required this.delaysOnCorrectTaps,
  });
}

class TappingMetrics extends TestMetrics {
  final int totalTaps;

  TappingMetrics({required this.totalTaps});
}

class CorsiBlockMetrics extends TestMetrics {
  final int maxSequenceLength;

  CorsiBlockMetrics({required this.maxSequenceLength});
}

class ReactionTimeMetrics extends TestMetrics {
  final int averageReactionTimeMs;
  final int correctTaps;
  final int wrongTaps;

  ReactionTimeMetrics({
    required this.averageReactionTimeMs,
    required this.correctTaps,
    required this.wrongTaps,
  });
}
