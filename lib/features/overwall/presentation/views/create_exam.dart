import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/styles.dart';
import 'package:graduation/features/overwall/presentation/views/generate_quation.dart';

class CreateExamScreen extends StatefulWidget {
  const CreateExamScreen({super.key});

  @override
  State<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends State<CreateExamScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final List<Map<String, dynamic>> multipleChoiceQuestions = [];
  final List<Map<String, dynamic>> essayQuestions = [];

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _levelController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarForExams(text: 'Create Exam', icon: Icons.close),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppColorsStyles.defaultPadding.w,
          vertical: AppColorsStyles.defaultPadding.h / 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildInputField(
              label: 'Exam Title',
              controller: _titleController,
              hint: 'Enter exam title',
            ),
            SizedBox(height: 12.h),
            BuildInputField(
              label: 'Subject',
              controller: _subjectController,
              hint: 'Select subject',
            ),
            SizedBox(height: 12.h),
            BuildInputField(
              label: 'Level',
              controller: _levelController,
              hint: 'Select level',
            ),
            SizedBox(height: 12.h),
            BuildInputField(
              label: 'Duration (minutes)',
              controller: _durationController,
              hint: 'Enter duration',
            ),
            SizedBox(height: 20.h),
            TextApp(
              text: 'Multiple Choice Questions',
              style: AppTextStyles.bold18(context),
            ),
            SizedBox(height: 12.h),
            if (multipleChoiceQuestions.isEmpty)
              BuildAddQuestionButton(onTap: () {
                setState(() {
                  multipleChoiceQuestions.add({'question': '', 'options': []});
                });
              }),
            ...multipleChoiceQuestions
                .map((q) => BuildQuestionTile(question: q, isMultipleChoice: true)),
            SizedBox(height: 20.h),
            TextApp(
              text: 'Essay Questions',
              style: AppTextStyles.bold18(context),
            ),
            SizedBox(height: 12.h),
            if (essayQuestions.isEmpty)
              BuildAddQuestionButton(onTap: () {
                setState(() {
                  essayQuestions.add({'question': ''});
                });
              }),
            ...essayQuestions
                .map((q) => BuildQuestionTile(question: q, isMultipleChoice: false)),
            SizedBox(height: 20.h),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print(
                      'Exam Created - Title: ${_titleController.text}, Subject: ${_subjectController.text}, Level: ${_levelController.text}, Duration: ${_durationController.text}');
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child: TextApp(
                  text: 'Create Exam',
                  style: AppTextStyles.body16(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildInputField extends StatelessWidget {
  const BuildInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextApp(
          text: label,
          style: AppTextStyles.body14(context),
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppColorsStyles.defaultPadding.w,
            vertical: AppColorsStyles.defaultPadding.h,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
          ),
          child: TextField(
            controller: controller,
            style: AppTextStyles.body14(context),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: AppTextStyles.mutedBody14(context),
            ),
          ),
        ),
      ],
    );
  }
}

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
            text: '+ Add Question',
            style: AppTextStyles.mutedBody14(context),
          ),
        ),
      ),
    );
  }
}

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
              text: isMultipleChoice ? 'Multiple Choice Question' : 'Essay Question',
              style: AppTextStyles.caption12(context),
            ),
            SizedBox(height: 8.h),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter question here...',
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
                              hintText: 'Option ${index + 1}',
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
