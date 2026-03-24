import 'package:freezed_annotation/freezed_annotation.dart';

import 'maze_entity.dart';

part 'game_entity.freezed.dart';
part 'game_entity.g.dart';

@freezed
abstract class GameEntity with _$GameEntity {
  factory GameEntity({
    required String id,
    required MazeEntity maze,
    required List<String> listWordsFound,
  }) = _GameEntity;

  factory GameEntity.fromJson(Map<String, dynamic> json) =>
      _$GameEntityFromJson(json);
}
