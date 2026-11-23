import 'package:movie_app/data/model/yts_movie_model.dart';

sealed class MovieDetailsStates {}

class MovieDetailsInitialState extends MovieDetailsStates {}

class MovieDetailsLoadingState extends MovieDetailsStates {}

class MovieDetailsSuccessState extends MovieDetailsStates {
  final YtsMovieModel movie;
  final List<YtsMovieModel> suggestions;

  MovieDetailsSuccessState({required this.movie, required this.suggestions});
}

class MovieDetailsFailureState extends MovieDetailsStates {
  final String message;

  MovieDetailsFailureState(this.message);
}
