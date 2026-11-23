import 'package:movie_app/data/model/yts_movie_model.dart';

sealed class BrowseStates {}

class BrowseInitialState extends BrowseStates {}

class BrowseLoadingState extends BrowseStates {}

class BrowseFailureState extends BrowseStates {
  final String message;

  BrowseFailureState(this.message);
}

class BrowseSuccessState extends BrowseStates {
  final List<YtsMovieModel> movies;
  final List<String> genres;
  final String? selectedGenre;
  final bool hasMore;
  final bool isLoadingMore;
  final String? pageError;

  BrowseSuccessState({
    required this.movies,
    required this.genres,
    required this.selectedGenre,
    required this.hasMore,
    this.isLoadingMore = false,
    this.pageError,
  });

  BrowseSuccessState copyWith({
    List<YtsMovieModel>? movies,
    List<String>? genres,
    String? selectedGenre,
    bool clearSelectedGenre = false,
    bool? hasMore,
    bool? isLoadingMore,
    String? pageError,
    bool clearPageError = false,
  }) {
    return BrowseSuccessState(
      movies: movies ?? this.movies,
      genres: genres ?? this.genres,
      selectedGenre: clearSelectedGenre
          ? null
          : selectedGenre ?? this.selectedGenre,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pageError: clearPageError ? null : pageError ?? this.pageError,
    );
  }
}
