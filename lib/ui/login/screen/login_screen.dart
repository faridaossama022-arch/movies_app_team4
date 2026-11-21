import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/DI/di.dart';
import 'package:movie_app/core/resources/app_constants.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/dialog_utils.dart';
import 'package:movie_app/core/resources/routes_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/core/reusable_components/custom_button.dart';
import 'package:movie_app/core/reusable_components/custom_field.dart';
import 'package:movie_app/core/reusable_components/language_switch.dart';
import 'package:movie_app/ui/login/cubit/login_cubit.dart';
import 'package:movie_app/ui/login/cubit/login_states.dart';

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
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: Scaffold(
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
                      onPressed: () {
                        Navigator.of(context).pushNamed(RoutesManager.forgetPasswordRoute);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
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
                  BlocListener<LoginCubit, LoginStates>(
                    listener: (context, state) {
                      if (state is LoginLoadingState) {
                        DialogUtils.showLoadingDialog(context);
                      }
                      if (state is LoginSuccessState) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed(RoutesManager.homeRoute);
                      }
                      if (state is LoginFailureState) {
                        Navigator.of(context).pop();
                        DialogUtils.showMessageDialog(context: context, content: state.error);
                      }
                    },
                    child: Builder(
                      builder: (context) {
                        return CustomButton(
                          title: StringsManager.login,
                          height: 56,
                          textStyle: GoogleFonts.roboto(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorsManager.black,
                          ),
                          onClick: () {
                            if (formKey.currentState?.validate() ?? false) {
                              context.read<LoginCubit>().login(
                                email: emailController.text,
                                password: passController.text,
                              );
                            }
                          },
                        );
                      },
                    ),
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
                          Navigator.of(context).pushReplacementNamed(RoutesManager.registerRoute);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
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
      ),
    );
  }
}