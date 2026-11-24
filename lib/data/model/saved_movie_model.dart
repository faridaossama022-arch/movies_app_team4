import 'package:cloud_firestore/cloud_firestore.dart';

class SavedMovieModel {
  static const String watchListCollection = "watchList";
  static const String historyCollection = "history";

  int? id;
  String? title;
  String? poster;
  double? rating;
  Timestamp? date;

  SavedMovieModel({this.id, this.title, this.poster, this.rating, this.date});

  SavedMovieModel.fromFireStore(Map<String, dynamic>? data) {
    id = data?["id"];
    title = data?["title"];
    poster = data?["poster"];
    rating = data?["rating"];
    date = data?["date"];
  }

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "title": title,
      "poster": poster,
      "rating": rating,
      "date": date,
    };
  }
}