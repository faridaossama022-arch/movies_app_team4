sealed class UpdateProfileStates {}

class UpdateProfileInitialState extends UpdateProfileStates {}

class UpdateProfileLoadingState extends UpdateProfileStates {}

class UpdateProfileSuccessState extends UpdateProfileStates {}

class DeleteAccountSuccessState extends UpdateProfileStates {}

class UpdateProfileFailureState extends UpdateProfileStates {
  final String error;
  UpdateProfileFailureState(this.error);
}