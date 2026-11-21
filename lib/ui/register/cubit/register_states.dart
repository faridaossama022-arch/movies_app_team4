sealed class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterFailureState extends RegisterStates {
  final String error;

  RegisterFailureState(this.error);
}