import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/model/saved_movie_model.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';
import 'package:movie_app/data/remote/movies_api_client.dart';
import 'package:movie_app/data/repository/movies_repository.dart';
import 'package:movie_app/data/repository/user_repository.dart';
import 'package:movie_app/ui/movie_details/cubit/movie_details_states.dart';

@injectable
class MovieDetailsCubit extends Cubit<MovieDetailsStates> {
  final MoviesRepository _moviesRepository;
  final UserRepository _userRepository;
  int? _movieId;

  MovieDetailsCubit(this._moviesRepository, this._userRepository)
      : super(MovieDetailsInitialState());

  Future<void> loadMovie(int movieId) async {
    _movieId = movieId;
    emit(MovieDetailsLoadingState());
    try {
      final results = await Future.wait<Object>([
        _moviesRepository.getMovieDetails(movieId),
        _moviesRepository.getMovieSuggestions(movieId),
      ]);
      YtsMovieModel movie = results[0] as YtsMovieModel;
      await _userRepository.addToHistory(savedMovie(movieId, movie));
      bool isSaved = await _userRepository.isInWatchList(movieId);
      emit(
        MovieDetailsSuccessState(
          movie: movie,
          suggestions: results[1] as List<YtsMovieModel>,
          isSaved: isSaved,
        ),
      );
    } catch (error) {
      emit(MovieDetailsFailureState(_errorMessage(error)));
    }
  }

  Future<void> toggleWatchList() async {
    MovieDetailsStates currentState = state;
    int? movieId = _movieId;
    if (currentState is! MovieDetailsSuccessState || movieId == null) return;
    try {
      if (currentState.isSaved) {
        await _userRepository.removeFromWatchList(movieId);
      } else {
        await _userRepository.addToWatchList(
          savedMovie(movieId, currentState.movie),
        );
      }
      emit(
        MovieDetailsSuccessState(
          movie: currentState.movie,
          suggestions: currentState.suggestions,
          isSaved: !currentState.isSaved,
        ),
      );
    } catch (error) {
      return;
    }
  }

  SavedMovieModel savedMovie(int movieId, YtsMovieModel movie) {
    return SavedMovieModel(
      id: movieId,
      title: movie.title,
      poster: movie.posterImage,
      rating: movie.rating,
    );
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