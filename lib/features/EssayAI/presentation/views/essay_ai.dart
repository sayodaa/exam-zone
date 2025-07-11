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
      body: LoadingOverlay(
        isLoading: _isGenerating || _isCorrecting,
        child: Padding(
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
                  // Topic input field
                  _buildCard(
                    child: BuildInputField(
                      label: context.translate(LangKeys.enterExamTitle),
                      controller: _topicController,
                      validator: (value) => value!.isEmpty
                          ? context.translate(LangKeys.enterExamTitle)
                          : null,
                      maxLines: 2,
                      prefixIcon: Icons.title,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Number of questions field
                  _buildCard(
                    child: BuildInputField(
                      label: context.translate(LangKeys.numberOfQuestions),
                      controller: _questionsController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.translate(LangKeys.numberOfQuestions);
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return context.translate(LangKeys.errorOccurred);
                        }
                        return null;
                      },
                      prefixIcon: Icons.format_list_numbered,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Generate questions button
                  Center(
                    child: _buildButton(
                      onPressed: _isGenerating ? null : _generateEssayQuestions,
                      child: _isGenerating
                          ? _buildCustomLoader()
                          : TextApp(
                              text: context.translate(LangKeys.generateExam),
                              style: AppTextStyles.semiBold16(context)
                                  .copyWith(color: Colors.white),
                            ),
                      icon: Icons.auto_awesome,
                    ),
                  ),
                  if (_generatedQuestions.isNotEmpty &&
                      _answerControllers.length == _generatedQuestions.length) ...[
                    SizedBox(height: 24.h),
                    TextApp(
                      text: context.translate(LangKeys.questionsGenerated),
                      style: AppTextStyles.bold18(context)
                          .copyWith(color: const Color(0xFF1A202C)),
                    ),
                    SizedBox(height: 12.h),
                    // Display questions with answer fields
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
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: TextApp(
                                    text: '${index + 1}',
                                    style: AppTextStyles.body14(context)
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                                title: TextApp(
                                  text: question,
                                  style: AppTextStyles.body14(context)
                                      .copyWith(color: const Color(0xFF1A202C)),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              BuildInputField(
                                controller: _answerControllers[index],
                                maxLines: 5,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? context.translate(LangKeys.detailedAnswers)
                                        : null,
                                label: context.translate(LangKeys.correctAnswer),
                                prefixIcon: Icons.edit,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 24.h),
                    // Evaluate answers button
                    Center(
                      child: _buildButton(
                        onPressed: _isCorrecting ? null : _evaluateAnswers,
                        child: _isCorrecting
                            ? _buildCustomLoader()
                            : TextApp(
                                text: context.translate(LangKeys.correctAnswers),
                                style: AppTextStyles.semiBold16(context)
                                    .copyWith(color: Colors.white),
                              ),
                        icon: Icons.check_circle,
                      ),
                    ),
                  ],
                  if (_corrections.any((c) => c != null)) ...[
                    SizedBox(height: 24.h),
                    _buildSummaryCard(),
                    SizedBox(height: 24.h),
                    TextApp(
                      text: context.translate(LangKeys.correctAnswer),
                      style: AppTextStyles.bold18(context)
                          .copyWith(color: const Color(0xFF1A202C)),
                    ),
                    SizedBox(height: 12.h),
                    // Display correction results for each question
                    ..._corrections.asMap().entries.where((entry) => entry.value != null).map((entry) {
                      final index = entry.key;
                      final correction = entry.value!;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildCard(
                          child: ExpansionTile(
                            title: TextApp(
                              text: '${context.translate(LangKeys.question)} ${index + 1}: ${_generatedQuestions[index]}',
                              style: AppTextStyles.semiBold16(context)
                                  .copyWith(color: const Color(0xFF1A202C)),
                            ),
                            subtitle: Container(
                              padding: EdgeInsets.all(8.w),
                              margin: EdgeInsets.only(top: 8.h),
                              decoration: BoxDecoration(
                                color: _getScoreColor(correction.score),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: TextApp(
                                text: '${context.translate(LangKeys.score)}: ${correction.score}/10',
                                style: AppTextStyles.bold18(context).copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8ECEF),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (correction.mistakes.isNotEmpty) ...[
                                        TextApp(
                                          text: 'الأخطاء:',
                                          style: AppTextStyles.bold18(context)
                                              .copyWith(color: const Color(0xFF1A202C)),
                                        ),
                                        SizedBox(height: 4.h),
                                        TextApp(
                                          text: correction.mistakes,
                                          style: AppTextStyles.body14(context)
                                              .copyWith(color: const Color(0xFF4A5568)),
                                        ),
                                        SizedBox(height: 8.h),
                                      ],
                                      TextApp(
                                        text: 'الملاحظات:',
                                        style: AppTextStyles.bold18(context)
                                            .copyWith(color: const Color(0xFF1A202C)),
                                      ),
                                      SizedBox(height: 4.h),
                                      TextApp(
                                        text: correction.feedback,
                                        style: AppTextStyles.body14(context)
                                            .copyWith(color: const Color(0xFF4A5568)),
                                      ),
                                    ],
                                  ),
                                ),
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
      ),
    );
  }

  // Score color logic
  Color _getScoreColor(int score) {
    if (score >= 8) return const Color(0xFF28A745); // Green
    if (score >= 6) return const Color(0xFFFFC107); // Amber
    if (score >= 4) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFDC3545); // Red
  }

  // Professional card design with neutral gradient
  Widget _buildCard({required Widget child}) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A202C).withOpacity(0.1),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFE8ECEF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: child,
        ),
      ),
    );
  }

  // Professional button design with gradient
  Widget _buildButton({
    required VoidCallback? onPressed,
    required Widget child,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(onPressed != null ? 1.0 : 0.95),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2A4B7C), // Deep Blue
              const Color(0xFF2A4B7C).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A202C).withOpacity(0.2),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20.sp),
              SizedBox(width: 8.w),
            ],
            child,
          ],
        ),
      ),
    );
  }

  // Custom loader
  Widget _buildCustomLoader() {
    return SizedBox(
      width: 24.w,
      height: 24.h,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: const AlwaysStoppedAnimation<Color>(
          Color(0xFF2A4B7C), // Deep Blue
        ),
        backgroundColor: Colors.white.withOpacity(0.3),
      ),
    );
  }

  // Summary card for corrections
  Widget _buildSummaryCard() {
    final totalScore = _corrections.fold<int>(0, (sum, c) => sum + (c?.score ?? 0));
    final averageScore = _corrections.isNotEmpty ? totalScore / _corrections.length : 0;
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextApp(
            text: 'ملخص التصحيح',
            style: AppTextStyles.bold18(context).copyWith(color: const Color(0xFF1A202C)),
          ),
          SizedBox(height: 8.h),
          TextApp(
            text: 'الدرجة الإجمالية: $totalScore / ${_corrections.length * 10}',
            style: AppTextStyles.body14(context).copyWith(color: const Color(0xFF4A5568)),
          ),
          SizedBox(height: 4.h),
          TextApp(
            text: 'المعدل: ${averageScore.toStringAsFixed(1)} / 10',
            style: AppTextStyles.body14(context).copyWith(color: const Color(0xFF4A5568)),
          ),
        ],
      ),
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
        _showErrorSnackBar('خطأ في إنشاء الأسئلة: ${e.toString()}');
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
        List<Future<EssayCorrectionModel?>> futures = [];
        
        for (int i = 0; i < _generatedQuestions.length; i++) {
          futures.add(_evaluateSingleAnswer(i));
        }

        final results = await Future.wait(futures);
        
        setState(() {
          _corrections = results;
        });
      } catch (e) {
        print('General error in _evaluateAnswers: $e');
        _showErrorSnackBar('خطأ في تصحيح الإجابات: ${e.toString()}');
      } finally {
        setState(() {
          _isCorrecting = false;
        });
      }
    }
  }

  Future<EssayCorrectionModel?> _evaluateSingleAnswer(int index) async {
    try {
      final question = _generatedQuestions[index];
      final answer = _answerControllers[index].text.trim();
      
      if (answer.isEmpty) {
        return EssayCorrectionModel(
          score: 0,
          mistakes: 'لم يتم تقديم إجابة',
          feedback: 'يرجى كتابة إجابة للسؤال',
        );
      }

      final prompt = '''
أنت مدرس خبير. صحح إجابة الطالب التالية بناءً على السؤال المقالي.

السؤال: $question

الإجابة: $answer

قم بتقييم الإجابة وإعطاء:
1. درجة من 10
2. الأخطاء (إملائية، نحوية، في المحتوى)
3. ملاحظات بناءة لتحسين الإجابة

تنسيق الرد:
الدرجة: [رقم من 0 إلى 10]
الأخطاء: [اذكر الأخطاء أو اكتب "لا توجد أخطاء واضحة"]
الملاحظات: [ملاحظات مفيدة لتحسين الإجابة]
''';

      final result = await _callAI(prompt);
      print('Correction Response for Question ${index + 1}: $result');
      
      return _parseEssayCorrection(result);
    } catch (e) {
      print('Error correcting question ${index + 1}: $e');
      return EssayCorrectionModel(
        score: 0,
        mistakes: 'خطأ في معالجة الإجابة',
        feedback: 'حدث خطأ أثناء تصحيح هذه الإجابة. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  EssayCorrectionModel _parseEssayCorrection(String rawText) {
    try {
      print('Parsing raw text: $rawText');
      
      int score = _extractScore(rawText);
      String mistakes = _extractMistakes(rawText);
      String feedback = _extractFeedback(rawText);

      print('Extracted - Score: $score, Mistakes: $mistakes, Feedback: $feedback');

      return EssayCorrectionModel(
        score: score,
        mistakes: mistakes,
        feedback: feedback,
      );
    } catch (e) {
      print('Error parsing EssayCorrectionModel: $e');
      return EssayCorrectionModel(
        score: 5,
        mistakes: 'لم يتم تحليل الأخطاء',
        feedback: rawText.isNotEmpty ? rawText : 'لم يتم تقديم ملاحظات',
      );
    }
  }

  int _extractScore(String text) {
    final patterns = [
      r'الدرجة[:\s]*(\d+)',
      r'درجة[:\s]*(\d+)',
      r'النتيجة[:\s]*(\d+)',
      r'(\d+)\s*/\s*10',
      r'(\d+)\s*من\s*10',
      r'(\d+)\s*نقطة',
      r'(\d+)\s*نقاط',
    ];

    for (String pattern in patterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final scoreStr = match.group(1);
        if (scoreStr != null) {
          final score = int.tryParse(scoreStr);
          if (score != null && score >= 0 && score <= 10) {
            return score;
          }
        }
      }
    }

    return _analyzeTextQuality(text);
  }

  int _analyzeTextQuality(String text) {
    final lowerText = text.toLowerCase();
    
    if (lowerText.contains('ممتاز') || lowerText.contains('رائع')) return 9;
    if (lowerText.contains('جيد جداً') || lowerText.contains('جيد جدا')) return 8;
    if (lowerText.contains('جيد')) return 7;
    if (lowerText.contains('مقبول')) return 6;
    if (lowerText.contains('ضعيف')) return 4;
    if (lowerText.contains('سيء') || lowerText.contains('ضعيف جداً')) return 3;
    
    return 5;
  }

  String _extractMistakes(String text) {
    final patterns = [
      r'الأخطاء[:\s]*([^الملاحظات]*?)(?=الملاحظات|$)',
      r'الاخطاء[:\s]*([^الملاحظات]*?)(?=الملاحظات|$)',
      r'أخطاء[:\s]*([^الملاحظات]*?)(?=الملاحظات|$)',
    ];

    for (String pattern in patterns) {
      final match = RegExp(pattern, caseSensitive: false, multiLine: true, dotAll: true).firstMatch(text);
      if (match != null) {
        String mistakes = match.group(1)?.trim() ?? '';
        if (mistakes.isNotEmpty) {
          return mistakes;
        }
      }
    }

    if (text.contains('لا توجد أخطاء') || 
        text.contains('لا أخطاء') || 
        text.contains('بدون أخطاء') ||
        text.contains('خالي من الأخطاء')) {
      return 'لا توجد أخطاء واضحة';
    }

    return 'لم يتم تحديد أخطاء محددة';
  }

  String _extractFeedback(String text) {
    final patterns = [
      r'الملاحظات[:\s]*(.+?)$',
      r'ملاحظات[:\s]*(.+?)$',
      r'التوصيات[:\s]*(.+?)$',
      r'اقتراحات[:\s]*(.+?)$',
    ];

    for (String pattern in patterns) {
      final match = RegExp(pattern, caseSensitive: false, multiLine: true, dotAll: true).firstMatch(text);
      if (match != null) {
        String feedback = match.group(1)?.trim() ?? '';
        if (feedback.isNotEmpty) {
          return feedback;
        }
      }
    }

    return text.isNotEmpty ? text : 'لم يتم تقديم ملاحظات محددة';
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
          "temperature": 0.7,
          "max_tokens": 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'].toString().trim();
        print('API Response: $content');
        return content;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('فشل في الاتصال بالخدمة. كود الخطأ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _callAI: $e');
      if (e.toString().contains('SocketException')) {
        throw Exception('تحقق من اتصالك بالإنترنت');
      }
      throw Exception('خطأ في الاتصال بالخدمة: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body14(context).copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFDC3545), // Red
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
        action: SnackBarAction(
          label: 'إعادة المحاولة',
          textColor: Colors.white,
          onPressed: () {
            if (message.contains('إنشاء الأسئلة')) {
              _generateEssayQuestions();
            } else {
              _evaluateAnswers();
            }
          },
        ),
      ),
    );
  }
}

