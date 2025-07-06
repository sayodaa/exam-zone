
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/extensions/context_extension.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';


class BuildQuestionTile extends StatelessWidget {
  const BuildQuestionTile({
    super.key,
    required this.question,
    required this.isMultipleChoice,
  });

  final Map<String, dynamic> question;
  final bool isMultipleChoice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(AppColorsStyles.defaultPadding.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp(
              text: isMultipleChoice ? context.translate(LangKeys.multipleChoice) : context.translate(LangKeys.essay),
              style: AppTextStyles.caption12(context),
            ),
            SizedBox(height: 8.h),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: context.translate(LangKeys.enterExamTitle),
                hintStyle: AppTextStyles.mutedBody14(context),
              ),
              style: AppTextStyles.body14(context),
              maxLines: null,
            ),
            if (isMultipleChoice)
              Column(
                children: List.generate(4, (index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '${context.translate(LangKeys.option1)} ${index + 1}',
                              hintStyle: AppTextStyles.mutedBody14(context),
                            ),
                            style: AppTextStyles.body14(context),
                          ),
                        ),
                        Checkbox(
                          value: false,
                          onChanged: (value) {},
                          activeColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}
