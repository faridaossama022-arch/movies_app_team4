import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/movie_navigation.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';

class MoviesSlider extends StatelessWidget {
  final List<YtsMovieModel> movies;

  const MoviesSlider({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return CarouselSlider(
      options: CarouselOptions(
        height: 350.h,
        enlargeCenterPage: true,
        autoPlay: false,
        viewportFraction: 0.65,
        enableInfiniteScroll: movies.length > 1,
      ),
      items: movies.map((movie) {
        return InkWell(
          onTap: movie.id == null
              ? null
              : () => MovieNavigation.openDetails(context, movie.id!),
          borderRadius: BorderRadius.circular(12.r),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                movie.posterImage == null
                    ? const ColoredBox(color: ColorsManager.darkGrey)
                    : Image.network(
                        movie.posterImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const ColoredBox(color: ColorsManager.darkGrey),
                      ),
                if (movie.rating != null)
                  Positioned(
                    top: 14.h,
                    left: 12.w,
                    child: _RatingBadge(rating: movie.rating!),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          SizedBox(width: 6.w),
          Icon(Icons.star, color: const Color(0xffFFC107), size: 18.sp),
        ],
      ),
    );
  }
}
