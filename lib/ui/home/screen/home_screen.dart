import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/ui/home/screen/tabs/explore/explore_tab.dart';
import 'package:movie_app/ui/home/screen/tabs/home/home_tab.dart';
import 'package:movie_app/ui/home/screen/tabs/profile/profile_tab.dart';
import 'package:movie_app/ui/home/screen/tabs/search/search_tab.dart';
import 'package:movie_app/ui/home/widget/movie_category_section.dart';

import '../../../model/movie_list.dart';
import '../widget/movie_item.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedindex=0;
  List<Widget> tabs=[
    HomeTab(),SearchScreen(),ExploreTab(),ProfileTab()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child:
          NavigationBar(
            selectedIndex: selectedindex,
            onDestinationSelected: (value) {
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
      body: tabs[selectedindex]
    );
  }
}