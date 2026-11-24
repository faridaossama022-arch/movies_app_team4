import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/repository/user_repository.dart';
import 'package:movie_app/ui/update_profile/cubit/update_profile_states.dart';

@injectable
class UpdateProfileCubit extends Cubit<UpdateProfileStates> {
  final UserRepository userRepository;

  UpdateProfileCubit(this.userRepository) : super(UpdateProfileInitialState());

  Future<void> updateUser({
    required String name,
    required String phone,
    required String avatar,
  }) async {
    emit(UpdateProfileLoadingState());
    try {
      await userRepository.updateUser(name: name, phone: phone, avatar: avatar);
      emit(UpdateProfileSuccessState());
    } catch (e) {
      emit(UpdateProfileFailureState(StringsManager.somethingWentWrong));
    }
  }

  Future<void> deleteAccount() async {
    emit(UpdateProfileLoadingState());
    try {
      await userRepository.deleteAccount();
      emit(DeleteAccountSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        emit(UpdateProfileFailureState(StringsManager.loginAgain));
      } else {
        emit(UpdateProfileFailureState(StringsManager.somethingWentWrong));
      }
    } catch (e) {
      emit(UpdateProfileFailureState(StringsManager.somethingWentWrong));
    }
  }
}