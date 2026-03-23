import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/player_prefs_entity.dart';
import '../../../domain/repositories/player_prefs_repository.dart';

class SharedPreferencesPlayerPrefsService implements PlayerPrefsRepository {
  SharedPreferences sharedPreferences;
  SharedPreferencesPlayerPrefsService({required this.sharedPreferences});

  final String _sspKey = "PLAYER_PREFS";

  @override
  Future<PlayerPrefsEntity> load() async {
    final String? jsonString = sharedPreferences.getString(_sspKey);

    if (jsonString != null) {
      return PlayerPrefsEntity.fromJson(json.decode(jsonString));
    }

    return PlayerPrefsEntity();
  }

  @override
  Future<void> save(PlayerPrefsEntity playerPrefs) async {
    await sharedPreferences.setString(_sspKey, json.encode(playerPrefs));
  }
}
