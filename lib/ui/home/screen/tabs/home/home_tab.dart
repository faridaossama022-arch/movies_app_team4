import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/movie_navigation.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';
import 'package:movie_app/ui/home/widget/movie_category_section.dart';
import 'package:movie_app/ui/home/widget/movie_item.dart';

import 'home_cubit.dart';
import 'home_state.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // الـ HomeCubit بيتعمل في HomeScreen عشان يفضل عايش بين التابات.
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeError) {
            return _ErrorView(message: state.message);
          }
          if (state is! HomeSuccess) {
            return const Center(
              child: CircularProgressIndicator(color: ColorsManager.yellow),
            );
          }

          return Column(
            children: [
              Expanded(child: _Hero(featured: state.featured)),
              SizedBox(height: 5.h),
              if (state.genreMovies == null)
                SizedBox(
                  height: 270.h,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.yellow,
                    ),
                  ),
                )
              else
                MovieCategorySection(
                  title: state.genre,
                  movies: state.genreMovies!,
                  onSeeMore: () =>
                      MovieNavigation.openCategory(context, state.genre),
                ),
              SizedBox(height: 95.h), // مكان الـ bottom navigation bar
            ],
          );
        },
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final List<YtsMovieModel> featured;

  const _Hero({required this.featured});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.black, Colors.transparent],
                  stops: [0.0, 0.65, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                AssetsManager.background,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                color: Colors.black.withValues(alpha: 0.5),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          Positioned(
            top: 7.h,
            left: 82.w,
            child: Image.asset(
              AssetsManager.available,
              height: 93.h,
              width: 267.w,
            ),
          ),
          Center(child: MoviesSlider(movies: featured)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                AssetsManager.wachtnow,
                width: 354.w,
                height: 146.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: ColorsManager.white.withValues(alpha: 0.8),
              size: 44.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorsManager.white, fontSize: 15.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => context.read<HomeCubit>().loadHome(),
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
}
