import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/movie_navigation.dart';
import 'package:movie_app/core/resources/routes_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/core/reusable_components/custom_button.dart';
import 'package:movie_app/data/model/saved_movie_model.dart';
import 'package:movie_app/data/model/yts_movie_model.dart';
import 'package:movie_app/ui/home/screen/tabs/profile/cubit/profile_cubit.dart';
import 'package:movie_app/ui/home/screen/tabs/profile/cubit/profile_states.dart';
import 'package:movie_app/ui/movies/widget/movie_poster_card.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorsManager.black,
        body: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            if (state is ProfileFailureState) {
              return Center(
                child: Text(
                  state.error,
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorsManager.white,
                  ),
                ),
              );
            }
            if (state is! ProfileSuccessState) {
              return Center(
                child: CircularProgressIndicator(color: ColorsManager.yellow),
              );
            }
            return Column(
              children: [
                Container(
                  color: ColorsManager.lightBlack,
                  child: Column(
                    children: [
                      SizedBox(height: 52.h),
                      Padding(
                        padding: REdgeInsets.only(left: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  state.user.avatar ?? AssetsManager.avatar8,
                                  width: 118.r,
                                  height: 118.r,
                                ),
                                SizedBox(height: 15.h),
                                Text(
                                  state.user.name ?? "",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorsManager.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 46.w),
                            Padding(
                              padding: REdgeInsets.only(top: 34),
                              child: Column(
                                children: [
                                  Text(
                                    state.watchList.length.toString(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorsManager.white,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    StringsManager.wishList,
                                    style: GoogleFonts.roboto(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorsManager.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 38.w),
                            Padding(
                              padding: REdgeInsets.only(top: 34),
                              child: Column(
                                children: [
                                  Text(
                                    state.history.length.toString(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorsManager.white,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    StringsManager.history,
                                    style: GoogleFonts.roboto(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorsManager.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 23.h),
                      Padding(
                        padding: REdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 253.w,
                              child: CustomButton(
                                title: StringsManager.editProfile,
                                height: 56,
                                textStyle: GoogleFonts.roboto(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w400,
                                  color: ColorsManager.black,
                                ),
                                onClick: () async {
                                  ProfileCubit cubit = context.read<ProfileCubit>();
                                  await Navigator.pushNamed(context, RoutesManager.updateProfileRoute, arguments: state.user);
                                  cubit.getProfile();
                                },
                              ),
                            ),
                            SizedBox(width: 10.w),
                            SizedBox(
                              width: 135.w,
                              height: 56.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsManager.red,
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacementNamed(context, RoutesManager.loginRoute);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      StringsManager.exit,
                                      style: GoogleFonts.roboto(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorsManager.white,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(Icons.logout, color: ColorsManager.white, size: 24.r),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      TabBar(
                        indicatorColor: ColorsManager.yellow,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerHeight: 0,
                        labelColor: ColorsManager.white,
                        unselectedLabelColor: ColorsManager.white,
                        tabs: [
                          Tab(
                            height: 78.h,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 42.r,
                                  height: 42.r,
                                  child: Center(
                                    child: SvgPicture.asset(AssetsManager.watchList, width: 29.r, height: 16.r),
                                  ),
                                ),
                                Text(
                                  StringsManager.watchList,
                                  style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            height: 78.h,
                            child: Column(
                              children: [
                                SvgPicture.asset(AssetsManager.history, width: 42.r, height: 42.r),
                                Text(
                                  StringsManager.history,
                                  style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      buildMoviesGrid(context, state.watchList),
                      buildMoviesGrid(context, state.history),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildMoviesGrid(BuildContext context, List<SavedMovieModel> movies) {
    if (movies.isEmpty) {
      return Center(child: Image.asset(AssetsManager.empty));
    }
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 100.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 0.54,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        SavedMovieModel movie = movies[index];
        return MoviePosterCard(
          movie: YtsMovieModel(
            id: movie.id,
            title: movie.title ?? "",
            year: null,
            rating: movie.rating,
            runtime: null,
            genres: [],
            summary: null,
            posterImage: movie.poster,
            backgroundImage: null,
            trailerCode: null,
            likeCount: null,
            screenshots: [],
            cast: [],
          ),
          onTap: () async {
            ProfileCubit cubit = context.read<ProfileCubit>();
            await MovieNavigation.openDetails(context, movie.id!);
            cubit.getProfile();
          },
        );
      },
    );
  }
}