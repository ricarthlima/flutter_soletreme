import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/game_maze/data/services/dio/dio_maze_api_service.dart';
import '../features/game_maze/data/services/shared_preferences/shared_preferences_player_prefs_service.dart';
import '../features/game_maze/domain/repositories/maze_api_repository.dart';
import '../features/game_maze/domain/repositories/player_prefs_repository.dart';
import '../features/game_maze/presentation/stores/game_store.dart';
import '../shared/audio/domain/data/services/just_audio/just_audio_service.dart';
import '../shared/audio/domain/repositories/audio_repository.dart';

abstract class DI {
  static late GetIt instance;

  static Future<void> initialize() async {
    instance = GetIt.instance;
    await _register();
  }

  static Future<void> _register() async {
    await _registerCore();
    _registerGameMazeBindings();
  }

  static Future<void> _registerCore() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

    final audioService = JustAudioService();
    await audioService.init();
    instance.registerSingleton<AudioRepository>(audioService);

    instance.registerLazySingleton<Dio>(() => Dio());
  }

  static void _registerGameMazeBindings() {
    instance.registerLazySingleton<PlayerPrefsRepository>(
      () => SharedPreferencesPlayerPrefsService(
        sharedPreferences: instance<SharedPreferences>(),
      ),
    );

    instance.registerLazySingleton<MazeApiRepository>(
      () => DioMazeApiService(instance<Dio>()),
    );

    instance.registerLazySingleton<GameStore>(
      () => GameStore(
        prefsRepo: instance<PlayerPrefsRepository>(),
        audioRepo: instance<AudioRepository>(),
        mazeApiRepo: instance<MazeApiRepository>(),
      ),
    );
  }
}
