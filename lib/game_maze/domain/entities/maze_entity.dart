import 'package:freezed_annotation/freezed_annotation.dart';

part 'maze_entity.freezed.dart';
part 'maze_entity.g.dart';

@freezed
abstract class MazeEntity with _$MazeEntity {
  factory MazeEntity({
    required String id,
    required String maze,
    required DateTime date,
  }) = _MazeEntity;

  factory MazeEntity.fromJson(Map<String, dynamic> json) =>
      _$MazeEntityFromJson(json);
}
