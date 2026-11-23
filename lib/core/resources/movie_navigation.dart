import 'package:flutter/material.dart';
import 'package:movie_app/core/resources/routes_manager.dart';

abstract final class MovieNavigation {
  static Future<Object?> openDetails(BuildContext context, int movieId) {
    return Navigator.of(context)
        .pushNamed(RoutesManager.movieDetailsRoute, arguments: movieId);
  }
}
