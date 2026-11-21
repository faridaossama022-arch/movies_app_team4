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
import 'package:movie_app/ui/register/cubit/register_cubit.dart';
import 'package:movie_app/ui/register/cubit/register_states.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passController;
  late TextEditingController confirmPassController;
  late TextEditingController phoneController;
  late PageController avatarController;
  int selectedAvatar = 4;
  String selectedLanguage = "en";
  List<String> avatars = [
    AssetsManager.avatar3,
    AssetsManager.avatar4,
    AssetsManager.avatar5,
    AssetsManager.avatar2,
    AssetsManager.avatar8,
    AssetsManager.avatar1,
    AssetsManager.avatar6,
    AssetsManager.avatar7,
    AssetsManager.avatar9,
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passController = TextEditingController();
    confirmPassController = TextEditingController();
    phoneController = TextEditingController();
    avatarController = PageController(
      viewportFraction: 0.34,
      initialPage: selectedAvatar,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    phoneController.dispose();
    avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegisterCubit>(),
      child: Scaffold(
        backgroundColor: ColorsManager.black,
        appBar: AppBar(
          backgroundColor: ColorsManager.black,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(RoutesManager.loginRoute);
            },
            icon: Icon(Icons.arrow_back, color: ColorsManager.yellow),
          ),
          title: Text(
            StringsManager.register,
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
                SizedBox(height: 9.h),
                SizedBox(
                  height: 161.h,
                  child: PageView.builder(
                    controller: avatarController,
                    itemCount: avatars.length,
                    onPageChanged: (index) {
                      setState(() {
                        selectedAvatar = index;
                      });
                    },
                    itemBuilder: (context, index) => buildAvatar(index),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  StringsManager.avatar,
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorsManager.white,
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: REdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      CustomField(
                        hint: StringsManager.name,
                        prefixPath: AssetsManager.name,
                        controller: nameController,
                        keyboard: TextInputType.name,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return StringsManager.nameEmpty;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
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
                      SizedBox(height: 24.h),
                      CustomField(
                        hint: StringsManager.confirmPassword,
                        prefixPath: AssetsManager.password,
                        controller: confirmPassController,
                        keyboard: TextInputType.visiblePassword,
                        isPassword: true,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return StringsManager.confirmPasswordEmpty;
                          }
                          if (value != passController.text) {
                            return StringsManager.passwordNotMatch;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                      CustomField(
                        hint: StringsManager.phoneNumber,
                        prefixPath: AssetsManager.phone,
                        controller: phoneController,
                        keyboard: TextInputType.phone,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return StringsManager.phoneEmpty;
                          }
                          if (value.length != 11) {
                            return StringsManager.phoneInvalid;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                      BlocListener<RegisterCubit, RegisterStates>(
                        listener: (context, state) {
                          if (state is RegisterLoadingState) {
                            DialogUtils.showLoadingDialog(context);
                          }
                          if (state is RegisterSuccessState) {
                            Navigator.of(context).pop();
                            SnackBar snackBar = SnackBar(content: Text(StringsManager.accountCreated));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            Navigator.of(context).pushReplacementNamed(RoutesManager.homeRoute);
                          }
                          if (state is RegisterFailureState) {
                            Navigator.of(context).pop();
                            DialogUtils.showMessageDialog(context: context, content: state.error);
                          }
                        },
                        child: Builder(
                          builder: (context) {
                            return CustomButton(
                              title: StringsManager.createAccount,
                              height: 56,
                              textStyle: GoogleFonts.roboto(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorsManager.black,
                              ),
                              onClick: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  context.read<RegisterCubit>().register(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passController.text,
                                    phone: phoneController.text,
                                    avatar: avatars[selectedAvatar],
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 17.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            StringsManager.alreadyHaveAccount,
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorsManager.white,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(RoutesManager.loginRoute);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              StringsManager.login,
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                color: ColorsManager.yellow,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAvatar(int index) {
    bool isSelected = index == selectedAvatar;
    return Center(
      child: Container(
        width: isSelected ? 150.w : 94.w,
        height: isSelected ? 161.h : 94.h,
        child: Image.asset(avatars[index], fit: BoxFit.contain),
      ),
    );
  }
}