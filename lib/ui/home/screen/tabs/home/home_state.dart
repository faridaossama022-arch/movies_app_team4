import 'package:movie_app/data/model/yts_movie_model.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  /// أفلام السلايدر الرئيسي
  final List<YtsMovieModel> featured;

  /// النوع المعروض حاليًا تحت السلايدر
  final String genre;

  /// أفلام النوع (null = لسه بيتحمّل)
  final List<YtsMovieModel>? genreMovies;

  HomeSuccess({
    required this.featured,
    required this.genre,
    required this.genreMovies,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
