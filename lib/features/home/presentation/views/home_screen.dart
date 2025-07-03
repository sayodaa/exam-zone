import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/animations/animate_do.dart';
import 'package:graduation/core/common/widgets/custom_app_bar.dart';
import 'package:graduation/core/language/app_localizations.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/routes/app_routes.dart';
import 'package:graduation/core/styles/app_images.dart';
import 'package:graduation/core/styles/styles.dart';
import 'package:graduation/features/home/presentation/widgets/build_option_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppColorsStyles.defaultPadding.w,
            vertical: AppColorsStyles.defaultPadding.h * 0.5, // Approx 8.h
          ),
          child: OrientationBuilder(
            builder: (context, orientation) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(text: AppLocalizations.of(context)!.translate(LangKeys.appName)!),
                    SizedBox(height: AppColorsStyles.defaultPadding.h * 0.75), // Approx 12.h
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.count(
                          crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: AppColorsStyles.defaultPadding.h * 0.75, // Approx 12.h
                          crossAxisSpacing: AppColorsStyles.defaultPadding.w * 0.75, // Approx 12.w
                          childAspectRatio: orientation == Orientation.portrait ? 3.5 : 2.5,
                          children: [
                            CustomFadeInDown(
                              duration: 700,
                              child: BuildOptionCard(
                                title: AppLocalizations.of(context)!.translate(LangKeys.createAiExam),
                                subtitle: AppLocalizations.of(context)!.translate(LangKeys.createAiExamSubtitle),
                                imagePath: AppImages.logo, // Suggest unique image
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoutes.generateQuestion);
                                },
                              ),
                            ),
                            CustomFadeInUp(
                              duration: 700,
                              child: BuildOptionCard(
                                title: AppLocalizations.of(context)!.translate(LangKeys.createManualExam),
                                subtitle: AppLocalizations.of(context)!.translate(LangKeys.createManualExamSubtitle),
                                imagePath: AppImages.logo, // Suggest unique image
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoutes.createExam);
                                },
                              ),
                            ),
                            CustomFadeInDown(
                              duration: 700,
                              child: BuildOptionCard(
                                title: AppLocalizations.of(context)!.translate(LangKeys.examTitle),
                                subtitle: AppLocalizations.of(context)!.translate(LangKeys.myExamsSubtitle),
                                imagePath: AppImages.logo, // Suggest unique image
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoutes.examResultsStudentsScreen);
                                },
                              ),
                            ),
                            CustomFadeInUp(
                              duration: 700,
                              child: BuildOptionCard(
                                title: AppLocalizations.of(context)!.translate(LangKeys.analytics),
                                subtitle: AppLocalizations.of(context)!.translate(LangKeys.exportAnalytics),
                                imagePath: AppImages.logo, // Suggest unique image
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoutes.overWall);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
