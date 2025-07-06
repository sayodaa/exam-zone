abstract class GenerateExamState {
  final bool isGenerating;
  final double generatingProgress;

  GenerateExamState({
    this.isGenerating = false,
    this.generatingProgress = 0.0,
  });
}

class GenerateExamInitial extends GenerateExamState {
  GenerateExamInitial() : super(isGenerating: false, generatingProgress: 0.0);
}

class GeneratingExamInProgress extends GenerateExamState {
  GeneratingExamInProgress(double progress)
      : super(isGenerating: true, generatingProgress: progress);
}

class GenerateExamSuccess extends GenerateExamState {
  final List<dynamic> questions; // Mix of QuestionModel (MCQ) and Map<String, dynamic> (Essay)

  GenerateExamSuccess(this.questions)
      : super(isGenerating: false, generatingProgress: 1.0);
}

class GenerateExamFailure extends GenerateExamState {
  final String error;

  GenerateExamFailure(this.error)
      : super(isGenerating: false, generatingProgress: 0.0);
}
