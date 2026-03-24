import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../../../../../shared/helpers/get_today_maze_id.dart';
import '../../../domain/entities/maze_entity.dart';
import '../../../domain/repositories/maze_api_repository.dart';

class DioMazeApiService implements MazeApiRepository {
  final Dio _dio;

  final String _baseUrl = const String.fromEnvironment("API_BASE_URL");

  final String _secretSalt = const String.fromEnvironment("SECRET_SALT");

  DioMazeApiService(this._dio);

  @override
  Future<MazeEntity> fetchTodayMaze() async {
    final String mazeId = getTodayMazeId();

    final String textoBase = "${mazeId}_$_secretSalt";

    // Gera o Hash SHA-256
    final String hashCompleto = sha256
        .convert(utf8.encode(textoBase))
        .toString();

    // Pega os mesmos 16 primeiros caracteres
    final String nomeArquivo = "${hashCompleto.substring(0, 16)}.json";

    try {
      final response = await _dio.get("$_baseUrl/$nomeArquivo");
      return MazeEntity.fromJson(response.data);
    } catch (e) {
      throw Exception("Erro ao buscar o labirinto do dia: $e");
    }
  }
}
