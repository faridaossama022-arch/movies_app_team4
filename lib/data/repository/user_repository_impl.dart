import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/data/model/saved_movie_model.dart';
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

  CollectionReference<Map<String, dynamic>> getWatchListCollection() {
    String id = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(id)
        .collection(SavedMovieModel.watchListCollection);
  }

  CollectionReference<Map<String, dynamic>> getHistoryCollection() {
    String id = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(id)
        .collection(SavedMovieModel.historyCollection);
  }

  @override
  Future<void> addToWatchList(SavedMovieModel movie) async {
    movie.date = Timestamp.now();
    await getWatchListCollection()
        .doc(movie.id.toString())
        .set(movie.toFireStore());
  }

  @override
  Future<void> removeFromWatchList(int movieId) async {
    await getWatchListCollection().doc(movieId.toString()).delete();
  }

  @override
  Future<bool> isInWatchList(int movieId) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
    await getWatchListCollection().doc(movieId.toString()).get();
    return doc.exists;
  }

  @override
  Future<List<SavedMovieModel>> getWatchList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await getWatchListCollection()
        .orderBy("date", descending: true)
        .get();
    return snapshot.docs
        .map((doc) => SavedMovieModel.fromFireStore(doc.data()))
        .toList();
  }

  @override
  Future<void> addToHistory(SavedMovieModel movie) async {
    movie.date = Timestamp.now();
    await getHistoryCollection()
        .doc(movie.id.toString())
        .set(movie.toFireStore());
  }

  @override
  Future<List<SavedMovieModel>> getHistory() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await getHistoryCollection()
        .orderBy("date", descending: true)
        .get();
    return snapshot.docs
        .map((doc) => SavedMovieModel.fromFireStore(doc.data()))
        .toList();
  }
}