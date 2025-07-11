import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';


class BuildInputField extends StatelessWidget {
  const BuildInputField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines,
  });

  final String? label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: AppTextStyles.body16(context),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: AppTextStyles.mutedBody16(context),
          contentPadding: EdgeInsets.symmetric(
            vertical: AppColorsStyles.defaultPadding.h,
            horizontal: AppColorsStyles.defaultPadding.w,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}