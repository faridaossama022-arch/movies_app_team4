import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/core/reusable_components/custom_button.dart';

class OnBoardingFirstItem extends StatelessWidget {
  final void Function() onClick;

  const OnBoardingFirstItem({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsManager.onBoarding1),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 16, vertical: 33),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorsManager.black.withValues(alpha: 0),
              ColorsManager.black,
            ],
            stops: [0.2, 0.7],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              StringsManager.onboardingTitle1,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 36.sp,
                fontWeight: FontWeight.w500,
                color: ColorsManager.white,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              StringsManager.onboardingDesc1,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                color: ColorsManager.white.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 24.h),
            CustomButton(title: StringsManager.exploreNow, onClick: onClick),
          ],
        ),
      ),
    );
  }
}