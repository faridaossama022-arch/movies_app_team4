import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/repository/auth_repository.dart';
import 'package:movie_app/ui/login/cubit/login_states.dart';

@injectable
class LoginCubit extends Cubit<LoginStates> {
  final AuthRepository authRepository;

  LoginCubit(this.authRepository) : super(LoginInitialState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    try {
      await authRepository.login(email: email, password: password);
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailureState(getErrorMessage(e.code)));
    } catch (e) {
      emit(LoginFailureState(StringsManager.somethingWentWrong));
    }
  }

  String getErrorMessage(String code) {
    switch (code) {
      case "invalid-credential":
      case "user-not-found":
      case "wrong-password":
        return StringsManager.wrongEmailOrPassword;
      case "invalid-email":
        return StringsManager.emailInvalid;
      case "too-many-requests":
        return StringsManager.tooManyRequests;
      case "network-request-failed":
        return StringsManager.networkError;
      default:
        return StringsManager.somethingWentWrong;
    }
  }
}