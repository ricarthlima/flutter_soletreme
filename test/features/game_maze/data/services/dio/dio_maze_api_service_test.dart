import 'package:dio/dio.dart';
import 'package:flutter_soletreme/features/game_maze/data/services/dio/dio_maze_api_service.dart';
import 'package:flutter_soletreme/features/game_maze/domain/entities/maze_entity.dart';
import 'package:flutter_soletreme/shared/helpers/get_today_maze_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../mocks.mocks.dart';

void main() {
  late MockDio mockDio;
  late DioMazeApiService service;

  setUp(() {
    mockDio = MockDio();
    service = DioMazeApiService(mockDio);
  });

  group('DioMazeApiService', () {
    test(
      'Deve retornar um MazeEntity quando a chamada da API for um sucesso',
      () async {
        final Map<String, dynamic> fakeJsonResponse = {
          "id": getTodayMazeId(),
          "maze": "inuptafimmaetrotoieeiorpfgcreerounasimtc",
          "tips": ["tremeis"],
        };

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: fakeJsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ),
        );

        final result = await service.fetchTodayMaze();

        expect(result, isA<MazeEntity>());
        verify(mockDio.get(any)).called(1);
      },
    );

    test('Deve lançar uma Exception quando o Dio falhar', () async {
      when(mockDio.get(any)).thenThrow(
        DioException(requestOptions: RequestOptions(), error: 'Not Found'),
      );
      expect(() => service.fetchTodayMaze(), throwsA(isA<Exception>()));
    });
  });
}
