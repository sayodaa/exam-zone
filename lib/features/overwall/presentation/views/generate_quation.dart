import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/extensions/context_extension.dart';
import 'package:graduation/core/language/app_localizations.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/routes/app_routes.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';

class GenerateExamScreen extends StatefulWidget {
  const GenerateExamScreen({super.key});

  @override
  State<GenerateExamScreen> createState() => _GenerateExamScreenState();
}

class _GenerateExamScreenState extends State<GenerateExamScreen> {
  double difficultyValue = 0.5;
  double generatingProgress = 0.0;
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _questionsController = TextEditingController();
  bool _isGenerating = false;

  String? get difficultyLabel {
    if (difficultyValue < 0.34) return AppLocalizations.of(context)?.translate(LangKeys.easy);
    if (difficultyValue < 0.67) return AppLocalizations.of(context)?.translate(LangKeys.medium);
    return AppLocalizations.of(context)?.translate(LangKeys.hard);
  }

  void _startGenerating() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isGenerating = true;
        generatingProgress = 0.0;
      });

      // Simulate exam generation
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
          generatingProgress = i / 100;
        });
      }

      // Navigate to AddQuestion screen after generation
      if (mounted) {
        Navigator.pushNamed(context, AppRoutes.addQuestion);
        setState(() {
          _isGenerating = false;
          generatingProgress = 0.0;
        });
      }
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _questionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarForExams(
        text: (context).translate(LangKeys.generateExam),
        icon: Icons.close,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppColorsStyles.defaultPadding.w,
            vertical: AppColorsStyles.defaultPadding.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildInputField(
                  label: (context).translate(LangKeys.selectSubject),
                  controller: _subjectController,
                  validator: (value) => value!.isEmpty
                      ? (context).translate(LangKeys.enterExamTitle) // Reused for simplicity
                      : null,
                ),
                SizedBox(height: 20.h),
                BuildInputField(
                  label: AppLocalizations.of(context)!.translate(LangKeys.numberOfQuestions),
                  controller: _questionsController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return (context).translate(LangKeys.numberOfQuestions);
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return (context).translate(LangKeys.enterDuration); // Reused for simplicity
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: context.translate(LangKeys.difficultyLevel),
                      style: AppTextStyles.medium16(context),
                    ),
                    TextApp(
                      text: difficultyLabel ?? '',
                      style: AppTextStyles.semiBold16(context),
                    ),
                  ],
                ),
                Slider(
                  value: difficultyValue,
                  onChanged: _isGenerating
                      ? null
                      : (val) {
                          setState(() {
                            difficultyValue = val;
                          });
                        },
                  min: 0,
                  max: 1,
                  divisions: 2,
                  activeColor: Theme.of(context).sliderTheme.activeTrackColor,
                  inactiveColor: Theme.of(context).sliderTheme.inactiveTrackColor,
                  thumbColor: Theme.of(context).sliderTheme.thumbColor,
                  label: difficultyLabel,
                ),
                SizedBox(height: 30.h),
                Center(
                  child: ElevatedButton(
                    onPressed: _isGenerating ? null : _startGenerating,
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: _isGenerating
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color?>(
                                  Theme.of(context).textTheme.bodyLarge!.color),
                            ),
                          )
                        : TextApp(
                            text: (context).translate(LangKeys.generateExam),
                            style: AppTextStyles.body16(context).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 40.h),
                if (_isGenerating) ...[
                  TextApp(
                    text: (context).translate(LangKeys.generatingExam),
                    style: AppTextStyles.body14(context),
                  ),
                  SizedBox(height: 8.h),
                  LinearProgressIndicator(
                    value: generatingProgress,
                    backgroundColor: Theme.of(context).progressIndicatorTheme.linearTrackColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).progressIndicatorTheme.color!),
                    minHeight: 6.h,
                  ),
                  SizedBox(height: 8.h),
                  TextApp(
                    text: (context).translate(LangKeys.mayTakeSeconds),
                    style: AppTextStyles.caption12(context),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildInputField extends StatelessWidget {
  const BuildInputField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.keyboardType,
  });

  final String? label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius.r),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: AppTextStyles.body16(context),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: AppTextStyles.mutedBody16(context),
          contentPadding: EdgeInsets.symmetric(
            vertical: AppColorsStyles.defaultPadding.h,
            horizontal: AppColorsStyles.defaultPadding.w,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class CustomAppBarForExams extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarForExams({
    super.key,
    required this.text,
    this.icon,
  });

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextApp(
        text: text,
        style: AppTextStyles.semiBold20(context),
      ),
      leading: IconButton(
        icon: Icon(icon, color: Theme.of(context).appBarTheme.foregroundColor),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
