import 'package:movie_app/data/model/saved_movie_model.dart';
import 'package:movie_app/data/model/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUser();

  Future<void> updateUser({
    required String name,
    required String phone,
    required String avatar,
  });

  Future<void> deleteAccount();

  Future<void> addToWatchList(SavedMovieModel movie);

  Future<void> removeFromWatchList(int movieId);

  Future<bool> isInWatchList(int movieId);

  Future<List<SavedMovieModel>> getWatchList();

  Future<void> addToHistory(SavedMovieModel movie);

  Future<List<SavedMovieModel>> getHistory();
}