import 'package:freezed_annotation/freezed_annotation.dart';

import 'game_entity.dart';

part 'player_prefs_entity.freezed.dart';
part 'player_prefs_entity.g.dart';

@freezed
abstract class PlayerPrefsEntity with _$PlayerPrefsEntity {
  factory PlayerPrefsEntity({
    @Default(null) int? lastMaze,
    @Default(false) bool isShowedFirstTimeMessage,
    @Default(true) bool isSoundActive,
    @Default([]) List<GameEntity> listGamesPlayed,
  }) = _PlayerPrefsEntity;

  factory PlayerPrefsEntity.fromJson(Map<String, dynamic> json) =>
      _$PlayerPrefsEntityFromJson(json);
}
