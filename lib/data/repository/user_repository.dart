import 'package:movie_app/data/model/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUser();

  Future<void> updateUser({
    required String name,
    required String phone,
    required String avatar,
  });

  Future<void> deleteAccount();
}