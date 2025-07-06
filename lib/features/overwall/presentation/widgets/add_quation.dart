
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/extensions/context_extension.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';


class BuildAddQuestionButton extends StatelessWidget {
  const BuildAddQuestionButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
        ),
        child: Center(
          child: TextApp(
            text: '+${context.translate(LangKeys.addQuestion)}',
            style: AppTextStyles.mutedBody14(context),
          ),
        ),
      ),
    );
  }
}