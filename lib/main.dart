import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/resources/routes_manager.dart';
import 'package:movie_app/ui/forget_password/screen/forget_password_screen.dart';
import 'package:movie_app/ui/login/screen/login_screen.dart';
import 'package:movie_app/ui/onboarding/screen/onboarding_screen.dart';
import 'package:movie_app/ui/register/screen/register_screen.dart';
import 'package:movie_app/ui/splash/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: "Movie App",
        debugShowCheckedModeBanner: false,
        routes: {
          RoutesManager.splashRoute: (_) => SplashScreen(),
          RoutesManager.onboardingRoute: (_) => OnboardingScreen(),
          RoutesManager.loginRoute: (_) => LoginScreen(),
          RoutesManager.registerRoute: (_) => RegisterScreen(),
          RoutesManager.forgetPasswordRoute: (_) => ForgetPasswordScreen(),
        },
        initialRoute: RoutesManager.splashRoute,
      ),
    );
  }
}