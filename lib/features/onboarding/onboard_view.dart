import 'package:flutter/material.dart';
import 'package:graduation/core/extensions/context_extension.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/routes/app_routes.dart';
import 'package:graduation/core/services/shared_pref/pref_keys.dart';
import 'package:graduation/core/services/shared_pref/shared_pref.dart';
import 'package:graduation/core/styles/app_images.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'model/onboard_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
   bool isLast = false;

  void submit() async {
    await SharedPref().setBoolean(PrefKeys.onBoarding, true).then((value) {
      if (mounted) {
        context.pushNamedAndRemoveUntil(AppRoutes.login);
      }
    });
  }
  List<OnboardingItem> get onboardingDark => [
    OnboardingItem(
      image: AppImages.onBoard1Dark,
      title: context.translate(LangKeys.onboardTitle1),
      description: context.translate(LangKeys.onboardBody1),
    ),
    OnboardingItem(
      image: AppImages.onBoard2Dark,
      title: context.translate(LangKeys.onboardTitle2),
      description: context.translate(LangKeys.onboardBody2),
    ),
    OnboardingItem(
      image: AppImages.onBoard3Dark,
      title: context.translate(LangKeys.onboardTitle3),
      description: context.translate(LangKeys.onboardBody3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              submit();
            },
            child: Text(
              context.translate(LangKeys.skip),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics: const BouncingScrollPhysics(),

                itemCount: onboardingDark.length,
                onPageChanged: (index) {
                  if (index == onboardingDark.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) {
                  return buildBoard(onboardingDark[index]);
                },
              ),
            ),
            SizedBox(height: 15),
            SmoothPageIndicator(
              controller: _controller,
              count: onboardingDark.length,
              effect: WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Colors.blue,
                dotHeight: 10,
                dotWidth: 10,
                spacing: 5,
                type: WormType.thin,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () {
                  if (isLast) {
                    submit();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  isLast
                      ? context.translate(LangKeys.getStarted)
                      : context.translate(LangKeys.next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildBoard(OnboardingItem item) {
    return Column(
      children: [
        Expanded(child: Image.asset(item.image)),
        const SizedBox(height: 20),
        Text(
          item.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          item.description,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }
}
