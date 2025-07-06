// lib/features/overwall/data/models/question_model.dart

class QuestionModel {
  final String question;
  final Map<String, dynamic> choices;
  final String answer;

  QuestionModel({
    required this.question,
    required this.choices,
    required this.answer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final choicesRaw = json['choices'];
    if (choicesRaw is! Map<String, dynamic>) {
      throw Exception('Invalid choices format');
    }

    return QuestionModel(
      question: json['question'] ?? '',
      choices: Map<String, dynamic>.from(choicesRaw),
      answer: json['answer'] ?? '',
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
