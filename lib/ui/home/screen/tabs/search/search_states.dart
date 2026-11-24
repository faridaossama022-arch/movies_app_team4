import 'package:movie_app/data/model/yts_movie_model.dart';

sealed class SearchStates {}

/// لسه المستخدم ما كتبش حاجة
class SearchInitialState extends SearchStates {}

class SearchLoadingState extends SearchStates {}

class SearchSuccessState extends SearchStates {
  final String query;
  final List<YtsMovieModel> movies;

  SearchSuccessState({required this.query, required this.movies});
}

class SearchFailureState extends SearchStates {
  final String message;

  SearchFailureState(this.message);
}
