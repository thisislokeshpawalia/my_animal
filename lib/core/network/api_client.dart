import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://myanimal-production.up.railway.app/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Dio get instance => _dio;
}