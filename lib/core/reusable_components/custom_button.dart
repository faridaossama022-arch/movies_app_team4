import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/resources/colors_manager.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final void Function() onClick;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final TextStyle? textStyle;
  final String? iconPath;

  const CustomButton({
    super.key,
    required this.title,
    required this.onClick,
    this.backgroundColor = ColorsManager.yellow,
    this.textColor = ColorsManager.black,
    this.height = 55,
    this.textStyle,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          minimumSize: Size(double.infinity, height.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            side: BorderSide(color: ColorsManager.yellow, width: 2),
          ),
        ),
        onPressed: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: iconPath != null,
              child: Padding(
                padding: REdgeInsets.only(right: 11),
                child: SvgPicture.asset(
                  iconPath ?? "",
                  width: 26.r,
                  height: 26.r,
                ),
              ),
            ),
            Text(
              title,
              style: textStyle ??
                  GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}