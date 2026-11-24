import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/movie_navigation.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';

class MovieCategorySection extends StatelessWidget {
  final String title;
  final List<YtsMovieModel> movies;
  final VoidCallback? onSeeMore;

  const MovieCategorySection({
    super.key,
    required this.title,
    required this.movies,
    this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: onSeeMore,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Text(
                      'See More',
                      style: TextStyle(
                        color: const Color(0xffFFC107),
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Icon(
                      Icons.arrow_forward,
                      color: const Color(0xffFFC107),
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        SizedBox(
          height: 220.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: movies.length,
            separatorBuilder: (context, index) => SizedBox(width: 15.w),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return InkWell(
                onTap: movie.id == null
                    ? null
                    : () => MovieNavigation.openDetails(context, movie.id!),
                borderRadius: BorderRadius.circular(15.r),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: SizedBox(
                    width: 146.w,
                    height: 220.h,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        movie.posterImage == null
                            ? const ColoredBox(color: ColorsManager.darkGrey)
                            : Image.network(
                                movie.posterImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const ColoredBox(
                                  color: ColorsManager.darkGrey,
                                ),
                              ),
                        if (movie.rating != null)
                          Positioned(
                            top: 14.h,
                            left: 10.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    movie.rating!.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Icon(
                                    Icons.star,
                                    color: const Color(0xffFFC107),
                                    size: 17.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
