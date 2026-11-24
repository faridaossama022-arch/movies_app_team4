import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/DI/di.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/core/resources/my_bloc_observer.dart';
import 'package:movie_app/core/resources/routes_manager.dart';
import 'package:movie_app/ui/movie_details/cubit/movie_details_cubit.dart';
import 'package:movie_app/ui/movie_details/screen/movie_details_screen.dart';
import 'package:movie_app/firebase_options.dart';
import 'package:movie_app/ui/category_movies/category_movies_screen.dart';
import 'package:movie_app/ui/forget_password/screen/forget_password_screen.dart';
import 'package:movie_app/ui/home/screen/home_screen.dart';
import 'package:movie_app/ui/login/screen/login_screen.dart';
import 'package:movie_app/ui/onboarding/screen/onboarding_screen.dart';
import 'package:movie_app/ui/register/screen/register_screen.dart';
import 'package:movie_app/ui/splash/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = MyBlocObserver();
  configureDependencies();
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
          RoutesManager.homeRoute: (_) => HomeScreen(),
          RoutesManager.categoryMoviesRoute: (context) {
            final genre = ModalRoute.of(context)?.settings.arguments;
            return CategoryMoviesScreen(genre: genre is String ? genre : '');
          },
          RoutesManager.movieDetailsRoute: (context) {
            final movieId = ModalRoute.of(context)?.settings.arguments;
            if (movieId is! int) {
              return const Scaffold(
                body: Center(child: Text(StringsManager.movieNotFound)),
              );
            }
            return BlocProvider(
              create: (_) => getIt<MovieDetailsCubit>()..loadMovie(movieId),
              child: const MovieDetailsScreen(),
            );
          },
        },
        initialRoute: RoutesManager.splashRoute,
      ),
    );
  }
}
