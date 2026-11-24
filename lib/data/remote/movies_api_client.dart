import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/app_constants.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';

@lazySingleton
class MoviesApiClient {
  final Dio _dio;
  int _mirrorIndex = 0; // آخر دومين اشتغل

  MoviesApiClient(this._dio);

  Future<MoviePage> getMovies({
    required int page,
    required int limit,
    String? genre,
    String? query,
  }) async {
    final queryParameters = <String, dynamic>{'page': page, 'limit': limit};
    if (query != null && query.trim().isNotEmpty) {
      queryParameters['query_term'] = query.trim();
    }
    if (genre != null && genre.trim().isNotEmpty) {
      queryParameters['genre'] = genre;
    }

    final data = await _getData(
      'list_movies.json',
      queryParameters: queryParameters,
    );
    return MoviePage.fromJson(data);
  }

  Future<YtsMovieModel> getMovieDetails(int movieId) async {
    final data = await _getData(
      'movie_details.json',
      queryParameters: {
        'movie_id': movieId,
        'with_images': true,
        'with_cast': true,
      },
    );
    final movie = _asJsonMap(data['movie']);
    if (movie == null) {
      throw const MovieDataException(StringsManager.movieNotFound);
    }
    return YtsMovieModel.fromJson(movie);
  }

  Future<List<YtsMovieModel>> getMovieSuggestions(int movieId) async {
    final data = await _getData(
      'movie_suggestions.json',
      queryParameters: {'movie_id': movieId},
    );
    final rawMovies = data['movies'];
    if (rawMovies is! List) return const [];

    return rawMovies
        .map(_asJsonMap)
        .whereType<Map<String, dynamic>>()
        .map(YtsMovieModel.fromJson)
        .toList(growable: false);
  }

  Future<Map<String, dynamic>> _getData(
    String path, {
    required Map<String, dynamic> queryParameters,
  }) async {
    final mirrors = AppConstants.moviesApiMirrors;
    DioException? lastError;

    // نجرب كل الدومينات بالترتيب، بادئين بآخر واحد اشتغل.
    for (var attempt = 0; attempt < mirrors.length; attempt++) {
      final index = (_mirrorIndex + attempt) % mirrors.length;
      try {
        final response = await _dio.get<dynamic>(
          '${mirrors[index]}$path',
          queryParameters: queryParameters,
        );
        final data = _parseBody(response.data);
        _mirrorIndex = index;
        return data;
      } on MovieDataException {
        rethrow;
      } on DioException catch (error) {
        debugPrint('API ERROR (${mirrors[index]}): ${error.type} ${error.error}');
        lastError = error;
        // نكمل للدومين اللي بعده بس لو المشكلة اتصال/timeout/سيرفر واقع.
        if (!_shouldTryNextMirror(error)) break;
      } catch (error) {
        debugPrint('API ERROR: $error');
        throw const MovieDataException(StringsManager.moviesServiceError);
      }
    }

    throw _mapDioException(lastError!);
  }

  bool _shouldTryNextMirror(DioException error) {
    final code = error.response?.statusCode;
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.unknown ||
        error.type == DioExceptionType.badCertificate ||
        (code != null && code >= 500);
  }

  Map<String, dynamic> _parseBody(dynamic raw) {
    final body = _asJsonMap(raw);
    if (body == null) {
      throw const MovieDataException(StringsManager.moviesServiceError);
    }
    if (body['status'] != 'ok') {
      final message = body['status_message'];
      throw MovieDataException(
        message is String && message.trim().isNotEmpty
            ? message
            : StringsManager.moviesServiceError,
      );
    }
    final data = _asJsonMap(body['data']);
    if (data == null) {
      throw const MovieDataException(StringsManager.moviesServiceError);
    }
    return data;
  }

  MovieDataException _mapDioException(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const MovieDataException(StringsManager.requestTimedOut);
    }

    final statusCode = error.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      return const MovieDataException(StringsManager.moviesServerError);
    }

    final message = error.message?.toLowerCase() ?? '';
    if (error.type == DioExceptionType.connectionError ||
        message.contains('socketexception') ||
        message.contains('failed host lookup')) {
      return const MovieDataException(StringsManager.noInternetConnection);
    }

    return const MovieDataException(StringsManager.moviesServiceError);
  }
}

class MovieDataException implements Exception {
  final String message;

  const MovieDataException(this.message);

  @override
  String toString() => message;
}

Map<String, dynamic>? _asJsonMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}
