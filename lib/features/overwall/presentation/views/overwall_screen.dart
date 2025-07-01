import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/features/overwall/presentation/views/generate_quation.dart';

class ExamResultsScreen extends StatelessWidget {
  const ExamResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarForExams(text: 'Exam Results', icon: Icons.close),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w, // Using fixed value to match original
          vertical: 8.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp(
              text: 'Overall Performance',
              style: AppTextStyles.bold24(context),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BuildPerformanceCard(title: 'Total Score', value: '85/100'),
                BuildPerformanceCard(title: 'Correct Answers', value: '17/20'),
              ],
            ),
            SizedBox(height: 12.h),
            BuildPerformanceCard(title: 'Incorrect Answers', value: '3/20'),
            SizedBox(height: 20.h),
            TextApp(
              text: 'Performance by Question Type',
              style: AppTextStyles.bold18(context),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BuildPerformanceCard(title: 'Multiple Choice', value: '15/15'),
                BuildPerformanceCard(title: 'Essay', value: '20/25'),
              ],
            ),
            SizedBox(height: 20.h),
            TextApp(
              text: 'Detailed Answers',
              style: AppTextStyles.bold18(context),
            ),
            SizedBox(height: 12.h),
            ...List.generate(20, (index) {
              return AnswerTile(questionNumber: index + 1);
            }),
          ],
        ),
      ),
    );
  }
}

class AnswerTile extends StatelessWidget {
  const AnswerTile({
    super.key,
    required this.questionNumber,
  });

  final int questionNumber;

  @override
  Widget build(BuildContext context) {
    final isCorrect = questionNumber <= 17; // Based on 17/20 correct
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextApp(
              text:
                  'Question $questionNumber: What is the ${['capital', 'largest', 'chemical', 'speed', 'boiling', 'smallest', 'highest', 'largest', 'currency', 'longest', 'largest', 'capital', 'largest', 'highest', 'largest', 'capital', 'largest', 'fastest', 'largest bird', 'largest'][questionNumber - 1]}',
              style: AppTextStyles.caption12(context),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextApp(
            text: 'Your Answer: ${String.fromCharCode(64 + questionNumber)}',
            style: AppTextStyles.body12(context),
          ),
          TextApp(
            text: isCorrect ? 'Correct' : 'Incorrect',
            style: AppTextStyles.status12(context, isSuccess: isCorrect),
          ),
        ],
      ),
    );
  }
}

class BuildPerformanceCard extends StatelessWidget {
  const BuildPerformanceCard({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          TextApp(
            text: title,
            style: AppTextStyles.caption12(context),
          ),
          SizedBox(height: 4.h),
          TextApp(
            text: value,
            style: AppTextStyles.bold16(context),
          ),
        ],
      ),
    );
  }
}