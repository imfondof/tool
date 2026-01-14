import 'package:dio/dio.dart';

import '../config/app_config.dart';

class DioClient {
  DioClient(this._config) {
    dio = Dio(
      BaseOptions(
        baseUrl: _config.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    if (_config.isDev) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }

  final AppConfig _config;
  late final Dio dio;
}
