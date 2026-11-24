import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/core/DI/di.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/dialog_utils.dart';
import 'package:movie_app/core/resources/routes_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/core/reusable_components/custom_button.dart';
import 'package:movie_app/core/reusable_components/custom_field.dart';
import 'package:movie_app/data/model/user_model.dart';
import 'package:movie_app/ui/update_profile/cubit/update_profile_cubit.dart';
import 'package:movie_app/ui/update_profile/cubit/update_profile_states.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserModel user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  int selectedAvatar = 7;
  List<String> avatars = [
    AssetsManager.avatar1,
    AssetsManager.avatar2,
    AssetsManager.avatar3,
    AssetsManager.avatar4,
    AssetsManager.avatar5,
    AssetsManager.avatar6,
    AssetsManager.avatar7,
    AssetsManager.avatar8,
    AssetsManager.avatar9,
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    phoneController = TextEditingController(text: widget.user.phone);
    if (avatars.contains(widget.user.avatar)) {
      selectedAvatar = avatars.indexOf(widget.user.avatar!);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UpdateProfileCubit>(),
      child: Scaffold(
        backgroundColor: ColorsManager.black,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: ColorsManager.black,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, color: ColorsManager.yellow),
          ),
          title: Text(
            StringsManager.pickAvatar,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: ColorsManager.yellow,
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 37.h),
                InkWell(
                  onTap: () {
                    showAvatarsSheet();
                  },
                  child: Image.asset(avatars[selectedAvatar], width: 150.r, height: 150.r),
                ),
                SizedBox(height: 35.h),
                CustomField(
                  hint: StringsManager.name,
                  prefixPath: AssetsManager.name,
                  controller: nameController,
                  keyboard: TextInputType.name,
                  fontSize: 20,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return StringsManager.nameEmpty;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                CustomField(
                  hint: StringsManager.phoneNumber,
                  prefixPath: AssetsManager.phone,
                  controller: phoneController,
                  keyboard: TextInputType.phone,
                  fontSize: 20,
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
                SizedBox(height: 29.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: REdgeInsets.only(left: 5),
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
                        StringsManager.resetPassword,
                        style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorsManager.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                BlocListener<UpdateProfileCubit, UpdateProfileStates>(
                  listener: (context, state) {
                    if (state is UpdateProfileLoadingState) {
                      DialogUtils.showLoadingDialog(context);
                    } else if (state is UpdateProfileSuccessState) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else if (state is DeleteAccountSuccessState) {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesManager.loginRoute,
                            (route) => false,
                      );
                    } else if (state is UpdateProfileFailureState) {
                      Navigator.pop(context);
                      DialogUtils.showMessageDialog(context: context, content: state.error);
                    }
                  },
                  child: Builder(
                    builder: (context) => Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsManager.red,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                            ),
                            onPressed: () {
                              context.read<UpdateProfileCubit>().deleteAccount();
                            },
                            child: Text(
                              StringsManager.deleteAccount,
                              style: GoogleFonts.roboto(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorsManager.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 19.h),
                        CustomButton(
                          title: StringsManager.updateData,
                          height: 56,
                          textStyle: GoogleFonts.roboto(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorsManager.black,
                          ),
                          onClick: () {
                            if (formKey.currentState?.validate() ?? false) {
                              context.read<UpdateProfileCubit>().updateUser(
                                name: nameController.text,
                                phone: phoneController.text,
                                avatar: avatars[selectedAvatar],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 33.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showAvatarsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: REdgeInsets.only(left: 16, right: 16, bottom: 17),
        child: Container(
          padding: REdgeInsets.symmetric(horizontal: 18, vertical: 19),
          decoration: BoxDecoration(
            color: ColorsManager.darkGrey,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: avatars.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 19.h,
              crossAxisSpacing: 19.w,
              childAspectRatio: 108 / 105,
            ),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(() {
                  selectedAvatar = index;
                });
                Navigator.of(context).pop();
              },
              child: Container(
                padding: REdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: index == selectedAvatar
                      ? ColorsManager.yellow.withValues(alpha: 0.56)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: ColorsManager.yellow, width: 1),
                ),
                child: Image.asset(avatars[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}