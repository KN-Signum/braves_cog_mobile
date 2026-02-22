// plik: lib/features/cognitive_games/presentation/providers/cognitive_games_providers.dart
import 'package:braves_cog/features/cognitive_games/data/datasources/cognitice_game_mock_data_source.dart';
import 'package:braves_cog/features/cognitive_games/data/datasources/cognitive_game_local_data_source.dart';
import 'package:braves_cog/features/cognitive_games/data/datasources/cognitive_game_remote_data_source.dart';
import 'package:braves_cog/features/cognitive_games/data/repositories/cognitive_repository_impl.dart';
import 'package:braves_cog/features/cognitive_games/domain/repositories/cognitive_repository.dart';
import 'package:braves_cog/features/cognitive_games/domain/usecases/save_test_result_usecase.dart';
import 'package:braves_cog/features/cognitive_games/presentation/providers/cognitive_game_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Data Sources
final cognitiveLocalDataSourceProvider = Provider<CognitiveLocalDataSource>((
  ref,
) {
  // final prefs = ref.watch(sharedPreferencesProvider);
  return CognitiveLocalDataSourceImpl();
});

final cognitiveRemoteDataSourceProvider = Provider<CognitiveRemoteDataSource>((
  ref,
) {
  // Logic to switch between mock and real
  return CognitiveMockDataSource();
});

// 2. Repository
final cognitiveRepositoryProvider = Provider<CognitiveRepository>((ref) {
  final localinfo = ref.watch(cognitiveLocalDataSourceProvider);
  final remoteinfo = ref.watch(cognitiveRemoteDataSourceProvider);

  return CognitiveRepositoryImpl(
    localDataSource: localinfo,
    remoteDataSource: remoteinfo,
  );
});

// 3. Use Cases
final saveTestResultUseCaseProvider = Provider<SaveTestResultUseCase>((ref) {
  return SaveTestResultUseCase(ref.watch(cognitiveRepositoryProvider));
});

// 4. State Notifier Provider
final cognitiveGamesProvider =
    StateNotifierProvider<CognitiveGamesNotifier, CognitiveGamesState>((ref) {
      final saveUseCase = ref.watch(saveTestResultUseCaseProvider);
      return CognitiveGamesNotifier(saveUseCase);
    });
