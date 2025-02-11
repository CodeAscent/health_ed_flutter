abstract class QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<bool> quizLockStates;

  QuizLoaded(this.quizLockStates);
}
