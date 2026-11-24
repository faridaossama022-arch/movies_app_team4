import 'package:flutter/material.dart';
import 'package:movie_app/core/resources/routes_manager.dart';

abstract final class MovieNavigation {
  static Future<Object?> openDetails(BuildContext context, int movieId) {
    return Navigator.of(context)
        .pushNamed(RoutesManager.movieDetailsRoute, arguments: movieId);
  }

  static Future<Object?> openCategory(BuildContext context, String genre) {
    return Navigator.of(context)
        .pushNamed(RoutesManager.categoryMoviesRoute, arguments: genre);
  }
}
