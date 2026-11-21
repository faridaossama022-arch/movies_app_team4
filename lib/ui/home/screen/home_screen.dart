import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/routes_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/core/reusable_components/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StringsManager.home,
              style: GoogleFonts.roboto(
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                color: ColorsManager.white,
              ),
            ),
            SizedBox(height: 24.h),
            CustomButton(title: "Logout", onClick: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, RoutesManager.loginRoute);
            },)
          ],
        ),
      ),
    );
  }
}