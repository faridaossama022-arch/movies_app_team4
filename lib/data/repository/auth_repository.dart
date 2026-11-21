abstract class AuthRepository {
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  });

  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> forgetPassword({
    required String email,
  });
}