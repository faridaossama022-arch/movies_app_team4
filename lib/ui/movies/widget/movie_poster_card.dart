import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';

class MoviePosterCard extends StatelessWidget {
  final YtsMovieModel movie;
  final VoidCallback? onTap;
  final double? width;

  const MoviePosterCard({
    super.key,
    required this.movie,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _posterImage(),
                    if (movie.rating != null)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.72),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: ColorsManager.yellow,
                                size: 15.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                movie.rating!.toStringAsFixed(1),
                                style: TextStyle(
                                  color: ColorsManager.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 7.h),
            Text(
              movie.title.isEmpty ? StringsManager.notAvailable : movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorsManager.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (movie.year != null) ...[
              SizedBox(height: 2.h),
              Text(
                movie.year.toString(),
                style: TextStyle(
                  color: ColorsManager.white.withValues(alpha: 0.7),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _posterImage() {
    final imageUrl = movie.posterImage;
    if (imageUrl == null) return _imagePlaceholder();

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return ColoredBox(
      color: ColorsManager.darkGrey,
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          color: ColorsManager.white.withValues(alpha: 0.7),
          size: 34.sp,
        ),
      ),
    );
  }
}
