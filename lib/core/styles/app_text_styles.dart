import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/styles/theme/app_themes_styles.dart';

abstract class AppTextStyles {
  // Headings
  static TextStyle bold32(BuildContext context) => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle bold24(BuildContext context) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle bold18(BuildContext context) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle semiBold20(BuildContext context) => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle medium18(BuildContext context) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle medium16(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle semiBold16(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).sliderTheme.thumbColor ?? Theme.of(context).colorScheme.secondary,
      );

  static TextStyle bold16(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  // Body text
  static TextStyle body16(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      );

  static TextStyle mutedBody16(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
      );

  static TextStyle body14(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      );

  static TextStyle light14(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w300,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle mutedBody14(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
      );

  static TextStyle body12(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      );

  static TextStyle status12(BuildContext context, {bool isSuccess = false}) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: isSuccess
            ? AppThemes.darkTheme.primaryColor
            : Theme.of(context).colorScheme.error,
      );

  // Captions / Labels
  static TextStyle caption12(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
      );

  static TextStyle caption12Light(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.54),
      );

  static TextStyle label10(BuildContext context) => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
      );
}
