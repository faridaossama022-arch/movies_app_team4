import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/repository/auth_repository.dart';
import 'package:movie_app/ui/register/cubit/register_states.dart';

@injectable
class RegisterCubit extends Cubit<RegisterStates> {
  final AuthRepository authRepository;

  RegisterCubit(this.authRepository) : super(RegisterInitialState());

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    emit(RegisterLoadingState());
    try {
      await authRepository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        avatar: avatar,
      );
      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(RegisterFailureState(getErrorMessage(e.code)));
    } catch (e) {
      emit(RegisterFailureState(StringsManager.somethingWentWrong));
    }
  }

  String getErrorMessage(String code) {
    switch (code) {
      case "email-already-in-use":
        return StringsManager.emailAlreadyInUse;
      case "weak-password":
        return StringsManager.weakPassword;
      case "invalid-email":
        return StringsManager.emailInvalid;
      case "network-request-failed":
        return StringsManager.networkError;
      default:
        return StringsManager.somethingWentWrong;
    }
  }
}