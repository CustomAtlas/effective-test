import 'package:dio/dio.dart';
import 'package:effective_test/core/data/character_model.dart';

class ApiClient {
  final dio = Dio();
  static const charactersUrl = 'https://rickandmortyapi.com/api/character';
  static ApiClient? _instance;

  factory ApiClient() {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  ApiClient._internal();

  Future<List<Character>?> getCharacters(int page) async {
    try {
      if (!await _hasInternetAccess()) return null;
      final response = await dio.get(charactersUrl, queryParameters: {'page': page});
      return ((response.data as Map<String, dynamic>)['results'] as List).map((e) => Character.fromMap(e)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final response = await dio.get(
        'https://www.google.com',
        options: Options(
          receiveTimeout: const Duration(seconds: 4),
          sendTimeout: const Duration(seconds: 4),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
