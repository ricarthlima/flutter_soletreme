import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/game_maze/data/services/shared_preferences/shared_preferences_player_prefs_service.dart';
import '../features/game_maze/domain/repositories/player_prefs_repository.dart';
import '../features/game_maze/presentation/stores/game_store.dart';

abstract class DI {
  static late GetIt instance;

  static Future<void> initialize() async {
    instance = GetIt.instance;
    await _register();
  }

  static Future<void> _register() async {
    _registerCore();
    _registerGameMazeBindings();
  }

  static Future<void> _registerCore() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  }

  static void _registerGameMazeBindings() {
    instance.registerLazySingleton<PlayerPrefsRepository>(
      () => SharedPreferencesPlayerPrefsService(
        sharedPreferences: instance<SharedPreferences>(),
      ),
    );

    instance.registerLazySingleton<GameStore>(
      () => GameStore(prefsRepo: instance<PlayerPrefsRepository>()),
    );
  }
}
