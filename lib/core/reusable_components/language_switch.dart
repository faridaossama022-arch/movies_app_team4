import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';

class LanguageSwitch extends StatelessWidget {
  final String selectedLanguage;
  final void Function(String) onChanged;

  const LanguageSwitch({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 91.w,
      height: 38.h,
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManager.yellow, width: 2),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildFlag(AssetsManager.us, "en"),
          buildFlag(AssetsManager.eg, "ar"),
        ],
      ),
    );
  }

  Widget buildFlag(String path, String languageCode) {
    return InkWell(
      onTap: () {
        onChanged(languageCode);
      },
      child: Container(
        width: 34.r,
        height: 34.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: languageCode == selectedLanguage
              ? Border.all(color: ColorsManager.yellow, width: 3.5)
              : null,
        ),
        child: SvgPicture.asset(path, width: 27.r, height: 27.r),
      ),
    );
  }
}