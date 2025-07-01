import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.onChanged,
  });

  final String labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
            Theme.of(context).cardTheme.color?.withOpacity(0.1),
        labelText: labelText,
        labelStyle: AppTextStyles.body16(context).copyWith(
          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
        border: Theme.of(context).inputDecorationTheme.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
              borderSide: BorderSide.none,
            ),
        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
              borderSide: BorderSide.none,
            ),
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
              borderSide: BorderSide.none,
            ),
      ),
      style: AppTextStyles.body16(context),
    );
  }
}