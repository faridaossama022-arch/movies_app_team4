import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/data/model/user_model.dart';
import 'package:movie_app/data/repository/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    UserModel user = UserModel(
      id: credential.user!.uid,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
    );
    await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(user.id)
        .set(user.toFireStore());
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> forgetPassword({
    required String email,
  }) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}