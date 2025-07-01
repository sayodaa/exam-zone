import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/animations/animate_do.dart';
import 'package:graduation/core/common/widgets/app_text_field.dart';
import 'package:graduation/core/common/widgets/custom_app_bar.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/routes/app_routes.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/features/auth/presentation/widgets/auth_button.dart';
import 'package:graduation/features/auth/presentation/widgets/google_auth.dart';
import 'package:graduation/features/auth/presentation/widgets/have_auth.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            60.h.verticalSpace,
            CustomAppBar(text: 'ExamGenius'),
            40.h.verticalSpace,
            CustomFadeInLeft(
              duration: 700,
              child: TextApp(text: 'Welcome 🤩', style: AppTextStyles.bold24(context)),
            ),
            30.h.verticalSpace,
            CustomFadeInRight(
              duration: 700,
              child: AppTextField(labelText: 'Email'),
            ),
            16.h.verticalSpace,
            CustomFadeInLeft(
              duration: 700,
              child: AppTextField(labelText: 'Password'),
            ),
            20.h.verticalSpace,
            CustomFadeInUp(
              duration: 700,
              child: AuthButton(text: 'Sign up', routeName: AppRoutes.home),
            ),
            20.h.verticalSpace,
            CustomFadeInUp(
              duration: 700,
              child: Center(
                child: Text(
                  'Or continue with',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ),
            ),
            16.h.verticalSpace,
            CustomFadeInUp(
              duration: 700,
              child: GoogleAuth(),
            ),
            const Spacer(),
            CustomFadeInUp(
              duration: 800,
              child: HaveAuth(
                text: 'already have an account? login',
                onPressed: () => Navigator.pop(context),
              ),
            ),
            20.h.verticalSpace,
          ],
        ),
      ),
    );
  }
}
