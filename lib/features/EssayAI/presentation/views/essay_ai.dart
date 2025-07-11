import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/extensions/context_extension.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';
import 'package:graduation/features/EssayAI/data/essay_model.dart';
import 'package:graduation/features/overwall/presentation/widgets/custom_app_bar_for_exams.dart';
import 'package:graduation/features/overwall/presentation/widgets/input_field.dart';
import 'package:http/http.dart' as http;

class EssayAiView extends StatefulWidget {
  const EssayAiView({super.key});

  @override
  State<EssayAiView> createState() => _EssayAiViewState();
}

class _EssayAiViewState extends State<EssayAiView> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _questionsController = TextEditingController();
  List<TextEditingController> _answerControllers = [];
  List<String> _generatedQuestions = [];
  List<EssayCorrectionModel?> _corrections = [];
  bool _isGenerating = false;
  bool _isCorrecting = false;

  @override
  void dispose() {
    _topicController.dispose();
    _questionsController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarForExams(
        text: context.translate(LangKeys.essay),
        icon: Icons.close,
        onPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppColorsStyles.defaultPadding.w,
          vertical: AppColorsStyles.defaultPadding.h,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // حقل إدخال الموضوع
                _buildCard(
                  child: BuildInputField(
                    label: context.translate(LangKeys.enterExamTitle),
                    controller: _topicController,
                    validator: (value) => value!.isEmpty
                        ? context.translate(LangKeys.enterExamTitle)
                        : null,
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: 16.h),
                // حقل عدد الأسئلة
                _buildCard(
                  child: BuildInputField(
                    label: context.translate(LangKeys.numberOfQuestions),
                    controller: _questionsController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'من فضلك أدخل عدد الأسئلة';
                      }
                      if (int.tryParse(value) == null || int.parse(value) <= 0) {
                        return 'أدخل عددًا صحيحًا أكبر من 0';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 24.h),
                // زر إنشاء الأسئلة
                Center(
                  child: _buildButton(
                    onPressed: _isGenerating ? null : _generateEssayQuestions,
                    child: _isGenerating
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )
                        : TextApp(
                            text: context.translate(LangKeys.generateExam),
                            style: AppTextStyles.semiBold16(context).copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                if (_generatedQuestions.isNotEmpty &&
                    _answerControllers.length == _generatedQuestions.length) ...[
                  SizedBox(height: 24.h),
                  TextApp(
                    text: 'الأسئلة المُنشأة:',
                    style: AppTextStyles.bold18(context),
                  ),
                  SizedBox(height: 12.h),
                  // عرض الأسئلة مع حقول الإجابة
                  ..._generatedQuestions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 16.r,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                child: TextApp(
                                  text: '${index + 1}',
                                  style: AppTextStyles.body14(context)
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                              title: TextApp(
                                text: question,
                                style: AppTextStyles.body14(context),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            BuildInputField(
                              controller: _answerControllers[index],
                              maxLines: 5,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'أدخل إجابة السؤال ${index + 1}'
                                      : null,
                              label: 'إجابة السؤال ${index + 1}',
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 24.h),
                  // زر تصحيح الإجابات
                  Center(
                    child: _buildButton(
                      onPressed: _isCorrecting ? null : _evaluateAnswers,
                      child: _isCorrecting
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          : TextApp(
                              text: 'صحح إجاباتي',
                              style: AppTextStyles.semiBold16(context)
                                  .copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                ],
                if (_corrections.any((c) => c != null)) ...[
                  SizedBox(height: 24.h),
                  TextApp(
                    text: 'نتائج التصحيح:',
                    style: AppTextStyles.bold18(context),
                  ),
                  SizedBox(height: 12.h),
                  // عرض نتائج التصحيح لكل سؤال
                  ..._corrections.asMap().entries.where((entry) => entry.value != null).map((entry) {
                    final index = entry.key;
                    final correction = entry.value!;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextApp(
                              text: 'السؤال ${index + 1}: ${_generatedQuestions[index]}',
                              style: AppTextStyles.semiBold16(context),
                            ),
                            SizedBox(height: 8.h),
                            TextApp(
                              text: 'الدرجة: ${correction.score}/10',
                              style: AppTextStyles.bold18(context).copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            TextApp(
                              text: 'الأخطاء:',
                              style: AppTextStyles.semiBold16(context),
                            ),
                            SizedBox(height: 8.h),
                            TextApp(
                              text: correction.mistakes.isEmpty
                                  ? 'لا توجد أخطاء'
                                  : correction.mistakes,
                              style: AppTextStyles.body14(context),
                            ),
                            SizedBox(height: 12.h),
                            TextApp(
                              text: 'الملاحظات:',
                              style: AppTextStyles.semiBold16(context),
                            ),
                            SizedBox(height: 8.h),
                            TextApp(
                              text: correction.feedback,
                              style: AppTextStyles.body14(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // تصميم بطاقة احترافية
  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: child,
      ),
    );
  }

  // تصميم زر احترافي
  Widget _buildButton({required VoidCallback? onPressed, required Widget child}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 2,
      ),
      child: child,
    );
  }

  Future<void> _generateEssayQuestions() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isGenerating = true;
        _generatedQuestions.clear();
        _answerControllers.clear();
        _corrections.clear();
      });

      try {
        final prompt = '''
أنشئ ${_questionsController.text} أسئلة مقالية عن "${_topicController.text}".
يجب أن تكون الأسئلة مفتوحة، تحفز على التفكير، وذات طابع أكاديمي.
أرجع الأسئلة فقط في قائمة مرقمة بدون أي شرح إضافي.
''';

        final result = await _callAI(prompt);
        final questions = result
            .split(RegExp(r"\n+"))
            .map((e) => e.replaceAll(RegExp(r'^\d+[\.\)]\s*'), '').trim())
            .where((q) => q.isNotEmpty)
            .toList();

        setState(() {
          _generatedQuestions = questions;
          _answerControllers = List.generate(
            questions.length,
            (_) => TextEditingController(),
          );
          _corrections = List.filled(questions.length, null);
        });
      } catch (e) {
        setState(() {
          _generatedQuestions = [];
          _answerControllers = [];
          _corrections = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ أثناء إنشاء الأسئلة: $e')),
        );
      } finally {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _evaluateAnswers() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isCorrecting = true;
      });

      try {
        List<EssayCorrectionModel?> newCorrections = List.filled(_generatedQuestions.length, null);
        for (int i = 0; i < _generatedQuestions.length; i++) {
          final question = _generatedQuestions[i];
          final answer = _answerControllers[i].text.trim();
          if (answer.isNotEmpty) {
            final prompt = '''
أنت مدرس. صحح إجابة الطالب التالية بناءً على السؤال المقالي التالي.
السؤال: $question
أعط درجة من 10، وحدد أي أخطاء في القواعد/الإملاء/المحتوى، وقدم ملاحظات بناءة.

الإجابة:
$answer

قم بتنسيق الرد كالتالي:
الدرجة: X
الأخطاء: ...
الملاحظات: ...
''';

            final result = await _callAI(prompt);
            final model = EssayCorrectionModel.fromRawText(result);
            newCorrections[i] = model;
          }
        }
        setState(() {
          _corrections = newCorrections;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ أثناء تصحيح الإجابات: $e')),
        );
      } finally {
        setState(() {
          _isCorrecting = false;
        });
      }
    }
  }

  Future<String> _callAI(String prompt) async {
    const String apiKey = 'sk-02e178544f904b9696c835285265f303';
    const String model = "deepseek-chat";
    final Uri apiUrl = Uri.parse("https://api.deepseek.com/v1/chat/completions");

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": model,
          "messages": [
            {"role": "user", "content": prompt},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        throw Exception("فشل الاتصال بالـ API: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("خطأ في الاتصال: $e");
    }
  }
}
