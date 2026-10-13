import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'username': username, 'password': password, 'expiresInMins': 30},
    );

    final data = response.data;

    if (data == null || data['accessToken'] == null) {
      throw const FormatException(
        'The server returned an invalid login response.',
      );
    }

    return data;
  }
}
