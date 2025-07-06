import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/app_images.dart';
import 'package:graduation/core/styles/app_text_styles.dart';

class BuildOptionCard extends StatelessWidget {
  const BuildOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
  });
  final String? title;
  final String? subtitle;
  final String? imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w), // Reduced padding for smaller screens
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,// Slightly transparent background
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextApp(
                    text:title??'',
                    style: AppTextStyles.semiBold20(context),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4.h),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return TextApp(
                        text: subtitle??'',
                        style: AppTextStyles.body12(context),
                        maxLines: ScreenUtil().screenHeight < 600
                            ? 2
                            : 3, // Adjust max lines based on screen height
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  imagePath??AppImages.logo, // Default image if null
                  width: 100.w, // Slightly reduced image size
                  height: 80.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
