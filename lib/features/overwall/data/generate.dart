import 'package:graduation/features/overwall/data/quation_model.dart';

Future<List<dynamic>> generateQuiz(int numberOfQuestions, String subject, double difficulty) async {
  // Mock implementation (replace with actual API or logic)
  return List.generate(numberOfQuestions, (index) {
    if (index % 2 == 0) {
      // Multiple-choice question
      return QuestionModel(
        question: 'Sample MCQ ${index + 1} for $subject (Difficulty: $difficulty)',
        choices: {
          'A': 'Option A',
          'B': 'Option B',
          'C': 'Option C',
          'D': 'Option D',
        },
        answer: 'A',
      );
    } else {
      // Essay question
      return {
        'type': 'Essay',
        'question': 'Sample Essay ${index + 1} for $subject (Difficulty: $difficulty)',
      };
    }
  });
}