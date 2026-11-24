import 'package:movie_app/data/model/saved_movie_model.dart';
import 'package:movie_app/data/model/user_model.dart';

sealed class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ProfileLoadingState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {
  final UserModel user;
  final List<SavedMovieModel> watchList;
  final List<SavedMovieModel> history;

  ProfileSuccessState(this.user, this.watchList, this.history);
}

class ProfileFailureState extends ProfileStates {
  final String error;

  ProfileFailureState(this.error);
}