import 'package:bloc/bloc.dart';

import 'QuizEvent.dart';
import 'QuizState.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizLoading()) {
    on<LoadQuizData>((event, emit) {
      // Simulate fetching data (e.g., locked status for quizzes)
      List<bool> lockStates = [
        false, false, false,
        true, true, true,
        true, true, true,
        // Add more states for other days...
      ];

      emit(QuizLoaded(lockStates));
    });
  }
}
