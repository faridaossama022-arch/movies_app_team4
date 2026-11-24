import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/model/user_model.dart';
import 'package:movie_app/data/repository/user_repository.dart';
import 'package:movie_app/ui/home/screen/tabs/profile/cubit/profile_states.dart';

@injectable
class ProfileCubit extends Cubit<ProfileStates> {
  final UserRepository userRepository;

  ProfileCubit(this.userRepository) : super(ProfileInitialState());

  Future<void> getProfile() async {
    emit(ProfileLoadingState());
    try {
      UserModel user = await userRepository.getUser();
      emit(ProfileSuccessState(user));
    } catch (e) {
      emit(ProfileFailureState(StringsManager.somethingWentWrong));
    }
  }
}