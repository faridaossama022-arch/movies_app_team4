import 'package:flutter/material.dart';
import 'package:movie_app/core/resources/assets_manager.dart';
import 'package:movie_app/core/resources/colors_manager.dart';
import 'package:movie_app/core/resources/strings_manager.dart';
import 'package:movie_app/core/resources/routes_manager.dart';
import 'package:movie_app/model/onboarding_model.dart';
import 'package:movie_app/ui/onboarding/widgets/onboarding_first_item.dart';
import 'package:movie_app/ui/onboarding/widgets/onboarding_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController controller = PageController();

  List<OnBoardingModel> pages = [
    OnBoardingModel(
      image: AssetsManager.onBoarding2,
      title: StringsManager.onboardingTitle2,
      description: StringsManager.onboardingDesc2,
      color: ColorsManager.onBoarding2,
    ),
    OnBoardingModel(
      image: AssetsManager.onBoarding3,
      title: StringsManager.onboardingTitle3,
      description: StringsManager.onboardingDesc3,
      color: ColorsManager.onBoarding3,
    ),
    OnBoardingModel(
      image: AssetsManager.onBoarding4,
      title: StringsManager.onboardingTitle4,
      description: StringsManager.onboardingDesc4,
      color: ColorsManager.onBoarding4,
    ),
    OnBoardingModel(
      image: AssetsManager.onBoarding5,
      title: StringsManager.onboardingTitle5,
      description: StringsManager.onboardingDesc5,
      color: ColorsManager.onBoarding5,
    ),
    OnBoardingModel(
      image: AssetsManager.onBoarding6,
      title: StringsManager.onboardingTitle6,
      color: ColorsManager.onBoarding6,
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void goNext() {
    controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void goBack() {
    controller.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void finish() {
      Navigator.pushReplacementNamed(context, RoutesManager.loginRoute);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: PageView.builder(
        controller: controller,
        itemCount: pages.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return OnBoardingFirstItem(onClick: goNext);
          }
          return OnBoardingItem(
            model: pages[index - 1],
            showBack: index > 1,
            isLast: index == pages.length,
            onNext: index == pages.length ? finish : goNext,
            onBack: goBack,
          );
        },
      ),
    );
  }
}