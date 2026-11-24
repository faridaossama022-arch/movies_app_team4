import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/core/DI/di.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/movie_navigation.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/ui/movies/widget/movie_poster_card.dart';

import 'search_cubit.dart';
import 'search_states.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 21.h, 16.w, 0),
              child: Container(
                height: 56.h,
                decoration: BoxDecoration(
                  color: ColorsManager.darkGrey,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: const Color(0xff777777),
                    width: 1.w,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: context.read<SearchCubit>().onQueryChanged,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(color: ColorsManager.white, fontSize: 14.sp),
                  cursorColor: ColorsManager.yellow,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: ColorsManager.white,
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: SvgPicture.asset(
                        AssetsManager.icon_serach,
                        width: 22.w,
                        height: 22.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _controller,
                      builder: (context, value, _) {
                        if (value.text.isEmpty) return const SizedBox.shrink();
                        return IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: ColorsManager.white,
                          ),
                          onPressed: () {
                            _controller.clear();
                            context.read<SearchCubit>().onQueryChanged('');
                          },
                        );
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 17.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchStates>(
                builder: (context, state) {
                  return switch (state) {
                    SearchInitialState() => const _EmptyView(),
                    SearchLoadingState() => const Center(
                      child: CircularProgressIndicator(
                        color: ColorsManager.yellow,
                      ),
                    ),
                    SearchFailureState() => _FailureView(
                      message: state.message,
                    ),
                    SearchSuccessState() =>
                      state.movies.isEmpty
                          ? const _EmptyView(
                              message: StringsManager.noMoviesFound,
                            )
                          : _ResultsGrid(state: state),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsGrid extends StatelessWidget {
  final SearchSuccessState state;

  const _ResultsGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(18.w, 4.h, 18.w, 100.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 0.54,
      ),
      itemCount: state.movies.length,
      itemBuilder: (context, index) {
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
}

class _EmptyView extends StatelessWidget {
  final String? message;

  const _EmptyView({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AssetsManager.empty, fit: BoxFit.contain),
          if (message != null) ...[
            SizedBox(height: 12.h),
            Text(
              message!,
              style: TextStyle(color: ColorsManager.white, fontSize: 15.sp),
            ),
          ],
        ],
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  final String message;

  const _FailureView({required this.message});

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
              onPressed: context.read<SearchCubit>().retry,
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
