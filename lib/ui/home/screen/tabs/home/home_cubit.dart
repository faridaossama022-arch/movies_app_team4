import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';
import 'package:movie_app/data/remote/movies_api_client.dart';
import 'package:movie_app/data/repository/movies_repository.dart';

import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  /// الأنواع اللي بتتبدّل في الهوم (غيّرها زي ما تحب)
  static const List<String> genres = [
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi',
    'Romance',
    'Animation',
    'Thriller',
    'Adventure',
  ];

  final MoviesRepository _moviesRepository;
  final Random _random = Random();
  final Map<String, List<YtsMovieModel>> _cache = {};

  List<YtsMovieModel> _featured = const [];
  String _genre = genres.first;
  int _requestVersion = 0;

  HomeCubit(this._moviesRepository) : super(HomeInitial());

  /// تحميل أول مرة (السلايدر + نوع عشوائي)
  Future<void> loadHome() async {
    emit(HomeLoading());
    _cache.clear();
    _genre = genres[_random.nextInt(genres.length)];
    try {
      final featuredPage = await _moviesRepository.getMovies(
        page: 1,
        limit: 10,
      );
      _featured = featuredPage.movies;
      await _loadGenre(_genre);
    } catch (error) {
      emit(HomeError(_message(error)));
    }
  }

  /// بتتنادى لما المستخدم يرجع للهوم: بتختار نوع مختلف عن الحالي.
  Future<void> changeGenre() async {
    if (state is! HomeSuccess) return;
    final others = genres.where((g) => g != _genre).toList();
    _genre = others[_random.nextInt(others.length)];
    await _loadGenre(_genre);
  }

  Future<void> _loadGenre(String genre) async {
    final version = ++_requestVersion;

    final cached = _cache[genre];
    if (cached != null) {
      emit(HomeSuccess(featured: _featured, genre: genre, genreMovies: cached));
      return;
    }

    // نعرض النوع الجديد على طول مع لودينج في مكان القسم بس
    emit(HomeSuccess(featured: _featured, genre: genre, genreMovies: null));
    try {
      final page = await _moviesRepository.getMovies(
        page: 1,
        limit: 12,
        genre: genre,
      );
      _cache[genre] = page.movies;
      if (version != _requestVersion) return;
      emit(
        HomeSuccess(featured: _featured, genre: genre, genreMovies: page.movies),
      );
    } catch (error) {
      if (version != _requestVersion) return;
      emit(HomeError(_message(error)));
    }
  }

  String _message(Object error) => error is MovieDataException
      ? error.message
      : StringsManager.moviesServiceError;
}
