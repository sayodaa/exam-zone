import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/features/overwall/data/generate.dart';
import 'package:graduation/features/overwall/presentation/cubit/generate_state.dart';

class GenerateExamCubit extends Cubit<GenerateExamState> {
  GenerateExamCubit() : super(GenerateExamInitial());

  double difficultyValue = 0.5;

  void setDifficulty(double value) {
    difficultyValue = value;
    emit(GenerateExamInitial());
  }

  Future<void> generateExam({
    required String subject,
    required int numberOfQuestions,
  }) async {
    try {
      emit(GeneratingExamInProgress(0));

      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        emit(GeneratingExamInProgress(i / 100));
      }

      final questionModels = await generateQuiz(numberOfQuestions, subject, difficultyValue);

      emit(GenerateExamSuccess(questionModels));
    } catch (e) {
      emit(GenerateExamFailure(e.toString()));
    }
  }
}
