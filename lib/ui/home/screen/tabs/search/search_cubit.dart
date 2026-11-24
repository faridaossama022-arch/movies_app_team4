import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/remote/movies_api_client.dart';
import 'package:movie_app/data/repository/movies_repository.dart';

import 'search_states.dart';

@injectable
class SearchCubit extends Cubit<SearchStates> {
  static const Duration _debounce = Duration(milliseconds: 500);
  static const int _limit = 30;

  final MoviesRepository _moviesRepository;
  Timer? _timer;
  int _requestVersion = 0;
  String _lastQuery = '';

  SearchCubit(this._moviesRepository) : super(SearchInitialState());

  /// بتتنادى مع كل حرف؛ البحث الفعلي بيتأخر 500ms بعد آخر حرف.
  void onQueryChanged(String value) {
    _timer?.cancel();
    final query = value.trim();
    _lastQuery = query;

    if (query.isEmpty) {
      _requestVersion++; // يلغي أي طلب شغال
      emit(SearchInitialState());
      return;
    }

    emit(SearchLoadingState());
    _timer = Timer(_debounce, () => _search(query));
  }

  Future<void> retry() async {
    if (_lastQuery.isEmpty) return;
    emit(SearchLoadingState());
    await _search(_lastQuery);
  }

  Future<void> _search(String query) async {
    final version = ++_requestVersion;
    try {
      final result = await _moviesRepository.getMovies(
        page: 1,
        limit: _limit,
        query: query,
      );
      if (version != _requestVersion) return;
      emit(SearchSuccessState(query: query, movies: result.movies));
    } catch (error) {
      if (version != _requestVersion) return;
      emit(
        SearchFailureState(
          error is MovieDataException
              ? error.message
              : StringsManager.moviesServiceError,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
