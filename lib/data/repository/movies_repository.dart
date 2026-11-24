import 'package:movie_app/data/model/yts_movie_model.dart';

abstract class MoviesRepository {
  Future<MoviePage> getMovies({
    required int page,
    required int limit,
    String? genre,
    String? query,
  });

  Future<YtsMovieModel> getMovieDetails(int movieId);

  Future<List<YtsMovieModel>> getMovieSuggestions(int movieId);
}
