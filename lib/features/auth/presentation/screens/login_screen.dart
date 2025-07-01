import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/animations/animate_do.dart';
import 'package:graduation/core/common/widgets/app_text_field.dart';
import 'package:graduation/core/common/widgets/custom_app_bar.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/extensions/context_extension.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/routes/app_routes.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';
import 'package:graduation/features/auth/presentation/widgets/auth_button.dart';
import 'package:graduation/features/auth/presentation/widgets/google_auth.dart';
import 'package:graduation/features/auth/presentation/widgets/have_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppColorsStyles.defaultPadding.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppColorsStyles.defaultPadding.h * 3.75,
            ), // Approx 60.h
            CustomAppBar(text: context.translate(LangKeys.appName)),
            SizedBox(
              height: AppColorsStyles.defaultPadding.h * 2.5,
            ), // Approx 40.h
            CustomFadeInLeft(
              duration: 700,
              child: TextApp(
                text: context.translate(LangKeys.welcomeBack),
                style: AppTextStyles.bold24(context),
              ),
            ),
            SizedBox(
              height: AppColorsStyles.defaultPadding.h * 1.875,
            ), // Approx 30.h
            CustomFadeInRight(
              duration: 700,
              child: AppTextField(labelText: context.translate(LangKeys.email)),
            ),
            SizedBox(height: AppColorsStyles.defaultPadding.h), // 16.h
            CustomFadeInRight(
              duration: 700,
              child: AppTextField(
                labelText: context.translate(LangKeys.password),
              ),
            ),
            SizedBox(
              height: AppColorsStyles.defaultPadding.h * 0.625,
            ), // Approx 10.h
            CustomFadeInLeft(
              duration: 600,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style:
                      Theme.of(context).textButtonTheme.style?.copyWith(
                        foregroundColor: WidgetStateProperty.all(
                          Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        ),
                      ) ??
                      TextButton.styleFrom(
                        foregroundColor: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                  onPressed: () {},
                  child: TextApp(
                    text: context.translate(LangKeys.forgotPassword),
                    style: AppTextStyles.body14(context).copyWith(
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppColorsStyles.defaultPadding.h * 0.625,
            ), // Approx 10.h
            CustomFadeInUp(
              duration: 700,
              child: AuthButton(
                text: context.translate(LangKeys.login),
                routeName: AppRoutes.settingsView,
              ),
            ),
            SizedBox(
              height: AppColorsStyles.defaultPadding.h * 1.25,
            ), // Approx 20.h
            CustomFadeInUp(
              duration: 700,
              child: Center(
                child: TextApp(
                  text: context.translate(LangKeys.orContinueWith),
                  style: AppTextStyles.body14(context).copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppColorsStyles.defaultPadding.h), // 16.h
            CustomFadeInUp(duration: 700, child: GoogleAuth()),
            const Spacer(),
            CustomFadeInUp(
              duration: 800,
              child: HaveAuth(
                text: context.translate(LangKeys.alreadyHaveAccount),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.signUp),
              ),
            ),
            SizedBox(
              height: AppColorsStyles.defaultPadding.h * 1.25,
            ), // Approx 20.h
          ],
        ),
      ),
    );
  }
}
