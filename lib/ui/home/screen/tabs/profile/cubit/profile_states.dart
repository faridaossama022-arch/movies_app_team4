import 'package:movie_app/data/model/user_model.dart';

sealed class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ProfileLoadingState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {
  final UserModel user;

  ProfileSuccessState(this.user);
}

class ProfileFailureState extends ProfileStates {
  final String error;

  ProfileFailureState(this.error);
}