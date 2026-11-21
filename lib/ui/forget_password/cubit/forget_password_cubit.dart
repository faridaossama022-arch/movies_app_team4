import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/repository/auth_repository.dart';
import 'package:movie_app/ui/forget_password/cubit/forget_password_states.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  final AuthRepository authRepository;

  ForgetPasswordCubit(this.authRepository) : super(ForgetPasswordInitialState());

  Future<void> forgetPassword({required String email}) async {
    emit(ForgetPasswordLoadingState());
    try {
      await authRepository.forgetPassword(email: email);
      emit(ForgetPasswordSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(ForgetPasswordFailureState(getErrorMessage(e.code)));
    } catch (e) {
      emit(ForgetPasswordFailureState(StringsManager.somethingWentWrong));
    }
  }

  String getErrorMessage(String code) {
    switch (code) {
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