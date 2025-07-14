// lib/features/overwall/data/models/question_model.dart

import 'package:graduation/core/language/lang_keys.dart';

class QuestionModel {
  final String question;
  final Map<String, String> choices;
  final String answer;

  QuestionModel({
    required this.question,
    required this.choices,
    required this.answer,
    required dynamic context,
  }) {
    // التحقق من صحة البيانات
    if (question.isEmpty) {
      throw ArgumentError(context.translate(LangKeys.errorQuestionEmpty));
    }
    if (!choices.containsKey(answer)) {
      throw ArgumentError(context.translate(LangKeys.errorAnswerNotExist));
    }
    if (!['a', 'b', 'c', 'd'].contains(answer.toLowerCase())) {
      throw ArgumentError('الإجابة يجب أن تكون a, b, c, أو d');
    }
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json, dynamic context) {
    final choicesRaw = json['choices'];
    if (choicesRaw is! Map<String, dynamic>) {
      throw FormatException('تنسيق الخيارات غير صحيح');
    }

    final choices = Map<String, String>.from(
      choicesRaw.map((key, value) => MapEntry(key, value.toString()))
    );

    final answer = json['answer']?.toString() ?? '';
    
    if (answer.isEmpty) {
      throw FormatException('الإجابة مطلوبة');
    }

    return QuestionModel(
      question: json['question']?.toString() ?? '',
      choices: choices,
      answer: answer, context: context,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'choices': choices,
      'answer': answer,
    };
  }

  @override
  String toString() {
    return 'QuestionModel(question: $question, choices: $choices, answer: $answer)';
  }
}