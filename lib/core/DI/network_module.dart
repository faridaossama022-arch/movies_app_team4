import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/app_constants.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.moviesApiBaseUrl,
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 18),
        sendTimeout: const Duration(seconds: 12),
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false),
      );
    }
    return dio;
  }
}
