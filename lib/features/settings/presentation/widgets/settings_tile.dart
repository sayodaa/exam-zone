import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';// Import LangKeys
import 'package:graduation/core/styles/app_text_styles.dart';


class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            size: 24.sp,
          ),
          title: TextApp(
            text: title,
            style: AppTextStyles.medium16(context),
          ),
          subtitle: TextApp(
            text: subtitle,
            style: AppTextStyles.caption12Light(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: trailing,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 8.h,
          ),
        ),
      ),
    );
  }
}