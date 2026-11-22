import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/ui/home/widget/movie_category_section.dart';

import '../../../model/movie_list.dart';
import '../widget/movie_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: NavigationBar(
            height: 75.h,
            backgroundColor: ColorsManager.darkGrey,
            surfaceTintColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            elevation: 0,
            destinations: [
              NavigationDestination(
                icon: SvgPicture.asset(
                  AssetsManager.icon_home,
                  colorFilter: ColorFilter.mode(
                    ColorsManager.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "",
                selectedIcon: SvgPicture.asset(
                  AssetsManager.icon_home,
                  colorFilter: ColorFilter.mode(
                    ColorsManager.yellow,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  AssetsManager.icon_serach,
                  colorFilter: ColorFilter.mode(
                    ColorsManager.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "",
                selectedIcon: SvgPicture.asset(
                  AssetsManager.icon_serach,
                  colorFilter: ColorFilter.mode(
                    ColorsManager.yellow,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  AssetsManager.icon_explore,
                  colorFilter: ColorFilter.mode(
                    ColorsManager.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "",
                selectedIcon: SvgPicture.asset(
                  AssetsManager.icon_explore,
                  colorFilter: ColorFilter.mode(
                    ColorsManager.yellow,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  AssetsManager.icon_profile,
                  colorFilter: ColorFilter.mode(
                    ColorsManager.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "",
                selectedIcon: SvgPicture.asset(
                  AssetsManager.icon_profile,
                  colorFilter: ColorFilter.mode(
                    ColorsManager.yellow,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: ColorsManager.black,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Colors.black,
                              Colors.transparent,
                            ],
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
                    Center(
                      child: MoviesSlider(),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        AssetsManager.wachtnow,
                        width: 354.w,
                        height: 146.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.h),
            MovieCategorySection(
              title: 'Action',
              movies: MovieModel.movies,
              onSeeMore: () {},
            ),
          ],
        ),
      ),
    );
  }
}