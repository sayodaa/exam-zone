class EssayCorrectionModel {
  final int score;
  final String mistakes;
  final String feedback;

  EssayCorrectionModel({
    required this.score,
    required this.mistakes,
    required this.feedback,
  });

  factory EssayCorrectionModel.fromRawText(String raw) {
    // تحليل النص الناتج من الـ AI بناءً على بنية محددة متوقعة.
    final scoreReg = RegExp(r'Score\s*[:\-]?\s*(\d{1,2})');
    final mistakesReg = RegExp(r'(Mistakes|Errors|Issues)\s*[:\-]?\s*(.*?)\n\n', dotAll: true);
    final feedbackReg = RegExp(r'(Feedback|Comment|Advice)\s*[:\-]?\s*(.*)', dotAll: true);

    final scoreMatch = scoreReg.firstMatch(raw);
    final mistakesMatch = mistakesReg.firstMatch(raw);
    final feedbackMatch = feedbackReg.firstMatch(raw);

    return EssayCorrectionModel(
      score: int.tryParse(scoreMatch?.group(1) ?? '0') ?? 0,
      mistakes: mistakesMatch?.group(2)?.trim() ?? '',
      feedback: feedbackMatch?.group(2)?.trim() ?? '',
    );
  }
}