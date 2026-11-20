import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/resources/app_constants.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/routes_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/core/reusable_components/custom_button.dart';
import 'package:movie_app/core/reusable_components/custom_field.dart';
import 'package:movie_app/core/reusable_components/language_switch.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passController;
  String selectedLanguage = "en";

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 19),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 67.h),
                Image.asset(AssetsManager.logo, width: 121.w, height: 118.h),
                SizedBox(height: 69.h),
                CustomField(
                  hint: StringsManager.email,
                  prefixPath: AssetsManager.email,
                  controller: emailController,
                  keyboard: TextInputType.emailAddress,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return StringsManager.emailEmpty;
                    }
                    if (!RegExp(AppConstants.emailRegex).hasMatch(value)) {
                      return StringsManager.emailInvalid;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 22.h),
                CustomField(
                  hint: StringsManager.password,
                  prefixPath: AssetsManager.password,
                  controller: passController,
                  keyboard: TextInputType.visiblePassword,
                  isPassword: true,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return StringsManager.passwordEmpty;
                    }
                    if (value.length < 8) {
                      return StringsManager.passwordShort;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 17.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(
                      StringsManager.forgetPassword,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorsManager.yellow,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 33.h),
                CustomButton(
                  title: StringsManager.login,
                  height: 56,
                  textStyle: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorsManager.black,
                  ),
                  onClick: () {
                    if (formKey.currentState?.validate() ?? false) {}
                  },
                ),
                SizedBox(height: 22.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringsManager.dontHaveAccount,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorsManager.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesManager.registerRoute);
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        StringsManager.createOne,
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorsManager.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 93.w, height: 1, color: ColorsManager.yellow),
                    SizedBox(width: 11.w),
                    Text(
                      StringsManager.or,
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorsManager.yellow,
                      ),
                    ),
                    SizedBox(width: 11.w),
                    Container(width: 93.w, height: 1, color: ColorsManager.yellow),
                  ],
                ),
                SizedBox(height: 28.h),
                CustomButton(
                  title: StringsManager.loginWithGoogle,
                  height: 56,
                  iconPath: AssetsManager.google,
                  textStyle: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorsManager.black,
                  ),
                  onClick: () {},
                ),
                SizedBox(height: 34.h),
                LanguageSwitch(
                  selectedLanguage: selectedLanguage,
                  onChanged: (languageCode) {
                    setState(() {
                      selectedLanguage = languageCode;
                    });
                  },
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}