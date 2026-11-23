import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';
import 'package:movie_app/data/remote/movies_api_client.dart';
import 'package:movie_app/data/repository/movies_repository.dart';
import 'package:movie_app/ui/movie_details/cubit/movie_details_states.dart';

@injectable
class MovieDetailsCubit extends Cubit<MovieDetailsStates> {
  final MoviesRepository _moviesRepository;
  int? _movieId;

  MovieDetailsCubit(this._moviesRepository) : super(MovieDetailsInitialState());

  Future<void> loadMovie(int movieId) async {
    _movieId = movieId;
    emit(MovieDetailsLoadingState());
    try {
      final results = await Future.wait<Object>([
        _moviesRepository.getMovieDetails(movieId),
        _moviesRepository.getMovieSuggestions(movieId),
      ]);
      emit(
        MovieDetailsSuccessState(
          movie: results[0] as YtsMovieModel,
          suggestions: results[1] as List<YtsMovieModel>,
        ),
      );
    } catch (error) {
      emit(MovieDetailsFailureState(_errorMessage(error)));
    }
  }

  Future<void> retry() async {
    final movieId = _movieId;
    if (movieId == null) {
      emit(MovieDetailsFailureState(StringsManager.movieNotFound));
      return;
    }
    await loadMovie(movieId);
  }

  String _errorMessage(Object error) {
    if (error is MovieDataException) return error.message;
    return StringsManager.moviesServiceError;
  }
}
