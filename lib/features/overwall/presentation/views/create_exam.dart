import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/extensions/context_extension.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';
import 'package:graduation/features/overwall/presentation/widgets/add_quation.dart';
import 'package:graduation/features/overwall/presentation/widgets/custom_app_bar_for_exams.dart';
import 'package:graduation/features/overwall/presentation/widgets/input_field.dart';
import 'package:graduation/features/overwall/presentation/widgets/quation_tile.dart';

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
      appBar: CustomAppBarForExams(text: context.translate(LangKeys.createExam), icon: Icons.close),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppColorsStyles.defaultPadding.w,
          vertical: AppColorsStyles.defaultPadding.h / 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildInputField(
              label: context.translate(LangKeys.examTitle),
              controller: _titleController,
            ),
            SizedBox(height: 12.h),
            BuildInputField(
              label: context.translate(LangKeys.selectSubject),
              controller: _subjectController,
            ),
            SizedBox(height: 12.h),
            BuildInputField(
              label: context.translate(LangKeys.level),
              controller: _levelController,
            ),
            SizedBox(height: 12.h),
            BuildInputField(
              label: context.translate(LangKeys.durationMinutes),
              controller: _durationController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return context.translate(LangKeys.enterDuration);
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return context.translate(LangKeys.enterDuration);
                }
                return null;
              },
            ),
            SizedBox(height: 20.h),
            TextApp(
              text: context.translate(LangKeys.multipleChoice),
              style: AppTextStyles.bold18(context),
            ),
            SizedBox(height: 12.h),
            if (multipleChoiceQuestions.isEmpty)
              BuildAddQuestionButton(onTap: () {
                setState(() {
                  multipleChoiceQuestions.add({context.translate(LangKeys.question): '', context.translate(LangKeys.option1): []});
                });
              }),
            ...multipleChoiceQuestions
                .map((q) => BuildQuestionTile(question: q, isMultipleChoice: true)),
            SizedBox(height: 20.h),
            TextApp(
              text: context.translate(LangKeys.essay),
              style: AppTextStyles.bold18(context),
            ),
            SizedBox(height: 12.h),
            if (essayQuestions.isEmpty)
              BuildAddQuestionButton(onTap: () {
                setState(() {
                  essayQuestions.add({context.translate(LangKeys.question): ''});
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
                  text: context.translate(LangKeys.createExam),
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
