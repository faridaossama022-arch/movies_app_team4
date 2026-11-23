import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/movie_navigation.dart';
import '../../../model/movie_list.dart';

class MovieCategorySection extends StatelessWidget {
  final String title;
  final List<MovieModel> movies;
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
                onTap: movie.apiMovieId == null
                    ? null
                    : () => MovieNavigation.openDetails(
                        context,
                        movie.apiMovieId!,
                      ),
                borderRadius: BorderRadius.circular(15.r),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: Stack(
                    children: [
                      Image(
                        image: movie.imageIsNetwork
                            ? NetworkImage(movie.image)
                            : AssetImage(movie.image),
                        width: 146.w,
                        height: 220.h,
                        fit: BoxFit.cover,
                      ),

                      Positioned(
                        top: 20.h,
                        left: 15.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: Row(
                            children: [
                              Text(
                                movie.rating.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.sp,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Icon(
                                Icons.star,
                                color: const Color(0xffFFC107),
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
