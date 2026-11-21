import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/routes_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed(
        FirebaseAuth.instance.currentUser != null
            ? RoutesManager.homeRoute
            : RoutesManager.onboardingRoute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Image.asset(AssetsManager.logo, width: 121.w, height: 118.h),
            Spacer(),
            Image.asset(
              AssetsManager.routeLogo,
              width: 180.w,
              height: 76.h,
              fit: BoxFit.cover,
              color: ColorsManager.yellow,
            ),
            Text(
              StringsManager.supervisedBy,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: ColorsManager.white,
              ),
            ),
            SizedBox(height: 22.h),
          ],
        ),
      ),
    );
  }
}