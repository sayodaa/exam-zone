import 'package:flutter/material.dart';
import 'package:graduation/core/common/under_build_screen.dart';
import 'package:graduation/core/routes/base_routes.dart';
import 'package:graduation/features/auth/presentation/screens/login_screen.dart';
import 'package:graduation/features/auth/presentation/screens/signup_screen.dart';
import 'package:graduation/features/home/presentation/views/home_screen.dart';
import 'package:graduation/features/home/presentation/views/main_view.dart';
import 'package:graduation/features/onboarding/onboard_view.dart';
import 'package:graduation/features/overwall/data/quation_model.dart';
import 'package:graduation/features/overwall/presentation/views/exam_screen.dart';
import 'package:graduation/features/overwall/presentation/views/create_exam.dart';
import 'package:graduation/features/overwall/presentation/views/exam_result2.dart';
import 'package:graduation/features/overwall/presentation/views/generate_quation.dart';
import 'package:graduation/features/overwall/presentation/views/overwall_screen.dart';
import 'package:graduation/features/profile/edit_profile.dart';
import 'package:graduation/features/profile/profile_screen.dart';
import 'package:graduation/features/settings/presentation/views/settings_screen.dart';
import 'package:graduation/features/splash/presentation/splash_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String onBoarding = '/onBoarding';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/editProfile';
  static const String settingsView = '/settings';
  static const String overWall = 'overWall';
  static const String examResultsStudentsScreen = '/examResultsStudentsScreen';
  static const String examScreen = '/examScreen';
  static const String generateQuestion = '/generateQuestion';
  static const String createExam = '/createExam';
  static const String mainV = '/mainV';
  static const String examResult2 = '/examResult2';
  static const String examResultStudentsScreen = '/examResultStudentsScreen';
  static Route<void> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onBoarding:
        return BaseRoute(page: const OnBoardingScreen());
      case splash:
        return BaseRoute(page: const SplashView());
      case mainV:
        return BaseRoute(page: const MainView());
      case profile:
        return BaseRoute(page: const ProfileScreen());
      case editProfile:
        return BaseRoute(page: const EditProfileScreen());
      case login:
        return BaseRoute(page: LoginScreen());
      case signUp:
        return BaseRoute(page: SignupScreen());
      case home:
        return BaseRoute(page: const HomeScreen());
      case settingsView:
        return BaseRoute(page: const SettingsScreen());
      case overWall:
        return BaseRoute(page: const ExamResultsScreen());
      case examResultsStudentsScreen:
        return BaseRoute(page: const ExamResultsStudentsScreen());
      case examScreen:
        return BaseRoute(
          page: ExamScreen(
            generatedQuestions: settings.arguments as List<QuestionModel>?,
          ),
        );
      case generateQuestion:
        return BaseRoute(page: const GenerateExamScreen());
      case createExam:
        return BaseRoute(page: const CreateExamScreen());
      default:
        return BaseRoute(page: const PageUnderBuildScreen());
    }
  }
}
