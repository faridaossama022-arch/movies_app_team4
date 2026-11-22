
class MovieModel {
  final String image;
  final String rating;

  MovieModel({
    required this.image,
    required this.rating,
  });

  static List<MovieModel> movies = [
    MovieModel(
      image: 'assets/images/Card (2).png',
      rating: '7.7',
    ),
    MovieModel(
      image: 'assets/images/Card (2).png',
      rating: '8.5',
    ),
    MovieModel(
      image: 'assets/images/Card (1).png',
      rating: '9.0',
    ),
    MovieModel(
      image: 'assets/images/Card.png',
      rating: '8.2',
    ),MovieModel(
      image: 'assets/images/Card.png',
      rating: '8.2',
    ),MovieModel(
      image: 'assets/images/Card.png',
      rating: '8.2',
    ),MovieModel(
      image: 'assets/images/Card.png',
      rating: '8.2',
    ),
  ];
}
