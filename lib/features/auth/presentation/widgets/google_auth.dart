import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';

class GoogleAuth extends StatelessWidget {
  const GoogleAuth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton.icon(
        icon: Icon(Icons.g_mobiledata, size: 24.sp),
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
                    ),
                  ),
                ) ??
            ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
              ),
            ),
        label: TextApp(
          text: 'Continue with Google',
          style: AppTextStyles.body16(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}