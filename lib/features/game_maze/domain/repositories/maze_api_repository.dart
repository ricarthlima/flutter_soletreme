import '../entities/maze_entity.dart';

abstract interface class MazeApiRepository {
  Future<MazeEntity> fetchTodayMaze();
}
