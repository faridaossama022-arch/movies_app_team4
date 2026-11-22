import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:movie_app/model/movie_list.dart';

class MoviesSlider extends StatelessWidget {
  const MoviesSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 350.h,
        enlargeCenterPage: true,
        autoPlay: false,
        viewportFraction: 0.65,
        enableInfiniteScroll: true,
      ),
      items: MovieModel.movies.map((movie) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: AssetImage(movie.image),
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }
}