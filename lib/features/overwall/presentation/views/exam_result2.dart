import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/styles.dart';
import 'package:graduation/features/overwall/presentation/views/generate_quation.dart';

class ExamResultsStudentsScreen extends StatelessWidget {
  const ExamResultsStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> students = [
      {'name': 'Ethan Harper', 'score': '85/100', 'grade': 'A'},
      {'name': 'Olivia Bennett', 'score': '78/100', 'grade': 'B+'},
      {'name': 'Noah Carter', 'score': '92/100', 'grade': 'A+'},
      {'name': 'Sophia Evans', 'score': '65/100', 'grade': 'C'},
      {'name': 'Liam Foster', 'score': '88/100', 'grade': 'A-'},
      {'name': 'Ava Griffin', 'score': '72/100', 'grade': 'B-'},
      {'name': 'Jackson Hayes', 'score': '95/100', 'grade': 'A+'},
      {'name': 'Isabella Ingram', 'score': '60/100', 'grade': 'D'},
      {'name': 'Lucas Jenkins', 'score': '80/100', 'grade': 'B'},
      {'name': 'Mia Kelly', 'score': '75/100', 'grade': 'B'},
    ];

    return Scaffold(
      appBar: const CustomAppBarForExams(text: 'Exam Results', icon: Icons.close),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppColorsStyles.defaultPadding.w,
          vertical: AppColorsStyles.defaultPadding.h / 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp(
              text: 'Students',
              style: AppTextStyles.bold24(context),
            ),
            SizedBox(height: 12.h),
            ...students.map((student) => BuildStudentTile(student: student)),
          ],
        ),
      ),
    );
  }
}

class BuildStudentTile extends StatelessWidget {
  const BuildStudentTile({
    super.key,
    required this.student,
  });

  final Map<String, dynamic> student;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppColorsStyles.defaultPadding.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: const AssetImage('assets/avatar_placeholder.png'),
            backgroundColor: Theme.of(context).cardTheme.color, // Updated to use theme
          ),
          SizedBox(width: AppColorsStyles.defaultPadding.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextApp(
                  text: student['name'],
                  style: AppTextStyles.medium18(context),
                ),
                SizedBox(height: 4.h),
                TextApp(
                  text: 'Score: ${student['score']}, Grade: ${student['grade']}',
                  style: AppTextStyles.caption12(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}