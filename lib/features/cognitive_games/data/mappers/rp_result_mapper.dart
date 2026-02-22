import 'package:braves_cog/features/cognitive_games/domain/entities/cognitive_game_result.dart';
import 'package:braves_cog/features/cognitive_games/domain/entities/test_metrics.dart';
import 'package:research_package/research_package.dart';

class RPResultMapper {
  /// Główna funkcja tłumacząca wynik z biblioteki na nasz czysty model
  static CognitiveTestResult fromRPTaskResult({
    required RPTaskResult taskResult,
    required String userId,
    required CognitiveTestType testType,
    required String stepIdentifier,
  }) {
    // 1. Zamieniamy cały wynik na bezpieczny, pełny JSON.
    // Dzięki temu mamy pewność, że nie zgubimy 'interactions' ani 'stepTimes'.
    final Map<String, dynamic> fullTaskJson = taskResult.toJson();

    // 2. Wyciągamy surowe dane tylko dla konkretnego kroku
    final Map<String, dynamic>? resultsNode = fullTaskJson['results'];

    if (resultsNode == null || !resultsNode.containsKey(stepIdentifier)) {
      throw Exception('Nie znaleziono wyników dla kroku: $stepIdentifier');
    }

    final Map<String, dynamic> rawStepData =
        resultsNode[stepIdentifier] as Map<String, dynamic>;

    // 3. Obliczamy specyficzne metryki dla danego typu testu
    final metrics = _calculateMetrics(testType, rawStepData);

    // 4. Zwracamy czysty model
    return CognitiveTestResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      testType: testType,
      completedAt: taskResult.endDate ?? DateTime.now(),
      metrics: metrics,
      rawData: rawStepData, // Teraz to zawiera w 100% pełny log kroku!
    );
  }

  /// Prywatna funkcja do mapowania konkretnych JSONów z metrykami
  static TestMetrics _calculateMetrics(
    CognitiveTestType type,
    Map<String, dynamic> rawStepData,
  ) {
    // UWAGA: Ponieważ rawStepData to teraz pełny JSON kroku,
    // statystyki znajdują się w zagnieżdżeniu: ['results']['result']
    final stepResults = rawStepData['results'] as Map<String, dynamic>? ?? {};

    switch (type) {
      case CognitiveTestType.stroop:
        final resultSummary =
            stepResults['result'] as Map<String, dynamic>? ?? {};

        return StroopMetrics(
          correctTaps: resultSummary['correct taps'] as int? ?? 0,
          mistakes: resultSummary['mistakes'] as int? ?? 0,
          totalTrials:
              (resultSummary['correct taps'] as int? ?? 0) +
              (resultSummary['mistakes'] as int? ?? 0),
        );

      case CognitiveTestType.trailMaking:
        final resultSummary =
            stepResults['result'] as Map<String, dynamic>? ?? {};

        final int completionTime =
            resultSummary['Completion time'] as int? ?? 0;
        final int score = resultSummary['score'] as int? ?? 0;

        // interactions teraz na pewno istnieje w rawStepData!
        final List<dynamic> interactions =
            rawStepData['interactions'] as List<dynamic>? ?? [];
        final int mistakesCount = interactions
            .where(
              (interaction) => interaction['correctness'] == 'Wrong gesture',
            )
            .length;

        return TrailMakingMetrics(
          completionTimeSeconds: completionTime,
          score: score,
          mistakes: mistakesCount,
        );

      case CognitiveTestType.flanker:
        final resultSummary =
            stepResults['result'] as Map<String, dynamic>? ?? {};

        return FlankerMetrics(
          correctSwipes: resultSummary['right swipes'] as int? ?? 0,
          wrongSwipes: resultSummary['wrong swipes'] as int? ?? 0,
          totalTimeSeconds: resultSummary['time'] as int? ?? 0,
          score: resultSummary['score'] as int? ?? 0,
          meanCongruentTime:
              (resultSummary['meanCongruent'] as num?)?.toDouble() ?? 0.0,
          meanIncongruentTime:
              (resultSummary['meanIncongruent'] as num?)?.toDouble() ?? 0.0,
          congruentTrialsCount:
              resultSummary['numberCardsCongruent'] as int? ?? 0,
          incongruentTrialsCount:
              resultSummary['numberCardsIncongruent'] as int? ?? 0,
        );

      case CognitiveTestType.rvip:
        final resultSummary =
            stepResults['result'] as Map<String, dynamic>? ?? {};

        final rawDelays =
            resultSummary['Delay on correct taps'] as List<dynamic>? ?? [];
        final List<double> delays = rawDelays
            .map((e) => (e as num).toDouble())
            .toList();

        return RvipMetrics(
          correctTaps: resultSummary['Correct taps'] as int? ?? 0,
          incorrectTaps: resultSummary['incorrect taps'] as int? ?? 0,
          passedSequences: resultSummary['passed sequences'] as bool? ?? false,
          delaysOnCorrectTaps: delays,
        );

      case CognitiveTestType.tapping:
        final resultSummary =
            stepResults['result'] as Map<String, dynamic>? ?? {};

        return TappingMetrics(
          totalTaps: resultSummary['Total taps'] as int? ?? 0,
        );

      case CognitiveTestType.corsiBlock:
        // Corsi zwraca 'result' jako int, a nie Map!
        final resultSummary = stepResults['result'];

        int blockSpan = 0;
        if (resultSummary is int) {
          blockSpan = resultSummary;
        } else if (resultSummary is double) {
          blockSpan = resultSummary.toInt();
        }

        return CorsiBlockMetrics(maxSequenceLength: blockSpan);

      case CognitiveTestType.reactionTime:
        final resultSummary =
            stepResults['result'] as Map<String, dynamic>? ?? {};

        return ReactionTimeMetrics(
          averageReactionTimeMs:
              resultSummary['avg. reaction time'] as int? ?? 0,
          correctTaps: resultSummary['Correct taps'] as int? ?? 0,
          wrongTaps: resultSummary['Wrong taps'] as int? ?? 0,
        );
    }
  }

  /// Konwertuje TestMetrics na Map<String, dynamic> dla zapisu w bazie
  static Map<String, dynamic> metricsToJson(TestMetrics metrics) {
    return switch (metrics) {
      StroopMetrics m => {
        'type': 'stroop',
        'correctTaps': m.correctTaps,
        'mistakes': m.mistakes,
        'totalTrials': m.totalTrials,
      },
      TrailMakingMetrics m => {
        'type': 'trailMaking',
        'completionTimeSeconds': m.completionTimeSeconds,
        'score': m.score,
        'mistakes': m.mistakes, // Teraz błędy będą prawidłowo wyliczone
      },
      FlankerMetrics m => {
        'type': 'flanker',
        'correctSwipes': m.correctSwipes,
        'wrongSwipes': m.wrongSwipes,
        'totalTimeSeconds': m.totalTimeSeconds,
        'score': m.score,
        'meanCongruentTime': m.meanCongruentTime,
        'meanIncongruentTime': m.meanIncongruentTime,
        'congruentTrialsCount': m.congruentTrialsCount,
        'incongruentTrialsCount': m.incongruentTrialsCount,
      },
      RvipMetrics m => {
        'type': 'rvip',
        'correctTaps': m.correctTaps,
        'incorrectTaps': m.incorrectTaps,
        'passedSequences': m.passedSequences,
        'delaysOnCorrectTaps': m.delaysOnCorrectTaps,
      },
      TappingMetrics m => {'type': 'tapping', 'totalTaps': m.totalTaps},
      CorsiBlockMetrics m => {
        'type': 'corsiBlock',
        'maxSequenceLength': m.maxSequenceLength,
      },
      ReactionTimeMetrics m => {
        'type': 'reactionTime',
        'averageReactionTimeMs': m.averageReactionTimeMs,
        'correctTaps': m.correctTaps,
        'wrongTaps': m.wrongTaps,
      },
    };
  }
}
