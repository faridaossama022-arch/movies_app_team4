import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/core/reusable_components/custom_button.dart';
import 'package:movie_app/model/onboarding_model.dart';

class OnBoardingItem extends StatelessWidget {
  final OnBoardingModel model;
  final bool showBack;
  final bool isLast;
  final void Function() onNext;
  final void Function() onBack;

  const OnBoardingItem({
    super.key,
    required this.model,
    required this.showBack,
    required this.isLast,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(model.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [model.color.withValues(alpha: 0), model.color],
            stops: [0.2, 0.7],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              padding: isLast
                  ? REdgeInsets.only(left: 16, right: 16, top: 26, bottom: 17)
                  : REdgeInsets.symmetric(horizontal: 16, vertical: 32),
              decoration: BoxDecoration(
                color: ColorsManager.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorsManager.white,
                    ),
                  ),
                  Visibility(
                    visible: model.description != null,
                    child: Padding(
                      padding: REdgeInsets.only(top: 16),
                      child: Text(
                        model.description ?? "",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorsManager.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isLast ? 27.h : 16.h),
                  CustomButton(
                    title: isLast ? StringsManager.finish : StringsManager.next,
                    onClick: onNext,
                  ),
                  Visibility(
                    visible: showBack,
                    child: Padding(
                      padding: REdgeInsets.only(top: isLast ? 14 : 16),
                      child: CustomButton(
                        title: StringsManager.back,
                        onClick: onBack,
                        backgroundColor: Colors.transparent,
                        textColor: ColorsManager.yellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}