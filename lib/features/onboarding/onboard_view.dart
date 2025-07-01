import 'package:flutter/material.dart';
import 'package:graduation/core/routes/app_routes.dart';

import 'model/onboard_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<OnboardingItem> onboardingData = [
    OnboardingItem(
      image: 'assets/images/on_board/on_board_1.png',
      title: 'AI-Powered Exams',
      description: 'Generate tests in seconds.',
      buttonText: 'Next',
    ),
    OnboardingItem(
      image: 'assets/images/on_board/on_board_2.png',
      title: 'Manual Creation',
      description: 'Customize your exams precisely.',
      buttonText: 'Next',
    ),
    OnboardingItem(
      image: 'assets/images/on_board/on_board_3.png',
      title: 'Track Performance',
      description: 'Monitor student progress.',
      buttonText: 'Get Started',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: PageView.builder(
          controller: _controller,
          itemCount: onboardingData.length,
          onPageChanged: (index) {
            setState(() => currentPage = index);
          },
          itemBuilder: (context, index) {
            final item = onboardingData[index];
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      if (index == 2) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(item.buttonText),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