// Loading overlay widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: const Color(0xFF1A202C).withOpacity(0.5),
            child: Center(
              child: SizedBox(
                width: 24.w,
                height: 24.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF2A4B7C), // Deep Blue
                  ),
                  backgroundColor: Colors.white30,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Enhanced input field widget
class BuildInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;

  const BuildInputField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixIcon,
  });

  @override
  _BuildInputFieldState createState() => _BuildInputFieldState();
}

class _BuildInputFieldState extends State<BuildInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          textDirection: TextDirection.rtl, // Ensure RTL for Arabic
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: AppTextStyles.body14(context).copyWith(
              color: const Color(0xFF4A5568), // Medium Gray
            ),
            floatingLabelStyle: AppTextStyles.body14(context).copyWith(
              color: const Color(0xFF2A4B7C), // Deep Blue
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon,
                    color: const Color(0xFF2A4B7C), size: 20.sp)
                : null,
            filled: true,
            fillColor: const Color(0xFFF8FAFC), // Slate White
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFFE8ECEF),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFFE8ECEF),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFF2A4B7C), // Deep Blue
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFFDC3545), // Red
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFFDC3545), // Red
                width: 2,
              ),
            ),
          ),
          style: AppTextStyles.body14(context)
              .copyWith(color: const Color(0xFF1A202C)),
        ),
      ),
    );
  }
}
