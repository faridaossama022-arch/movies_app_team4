import 'package:injectable/injectable.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';
import 'package:movie_app/data/remote/movies_api_client.dart';
import 'package:movie_app/data/repository/movies_repository.dart';

@LazySingleton(as: MoviesRepository)
class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesApiClient _apiClient;

  MoviesRepositoryImpl(this._apiClient);

  @override
  Future<MoviePage> getMovies({
    required int page,
    required int limit,
    String? genre,
    String? query,
  }) {
    return _apiClient.getMovies(
      page: page,
      limit: limit,
      genre: genre,
      query: query,
    );
  }

  @override
  Future<YtsMovieModel> getMovieDetails(int movieId) {
    return _apiClient.getMovieDetails(movieId);
  }

  @override
  Future<List<YtsMovieModel>> getMovieSuggestions(int movieId) {
    return _apiClient.getMovieSuggestions(movieId);
  }
}
