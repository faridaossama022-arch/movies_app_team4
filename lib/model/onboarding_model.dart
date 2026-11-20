import 'dart:ui';

class OnBoardingModel {
  String image;
  String title;
  String? description;
  Color color;

  OnBoardingModel({
    required this.image,
    required this.title,
    this.description,
    required this.color,
  });
}