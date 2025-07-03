import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.onSubmitted,
    this.suffixIcon,
    this.suffixIconPressed,
  });
  final int maxLines;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final ValueChanged<String>? onSubmitted;
  final IconData? suffixIcon;
  final void Function()? suffixIconPressed;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      obscureText: obscureText,
      maxLines: maxLines,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: suffixIconPressed,
          icon: Icon(suffixIcon),
        ),
        filled: true,
        fillColor:
            Theme.of(context).inputDecorationTheme.fillColor ??
            Theme.of(context).cardTheme.color?.withValues(alpha: 0.1),
        labelText: labelText,
        labelStyle: AppTextStyles.body16(context).copyWith(
          color: Theme.of(
            context,
          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
        ),
        border:
            Theme.of(context).inputDecorationTheme.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppColorsStyles.defaultBorderRadius.r,
              ),
              borderSide: BorderSide.none,
            ),
        enabledBorder:
            Theme.of(context).inputDecorationTheme.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppColorsStyles.defaultBorderRadius.r,
              ),
              borderSide: BorderSide.none,
            ),
        focusedBorder:
            Theme.of(context).inputDecorationTheme.focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppColorsStyles.defaultBorderRadius.r,
              ),
              borderSide: BorderSide.none,
            ),
      ),
      style: AppTextStyles.body16(context),
    );
  }
}
