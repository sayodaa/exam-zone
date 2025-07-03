import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/styles/app_images.dart';

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
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title??'',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4.h),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Text(
                        subtitle??'',
                        style: TextStyle(
                          fontSize: ScreenUtil().screenWidth < 360
                              ? 12.sp
                              : 13.sp, // Smaller font for narrow screens
                          color: Colors.white70,
                        ),
                        maxLines: ScreenUtil().screenHeight < 600
                            ? 2
                            : 3, // Adjust max lines based on screen height
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
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
