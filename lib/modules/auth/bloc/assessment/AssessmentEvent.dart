import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc Events
abstract class AssessmentEvent {}

class SelectFreeAssessment extends AssessmentEvent {}

class SelectPaidAssessment extends AssessmentEvent {}

// Bloc State
abstract class AssessmentState {}

class InitialAssessmentState extends AssessmentState {}

class FreeAssessmentSelected extends AssessmentState {}

class PaidAssessmentSelected extends AssessmentState {}

// Bloc Logic
class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  AssessmentBloc() : super(InitialAssessmentState());

  @override
  Stream<AssessmentState> mapEventToState(AssessmentEvent event) async* {
    if (event is SelectFreeAssessment) {
      yield FreeAssessmentSelected();
      // Handle navigation to Free Assessment
    } else if (event is SelectPaidAssessment) {
      yield PaidAssessmentSelected();
      // Handle navigation to Paid Assessment
    }
  }
}
