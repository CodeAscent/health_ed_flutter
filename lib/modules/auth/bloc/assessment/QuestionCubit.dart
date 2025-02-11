import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'QuestionState.dart';


class QuestionCubit extends Cubit<QuestionState> {
  List<Map<String, dynamic>> questions;
  int currentIndex;

  QuestionCubit(this.questions)
      : currentIndex = 0,
        super(QuestionInitial());

  void showNextQuestion() {
    if (currentIndex < questions.length - 1) {
      currentIndex++;
      emit(QuestionUpdated(questions[currentIndex]));
    }
  }

  void showPreviousQuestion() {
    if (currentIndex > 0) {
      currentIndex--;
      emit(QuestionUpdated(questions[currentIndex]));
    }
  }

  void loadInitialQuestion() {
    emit(QuestionUpdated(questions[currentIndex]));
  }
}
