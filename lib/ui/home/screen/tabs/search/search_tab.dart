
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController =
  TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search Field
            Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 21.h,
              ),
              child: Container(
                height: 56.h,
                decoration: BoxDecoration(
                  color: const Color(0xff282A28),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: const Color(0xff777777),
                    width: 1.w,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  style: TextStyle(
                    color: ColorsManager.white,
                    fontSize: 14.sp,
                  ),
                  cursorColor: ColorsManager.yellow,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: ColorsManager.white,
                      fontSize: 14.sp,
                    ),

                    // SVG Search Icon
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: SvgPicture.asset(
                        AssetsManager.icon_serach,
                        width: 22.w,
                        height: 22.h,
                        fit: BoxFit.contain,
                      ),
                    ),

                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 17.h,
                    ),
                  ),
                ),
              ),
            ),

            // Empty Search Image
            Expanded(
              child: Center(
                child: Image.asset(
                  AssetsManager.empty,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
