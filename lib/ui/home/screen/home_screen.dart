import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: Center(
        child: Text(
          StringsManager.home,
          style: GoogleFonts.roboto(
            fontSize: 24.sp,
            fontWeight: FontWeight.w400,
            color: ColorsManager.white,
          ),
        ),
      ),
    );
  }
}