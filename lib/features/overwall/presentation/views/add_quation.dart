import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';

class AddQuestionsScreen extends StatefulWidget {
  const AddQuestionsScreen({super.key});

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  final List<Map<String, dynamic>> multipleChoiceQuestions = [];
  final List<Map<String, dynamic>> essayQuestions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).appBarTheme.foregroundColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextApp(
          text: 'Add Questions',
          style: AppTextStyles.semiBold20(context),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppColorsStyles.defaultPadding.w,
          vertical: AppColorsStyles.defaultPadding.h / 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp(
              text: 'Multiple Choice',
              style: AppTextStyles.bold24(context),
            ),
            SizedBox(height: 12.h),
            _buildQuestionSection(
              questionType: 'Multiple Choice',
              questions: multipleChoiceQuestions,
              onAddQuestion: () {
                setState(() {
                  multipleChoiceQuestions.add({
                    'question': '',
                    'options': List.generate(4, (index) => {'text': '', 'isCorrect': false}),
                  });
                });
              },
            ),
            SizedBox(height: 20.h),
            TextApp(
              text: 'Essay',
              style: AppTextStyles.bold24(context),
            ),
            SizedBox(height: 12.h),
            _buildQuestionSection(
              questionType: 'Essay',
              questions: essayQuestions,
              onAddQuestion: () {
                setState(() {
                  essayQuestions.add({'question': ''});
                });
              },
            ),
            SizedBox(height: 20.h),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: Theme.of(context).elevatedButtonTheme.style,
                child: TextApp(
                  text: 'Save',
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

  Widget _buildQuestionSection({
    required String questionType,
    required List<Map<String, dynamic>> questions,
    required VoidCallback onAddQuestion,
  }) {
    return Column(
      children: [
        if (questions.isEmpty)
          _buildQuestionInput(questionType, 0, onAddQuestion)
        else
          ...List.generate(questions.length, (index) {
            return _buildQuestionInput(questionType, index, onAddQuestion);
          }),
        GestureDetector(
          onTap: onAddQuestion,
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
        ),
      ],
    );
  }

  Widget _buildQuestionInput(String questionType, int index, VoidCallback onAddQuestion) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          Container(
            height: 100.h,
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter question here...',
                hintStyle: AppTextStyles.mutedBody14(context),
              ),
              style: AppTextStyles.body14(context),
              maxLines: null,
            ),
          ),
          if (questionType == 'Multiple Choice')
            ...List.generate(4, (optionIndex) {
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppColorsStyles.defaultPadding.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Option ${optionIndex + 1}',
                            hintStyle: AppTextStyles.mutedBody14(context),
                          ),
                          style: AppTextStyles.body14(context),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Checkbox(
                      value: false,
                      onChanged: (value) {},
                      activeColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              );
            }),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}