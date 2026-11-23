import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';
import 'package:movie_app/data/remote/movies_api_client.dart';
import 'package:movie_app/data/repository/movies_repository.dart';
import 'package:movie_app/ui/browse/cubit/browse_states.dart';

@injectable
class BrowseCubit extends Cubit<BrowseStates> {
  static const int _pageSize = 20;

  final MoviesRepository _moviesRepository;
  int _page = 1;
  int _requestVersion = 0;
  String? _selectedGenre;
  List<String> _genres = const [];

  BrowseCubit(this._moviesRepository) : super(BrowseInitialState());

  Future<void> loadInitial() async {
    final version = ++_requestVersion;
    _page = 1;
    emit(BrowseLoadingState());

    try {
      final result = await _moviesRepository.getMovies(
        page: _page,
        limit: _pageSize,
        genre: _selectedGenre,
      );
      if (version != _requestVersion) return;

      if (_selectedGenre == null || _genres.isEmpty) {
        _genres = _extractGenres(result.movies);
      }
      _page = result.pageNumber;
      emit(
        BrowseSuccessState(
          movies: result.movies,
          genres: _genres,
          selectedGenre: _selectedGenre,
          hasMore:
              result.movies.isNotEmpty &&
              result.movies.length < result.movieCount,
        ),
      );
    } catch (error) {
      if (version != _requestVersion) return;
      emit(BrowseFailureState(_errorMessage(error)));
    }
  }

  Future<void> selectGenre(String? genre) async {
    if (_selectedGenre == genre && state is BrowseSuccessState) return;
    _selectedGenre = genre;
    await loadInitial();
  }

  Future<void> retry() => loadInitial();

  Future<void> loadNextPage() async {
    final current = state;
    if (current is! BrowseSuccessState ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    final version = _requestVersion;
    final genre = _selectedGenre;
    final nextPage = _page + 1;
    emit(current.copyWith(isLoadingMore: true, clearPageError: true));

    try {
      final result = await _moviesRepository.getMovies(
        page: nextPage,
        limit: _pageSize,
        genre: genre,
      );
      if (version != _requestVersion || genre != _selectedGenre) return;

      final seenIds = current.movies.map((movie) => movie.id).toSet();
      final appended = result.movies
          .where((movie) => movie.id == null || !seenIds.contains(movie.id))
          .toList(growable: false);
      final movies = [...current.movies, ...appended];
      _page = result.pageNumber;
      emit(
        current.copyWith(
          movies: movies,
          isLoadingMore: false,
          hasMore:
              result.movies.isNotEmpty && movies.length < result.movieCount,
        ),
      );
    } catch (error) {
      if (version != _requestVersion || genre != _selectedGenre) return;
      emit(
        current.copyWith(isLoadingMore: false, pageError: _errorMessage(error)),
      );
    }
  }

  List<String> _extractGenres(List<YtsMovieModel> movies) {
    return movies
        .expand((movie) => movie.genres)
        .map((genre) => genre.trim())
        .where((genre) => genre.isNotEmpty)
        .toSet()
        .toList()
      ..sort((first, second) => first.compareTo(second));
  }

  String _errorMessage(Object error) {
    if (error is MovieDataException) return error.message;
    return StringsManager.moviesServiceError;
  }
}
