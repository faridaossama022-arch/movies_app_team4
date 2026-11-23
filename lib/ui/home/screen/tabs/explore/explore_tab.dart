import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/DI/di.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/movie_navigation.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/ui/browse/cubit/browse_cubit.dart';
import 'package:movie_app/ui/browse/cubit/browse_states.dart';
import 'package:movie_app/ui/movies/widget/movie_poster_card.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BrowseCubit>()..loadInitial(),
      child: const _BrowseTabView(),
    );
  }
}

class _BrowseTabView extends StatefulWidget {
  const _BrowseTabView();

  @override
  State<_BrowseTabView> createState() => _BrowseTabViewState();
}

class _BrowseTabViewState extends State<_BrowseTabView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        _scrollController.position.extentAfter > 380) {
      return;
    }
    context.read<BrowseCubit>().loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 10.h),
              child: Text(
                StringsManager.browse,
                style: TextStyle(
                  color: ColorsManager.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            BlocBuilder<BrowseCubit, BrowseStates>(
              builder: (context, state) {
                if (state is BrowseSuccessState) {
                  return Expanded(
                    child: Column(
                      children: [
                        _genreTabs(context, state),
                        SizedBox(height: 10.h),
                        Expanded(child: _movieGrid(context, state)),
                      ],
                    ),
                  );
                }

                if (state is BrowseFailureState) {
                  return Expanded(child: _failureView(context, state.message));
                }

                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.yellow,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _genreTabs(BuildContext context, BrowseSuccessState state) {
    final genres = [StringsManager.allGenres, ...state.genres];
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isAll = genre == StringsManager.allGenres;
          final selected = isAll
              ? state.selectedGenre == null
              : state.selectedGenre == genre;
          return ChoiceChip(
            label: Text(genre),
            selected: selected,
            showCheckmark: false,
            onSelected: (_) =>
                context.read<BrowseCubit>().selectGenre(isAll ? null : genre),
            selectedColor: ColorsManager.yellow,
            backgroundColor: ColorsManager.darkGrey,
            side: BorderSide.none,
            labelStyle: TextStyle(
              color: selected ? ColorsManager.black : ColorsManager.white,
              fontSize: 13.sp,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w),
          );
        },
      ),
    );
  }

  Widget _movieGrid(BuildContext context, BrowseSuccessState state) {
    if (state.movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AssetsManager.empty,
              height: 150.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 12.h),
            Text(
              StringsManager.noMoviesFound,
              style: TextStyle(color: ColorsManager.white, fontSize: 15.sp),
            ),
          ],
        ),
      );
    }

    final hasFooter = state.isLoadingMore || state.pageError != null;
    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(18.w, 4.h, 18.w, 100.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 0.54,
      ),
      itemCount: state.movies.length + (hasFooter ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.movies.length) {
          return _paginationFooter(context, state);
        }

        final movie = state.movies[index];
        return MoviePosterCard(
          movie: movie,
          onTap: movie.id == null
              ? null
              : () => MovieNavigation.openDetails(context, movie.id!),
        );
      },
    );
  }

  Widget _paginationFooter(BuildContext context, BrowseSuccessState state) {
    if (state.isLoadingMore) {
      return const Center(
        child: CircularProgressIndicator(color: ColorsManager.yellow),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.pageError ?? StringsManager.moviesServiceError,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorsManager.white.withValues(alpha: 0.75),
              fontSize: 12.sp,
            ),
          ),
          TextButton(
            onPressed: context.read<BrowseCubit>().loadNextPage,
            child: const Text(StringsManager.retry),
          ),
        ],
      ),
    );
  }

  Widget _failureView(BuildContext context, String message) {
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
              onPressed: context.read<BrowseCubit>().retry,
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
