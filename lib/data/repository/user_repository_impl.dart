import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/data/model/user_model.dart';
import 'package:movie_app/data/repository/user_repository.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserModel> getUser() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(id)
        .get();
    return UserModel.fromFireStore(snapshot.data());
  }

  @override
  Future<void> updateUser({
    required String name,
    required String phone,
    required String avatar,
  }) async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(id)
        .update({
      "name": name,
      "phone": phone,
      "avatar": avatar,
    });
  }

  @override
  Future<void> deleteAccount() async {
    User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(user.uid)
        .delete();
    await user.delete();
  }
}