import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';

class EssayQuationCard extends StatelessWidget {
  const EssayQuationCard({
    super.key,
    required this.context,
    required this.index,
    required this.question,
    required this.submitted,
    required this.answer,
    required this.onAnswerChanged,
  });

  final BuildContext context;
  final int index;
  final String question;
  final bool submitted;
  final String answer;
  final void Function(String)? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextApp(
            text: 'السؤال $index',
            style: AppTextStyles.semiBold16(context),
          ),
          SizedBox(height: 8.h),
          TextApp(
            text: question,
            style: AppTextStyles.body14(context),
          ),
          SizedBox(height: 12.h),
          if (!submitted)
            TextField(
              onChanged: onAnswerChanged,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'اكتب إجابتك هنا',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: answer),
            )
          else
            TextApp(
              text: answer,
              style: AppTextStyles.body14(context),
            ),
        ],
      ),
    );
  }
}
