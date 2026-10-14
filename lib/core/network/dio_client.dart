import 'package:dio/dio.dart';
import 'package:food_delivery_app/core/constants/api_end_points.dart';

import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

class DioClient {
  DioClient({required TokenStorage tokenStorage}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(AuthInterceptor(tokenStorage));
  }

  late final Dio dio;
}
