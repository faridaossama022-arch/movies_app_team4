class YtsMovieModel {
  final int? id;
  final String title;
  final int? year;
  final double? rating;
  final int? runtime;
  final List<String> genres;
  final String? summary;
  final String? posterImage;
  final String? backgroundImage;
  final String? trailerCode;
  final int? likeCount;
  final List<String> screenshots;
  final List<MovieCastMember> cast;

  const YtsMovieModel({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.genres,
    required this.summary,
    required this.posterImage,
    required this.backgroundImage,
    required this.trailerCode,
    required this.likeCount,
    required this.screenshots,
    required this.cast,
  });

  factory YtsMovieModel.fromJson(Map<String, dynamic> json) {
    final screenshots = <String>[];
    for (var index = 1; index <= 3; index++) {
      final image =
          _stringValue(json['large_screenshot_image$index']) ??
          _stringValue(json['medium_screenshot_image$index']);
      if (image != null && !screenshots.contains(image)) {
        screenshots.add(image);
      }
    }

    final rawGenres = json['genres'];
    final rawCast = json['cast'];

    return YtsMovieModel(
      id: _intValue(json['id']),
      title:
          _stringValue(json['title']) ??
          _stringValue(json['title_english']) ??
          _stringValue(json['title_long']) ??
          '',
      year: _intValue(json['year']),
      rating: _doubleValue(json['rating']),
      runtime: _intValue(json['runtime']),
      genres: rawGenres is List
          ? rawGenres
                .map(_stringValue)
                .whereType<String>()
                .where((genre) => genre.isNotEmpty)
                .toList(growable: false)
          : const [],
      summary:
          _stringValue(json['summary']) ??
          _stringValue(json['description_intro']) ??
          _stringValue(json['description_full']) ??
          _stringValue(json['synopsis']),
      posterImage:
          _stringValue(json['large_cover_image']) ??
          _stringValue(json['medium_cover_image']) ??
          _stringValue(json['small_cover_image']),
      backgroundImage:
          _stringValue(json['background_image_original']) ??
          _stringValue(json['background_image']),
      trailerCode: _stringValue(json['yt_trailer_code']),
      likeCount: _intValue(json['like_count']),
      screenshots: screenshots,
      cast: rawCast is List
          ? rawCast
                .map(_mapValue)
                .whereType<Map<String, dynamic>>()
                .map(MovieCastMember.fromJson)
                .where((member) => member.name.isNotEmpty)
                .toList(growable: false)
          : const [],
    );
  }
}

class MovieCastMember {
  final String name;
  final String? characterName;

  const MovieCastMember({required this.name, required this.characterName});

  factory MovieCastMember.fromJson(Map<String, dynamic> json) {
    return MovieCastMember(
      name: _stringValue(json['name']) ?? '',
      characterName:
          _stringValue(json['character_name']) ??
          _stringValue(json['character']),
    );
  }
}

class MoviePage {
  final List<YtsMovieModel> movies;
  final int movieCount;
  final int pageNumber;
  final int limit;

  const MoviePage({
    required this.movies,
    required this.movieCount,
    required this.pageNumber,
    required this.limit,
  });

  factory MoviePage.fromJson(Map<String, dynamic> json) {
    final rawMovies = json['movies'];

    return MoviePage(
      movies: rawMovies is List
          ? rawMovies
                .map(_mapValue)
                .whereType<Map<String, dynamic>>()
                .map(YtsMovieModel.fromJson)
                .toList(growable: false)
          : const [],
      movieCount: _intValue(json['movie_count']) ?? 0,
      pageNumber: _intValue(json['page_number']) ?? 1,
      limit: _intValue(json['limit']) ?? 20,
    );
  }
}

int? _intValue(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

double? _doubleValue(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

String? _stringValue(dynamic value) {
  if (value is String && value.trim().isNotEmpty) return value.trim();
  return null;
}

Map<String, dynamic>? _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}
