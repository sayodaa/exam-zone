import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/pdf.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/extensions/context_extension.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';
import 'package:graduation/features/overwall/data/quation_model.dart';
import 'package:graduation/features/overwall/presentation/widgets/build_question_card.dart';
import 'package:graduation/features/overwall/presentation/widgets/essay_quation_card.dart';

class ExamScreen extends StatefulWidget {
  final List<QuestionModel>? generatedQuestions;

  const ExamScreen({this.generatedQuestions, super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final List<Map<String, dynamic>> multipleChoiceQuestions = [];
  final List<Map<String, dynamic>> essayQuestions = [];
  Map<int, String> userAnswers = {}; // تخزين إجابات المستخدم
  bool isSubmitted = false; // حالة تقديم الامتحان
  int score = 0; // درجة الامتحان
  @override
  void initState() {
    super.initState();
    _processGeneratedQuestions();
  }

  void _processGeneratedQuestions() {
    if (widget.generatedQuestions != null) {
      for (var question in widget.generatedQuestions!) {
        if (question.choices.isNotEmpty) {
          multipleChoiceQuestions.add({
            'question': question.question,
            'options': question.choices.entries
                .map(
                  (e) => {
                    'id': e.key,
                    'text': e.value,
                    'isCorrect': e.key == question.answer,
                  },
                )
                .toList(),
            'correctAnswer': question.answer,
          });
        } else {
          essayQuestions.add({'question': question.question});
        }
      }
      setState(() {});
    }
  }

  Future<String?> _getFileNameFromUser(BuildContext context) async {
    final controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اسم الملف'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "مثلاً: exam_result"),
        ),
        actions: [
          TextButton(
            child: Text('إلغاء'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('حفظ'),
            onPressed: () => Navigator.of(context).pop(controller.text),
          ),
        ],
      ),
    );
  }

  void _submitExam() {
    int totalCorrect = 0;
    for (var i = 0; i < multipleChoiceQuestions.length; i++) {
      if (userAnswers[i] == multipleChoiceQuestions[i]['correctAnswer']) {
        totalCorrect++;
      }
    }
    setState(() {
      isSubmitted = true;
      score = totalCorrect;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final fileName = await _getFileNameFromUser(context);
          if (fileName != null && fileName.trim().isNotEmpty) {
            await exportExamAsTextPdf(
              context: context,
              mcqQuestions: multipleChoiceQuestions,
              essayQuestions: essayQuestions,
              userAnswers: userAnswers,
              score: score,
              // fileName: fileName.trim(),
            );
          }
        },
        child: Icon(Icons.picture_as_pdf),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextApp(
          text: context.translate(LangKeys.questionsGenerated),
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
            if (multipleChoiceQuestions.isNotEmpty) ...[
              TextApp(
                text: context.translate(LangKeys.multipleChoiceQuestions),
                style: AppTextStyles.bold24(context),
              ),
              SizedBox(height: 12.h),
              ...multipleChoiceQuestions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return BuildQuestionCard(
                  context: context,
                  index: index + 1,
                  question: question['question'],
                  options: (question['options'] as List)
                      .cast<Map<String, dynamic>>(),
                  submitted: isSubmitted,
                  selectedAnswer: userAnswers[index],
                  onAnswerSelected: isSubmitted
                      ? null
                      : (answer) {
                          setState(() {
                            userAnswers[index] = answer;
                          });
                        },
                );
              }),
            ],
            if (essayQuestions.isNotEmpty) ...[
              SizedBox(height: 20.h),
              TextApp(
                text: 'أسئلة المقال',
                style: AppTextStyles.bold24(context),
              ),
              SizedBox(height: 12.h),
              ...essayQuestions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return EssayQuationCard(
                  context: context,
                  index: index + 1,
                  question: question['question'],
                  submitted: isSubmitted,
                  answer:
                      userAnswers[multipleChoiceQuestions.length + index] ?? '',
                  onAnswerChanged: isSubmitted
                      ? null
                      : (answer) {
                          setState(() {
                            userAnswers[multipleChoiceQuestions.length +
                                    index] =
                                answer;
                          });
                        },
                );
              }),
            ],
            SizedBox(height: 20.h),
            if (!isSubmitted) ...[
              Center(
                child: ElevatedButton(
                  onPressed:
                      userAnswers.length ==
                          (multipleChoiceQuestions.length +
                              essayQuestions.length)
                      ? _submitExam
                      : null,
                  child: TextApp(
                    text: context.translate(LangKeys.submitExam),
                    style: AppTextStyles.semiBold16(context),
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    TextApp(
                      text:
                          '${context.translate(LangKeys.score)}: $score من ${multipleChoiceQuestions.length}',
                      style: AppTextStyles.bold18(context),
                    ),
                    SizedBox(height: 8.h),
                    TextApp(
                      text:
                          '${context.translate(LangKeys.percentage)}: ${(score / multipleChoiceQuestions.length * 100).toStringAsFixed(1)}%',
                      style: AppTextStyles.medium16(context),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}