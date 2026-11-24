import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/DI/di.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/movie_navigation.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/ui/browse/cubit/browse_cubit.dart';
import 'package:movie_app/ui/browse/cubit/browse_states.dart';
import 'package:movie_app/ui/movies/widget/movie_poster_card.dart';


class CategoryMoviesScreen extends StatelessWidget {
  final String genre;

  const CategoryMoviesScreen({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BrowseCubit>()..selectGenre(genre),
      child: _CategoryView(genre: genre),
    );
  }
}

class _CategoryView extends StatefulWidget {
  final String genre;

  const _CategoryView({required this.genre});

  @override
  State<_CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<_CategoryView> {
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
      appBar: AppBar(
        backgroundColor: ColorsManager.black,
        foregroundColor: ColorsManager.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          widget.genre,
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<BrowseCubit, BrowseStates>(
        builder: (context, state) {
          if (state is BrowseFailureState) {
            return _failure(context, state.message);
          }
          if (state is! BrowseSuccessState) {
            return const Center(
              child: CircularProgressIndicator(color: ColorsManager.yellow),
            );
          }
          if (state.movies.isEmpty) {
            return Center(
              child: Text(
                StringsManager.noMoviesFound,
                style: TextStyle(color: ColorsManager.white, fontSize: 15.sp),
              ),
            );
          }

          final hasFooter = state.isLoadingMore || state.pageError != null;
          return GridView.builder(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 40.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14.w,
              mainAxisSpacing: 14.h,
              childAspectRatio: 0.54,
            ),
            itemCount: state.movies.length + (hasFooter ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.movies.length) {
                return state.isLoadingMore
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorsManager.yellow,
                        ),
                      )
                    : Center(
                        child: TextButton(
                          onPressed: context.read<BrowseCubit>().loadNextPage,
                          child: const Text(StringsManager.retry),
                        ),
                      );
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
        },
      ),
    );
  }

  Widget _failure(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          Text("c")
        ],
      ),
    );
  }
}
