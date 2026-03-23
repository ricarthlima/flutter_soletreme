import 'dart:convert';

import 'package:secure_shared_preferences/secure_shared_pref.dart';

import '../../../domain/entities/player_prefs_entity.dart';
import '../../../domain/repositories/player_prefs_repository.dart';

class SspPlayerPrefsService implements PlayerPrefsRepository {
  SecureSharedPref ssp;
  SspPlayerPrefsService({required this.ssp});

  final String _sspKey = "PLAYER_PREFS";

  @override
  Future<PlayerPrefsEntity> load() async {
    final String? jsonString = await ssp.getString(_sspKey, isEncrypted: true);

    if (jsonString != null) {
      return PlayerPrefsEntity.fromJson(json.decode(jsonString));
    }

    return PlayerPrefsEntity();
  }

  @override
  Future<void> save(PlayerPrefsEntity playerPrefs) async {
    return ssp.putString(_sspKey, json.encode(playerPrefs));
  }
}
