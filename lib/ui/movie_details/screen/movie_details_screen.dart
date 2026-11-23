import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/movie_navigation.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';
import 'package:movie_app/ui/movie_details/cubit/movie_details_cubit.dart';
import 'package:movie_app/ui/movie_details/cubit/movie_details_states.dart';
import 'package:movie_app/ui/movies/widget/movie_poster_card.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends StatelessWidget {
  final ValueChanged<YtsMovieModel>? onSaveMovie;

  const MovieDetailsScreen({super.key, this.onSaveMovie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: SafeArea(
        child: BlocBuilder<MovieDetailsCubit, MovieDetailsStates>(
          builder: (context, state) {
            return switch (state) {
              MovieDetailsLoadingState() ||
              MovieDetailsInitialState() => const Center(
                child: CircularProgressIndicator(color: ColorsManager.yellow),
              ),
              MovieDetailsFailureState(:final message) => _errorView(
                context,
                message,
              ),
              MovieDetailsSuccessState(:final movie, :final suggestions) =>
                _detailsView(context, movie, suggestions),
            };
          },
        ),
      ),
    );
  }

  Widget _errorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: ColorsManager.white.withValues(alpha: 0.8),
              size: 46.sp,
            ),
            SizedBox(height: 18.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorsManager.white, fontSize: 15.sp),
            ),
            SizedBox(height: 18.h),
            ElevatedButton(
              onPressed: context.read<MovieDetailsCubit>().retry,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.yellow,
                foregroundColor: ColorsManager.black,
              ),
              child: const Text(StringsManager.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailsView(
    BuildContext context,
    YtsMovieModel movie,
    List<YtsMovieModel> suggestions,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          child: Row(
            children: [
              IconButton(
                tooltip: StringsManager.back,
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorsManager.white,
                  size: 25.sp,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: StringsManager.saveMovie,
                onPressed: () {
                  final saveMovie = onSaveMovie;
                  if (saveMovie == null) {
                    _showMessage(context, StringsManager.watchlistNotConnected);
                  } else {
                    saveMovie(movie);
                  }
                },
                icon: Icon(
                  Icons.bookmark_border,
                  color: ColorsManager.white,
                  size: 25.sp,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _moviePoster(context, movie),
                SizedBox(height: 18.h),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Column(
                      children: [
                        Text(
                          movie.title.isEmpty
                              ? StringsManager.notAvailable
                              : movie.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ColorsManager.white,
                            fontSize: 23.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          movie.year?.toString() ?? StringsManager.notAvailable,
                          style: TextStyle(
                            color: ColorsManager.white.withValues(alpha: 0.7),
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: movie.trailerCode == null
                          ? () => _showMessage(
                              context,
                              StringsManager.trailerUnavailable,
                            )
                          : () => _openTrailer(context, movie.trailerCode!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.red,
                        foregroundColor: ColorsManager.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.r),
                        ),
                      ),
                      child: Text(
                        movie.trailerCode == null
                            ? StringsManager.watchUnavailable
                            : StringsManager.watchTrailer,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                _statistics(movie),
                SizedBox(height: 26.h),
                _sectionTitle(StringsManager.screenshots),
                SizedBox(height: 12.h),
                _screenshots(movie.screenshots),
                SizedBox(height: 24.h),
                _sectionTitle(StringsManager.summary),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    movie.summary ?? StringsManager.notAvailable,
                    style: TextStyle(
                      color: ColorsManager.white.withValues(alpha: 0.88),
                      fontSize: 14.sp,
                      height: 1.45,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                _sectionTitle(StringsManager.cast),
                SizedBox(height: 8.h),
                _cast(movie.cast),
                SizedBox(height: 24.h),
                _sectionTitle(StringsManager.genres),
                SizedBox(height: 10.h),
                _genres(movie.genres),
                SizedBox(height: 26.h),
                _sectionTitle(StringsManager.similarMovies),
                SizedBox(height: 12.h),
                _suggestions(context, suggestions),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _moviePoster(BuildContext context, YtsMovieModel movie) {
    final posterUrl = movie.posterImage;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          height: 285.h,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (posterUrl == null)
                _posterPlaceholder()
              else
                Image.network(
                  posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _posterPlaceholder(),
                ),
              ColoredBox(color: Colors.black.withValues(alpha: 0.15)),
              Center(
                child: Material(
                  color: Colors.black.withValues(alpha: 0.65),
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: StringsManager.watchTrailer,
                    onPressed: movie.trailerCode == null
                        ? () => _showMessage(
                            context,
                            StringsManager.trailerUnavailable,
                          )
                        : () => _openTrailer(context, movie.trailerCode!),
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      color: ColorsManager.white,
                      size: 40.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _posterPlaceholder() {
    return ColoredBox(
      color: ColorsManager.darkGrey,
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          color: ColorsManager.white.withValues(alpha: 0.65),
          size: 54.sp,
        ),
      ),
    );
  }

  Widget _statistics(YtsMovieModel movie) {
    final stats = <Widget>[];
    if (movie.rating != null) {
      stats.add(
        _statItem(
          Icons.star,
          StringsManager.rating,
          movie.rating!.toStringAsFixed(1),
          ColorsManager.yellow,
        ),
      );
    }
    if (movie.runtime != null) {
      stats.add(
        _statItem(
          Icons.schedule,
          StringsManager.runtime,
          '${movie.runtime} ${StringsManager.minutesShort}',
          ColorsManager.white,
        ),
      );
    }
    if (movie.likeCount != null) {
      stats.add(
        _statItem(
          Icons.thumb_up_alt_outlined,
          StringsManager.likes,
          movie.likeCount.toString(),
          ColorsManager.white,
        ),
      );
    }

    if (stats.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats,
      ),
    );
  }

  Widget _statItem(IconData icon, String label, String value, Color iconColor) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 17.sp),
              SizedBox(width: 4.w),
              Text(
                value,
                style: TextStyle(
                  color: ColorsManager.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            label,
            style: TextStyle(
              color: ColorsManager.white.withValues(alpha: 0.65),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        title,
        style: TextStyle(
          color: ColorsManager.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _screenshots(List<String> screenshots) {
    if (screenshots.isEmpty) {
      return _notAvailableRow();
    }
    return SizedBox(
      height: 142.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: screenshots.length,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(9.r),
          child: Image.network(
            screenshots[index],
            width: 236.w,
            height: 142.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 236.w,
              color: ColorsManager.darkGrey,
              child: Icon(
                Icons.broken_image_outlined,
                color: ColorsManager.white.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cast(List<MovieCastMember> cast) {
    if (cast.isEmpty) return _notAvailableRow();
    return Column(
      children: cast
          .map(
            (member) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      member.name,
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      member.characterName ?? StringsManager.notAvailable,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: ColorsManager.white.withValues(alpha: 0.7),
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  Widget _genres(List<String> genres) {
    if (genres.isEmpty) return _notAvailableRow();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: genres
            .map(
              (genre) => Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: ColorsManager.darkGrey,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Text(
                  genre,
                  style: TextStyle(color: ColorsManager.white, fontSize: 12.sp),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _suggestions(BuildContext context, List<YtsMovieModel> suggestions) {
    if (suggestions.isEmpty) {
      return _notAvailableRow(StringsManager.noSimilarMovies);
    }
    return SizedBox(
      height: 250.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final movie = suggestions[index];
          final movieId = movie.id;
          return MoviePosterCard(
            movie: movie,
            width: 132.w,
            onTap: movieId == null
                ? null
                : () => MovieNavigation.openDetails(context, movieId),
          );
        },
      ),
    );
  }

  Widget _notAvailableRow([String message = StringsManager.notAvailable]) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        message,
        style: TextStyle(
          color: ColorsManager.white.withValues(alpha: 0.65),
          fontSize: 13.sp,
        ),
      ),
    );
  }

  Future<void> _openTrailer(BuildContext context, String trailerCode) async {
    final trailerUri = Uri.https('www.youtube.com', '/watch', {
      'v': trailerCode,
    });
    try {
      final opened = await launchUrl(
        trailerUri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened && context.mounted) {
        _showMessage(context, StringsManager.trailerUnavailable);
      }
    } catch (_) {
      if (context.mounted) {
        _showMessage(context, StringsManager.trailerUnavailable);
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
