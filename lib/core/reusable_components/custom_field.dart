import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';

class CustomField extends StatefulWidget {
  final String hint;
  final String prefixPath;
  final TextEditingController controller;
  final TextInputType keyboard;
  final String? Function(String?) validation;
  final bool isPassword;

  const CustomField({
    super.key,
    required this.hint,
    required this.prefixPath,
    required this.controller,
    required this.keyboard,
    required this.validation,
    this.isPassword = false,
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool visibleOff = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboard,
      validator: widget.validation,
      obscureText: widget.isPassword ? visibleOff : false,
      cursorColor: ColorsManager.yellow,
      style: GoogleFonts.roboto(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: ColorsManager.white,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorsManager.darkGrey,
        hintText: widget.hint,
        hintStyle: GoogleFonts.roboto(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: ColorsManager.white,
        ),
        contentPadding: REdgeInsets.symmetric(vertical: 18),
        prefixIcon: Padding(
          padding: REdgeInsets.only(left: 19, right: 9),
          child: SvgPicture.asset(
            widget.prefixPath,
            width: 31.r,
            height: 30.r,
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          maxWidth: 59.r,
          maxHeight: 30.r,
        ),
        suffixIcon: widget.isPassword
            ? Padding(
          padding: REdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              setState(() {
                visibleOff = !visibleOff;
              });
            },
            icon: visibleOff
                ? SvgPicture.asset(
              AssetsManager.eyeoff,
              width: 30.r,
              height: 30.r,
            )
                : Icon(
              Icons.visibility_outlined,
              color: ColorsManager.white,
              size: 30.r,
            ),
          ),
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: ColorsManager.darkGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: ColorsManager.darkGrey, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: ColorsManager.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: ColorsManager.red, width: 1),
        ),
      ),
    );
  }
}