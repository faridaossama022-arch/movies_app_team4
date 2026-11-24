import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/core/DI/di.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/ui/home/screen/tabs/explore/explore_tab.dart';
import 'package:movie_app/ui/home/screen/tabs/home/home_cubit.dart';
import 'package:movie_app/ui/home/screen/tabs/home/home_tab.dart';
import 'package:movie_app/ui/home/screen/tabs/profile/profile_tab.dart';
import 'package:movie_app/ui/home/screen/tabs/search/search_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedindex=0;
  late final HomeCubit _homeCubit = getIt<HomeCubit>()..loadHome();
  final List<Widget> tabs=[
    const HomeTab(),const SearchScreen(),const ExploreTab(),const ProfileTab()
  ];

  @override
  void dispose() {
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeCubit,
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child:
              NavigationBar(
                selectedIndex: selectedindex,
                onDestinationSelected: (value) {
                  // رجوع للهوم من تاب تاني => نغيّر النوع المعروض
                  if (value == 0 && selectedindex != 0) {
                    _homeCubit.changeGenre();
                  }
                  setState(() {
                    selectedindex = value;
                  });
                },
                height: 58.h,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                backgroundColor: ColorsManager.darkGrey,
                surfaceTintColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                elevation: 0,
                destinations: [
                  NavigationDestination(
                    icon: Padding(
                      padding: EdgeInsets.only(top: 7.h),
                      child: SvgPicture.asset(
                        AssetsManager.icon_home,
                        colorFilter: ColorFilter.mode(
                          ColorsManager.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    selectedIcon: Padding(
                      padding: EdgeInsets.only(top: 7.h),
                      child: SvgPicture.asset(
                        AssetsManager.icon_home,
                        colorFilter: ColorFilter.mode(
                          ColorsManager.yellow,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: Padding(
                      padding: EdgeInsets.only(top: 7.h),
                      child: SvgPicture.asset(
                        AssetsManager.icon_serach,
                        colorFilter: ColorFilter.mode(
                          ColorsManager.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    selectedIcon: Padding(
                      padding: EdgeInsets.only(top: 7.h),
                      child: SvgPicture.asset(
                        AssetsManager.icon_serach,
                        colorFilter: ColorFilter.mode(
                          ColorsManager.yellow,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: Padding(
                      padding: EdgeInsets.only(top: 7.h),
                      child: SvgPicture.asset(
                        AssetsManager.icon_explore,
                        colorFilter: ColorFilter.mode(
                          ColorsManager.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    selectedIcon: Padding(
                      padding: EdgeInsets.only(top: 7.h),
                      child: SvgPicture.asset(
                        AssetsManager.icon_explore,
                        colorFilter: ColorFilter.mode(
                          ColorsManager.yellow,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: Padding(
                      padding: EdgeInsets.only(top: 7.h),
                      child: SvgPicture.asset(
                        AssetsManager.icon_profile,
                        colorFilter: ColorFilter.mode(
                          ColorsManager.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    selectedIcon: Padding(
                      padding: EdgeInsets.only(top: 7.h),
                      child: SvgPicture.asset(
                        AssetsManager.icon_profile,
                        colorFilter: ColorFilter.mode(
                          ColorsManager.yellow,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                ],
              )

          ),
        ),
        body: IndexedStack(index: selectedindex, children: tabs)
    ));
  }
}