import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/resources/app_constants.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/core/reusable_components/custom_button.dart';
import 'package:movie_app/core/reusable_components/custom_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      appBar: AppBar(
        backgroundColor: ColorsManager.black,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: ColorsManager.yellow),
        ),
        title: Text(
          StringsManager.forgetPasswordTitle,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: ColorsManager.yellow,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                AssetsManager.forgetPassword,
                width: 430.w,
                height: 430.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: REdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
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
                    SizedBox(height: 24.h),
                    CustomButton(
                      title: StringsManager.verifyEmail,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}