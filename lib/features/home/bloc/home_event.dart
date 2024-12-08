import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent {}

class GetAllDayRequested extends HomeEvent {}

class GetActivityInstructionRequested extends HomeEvent {
  final String activityId;
  GetActivityInstructionRequested({required this.activityId});
}

class GetAllActivityRequested extends HomeEvent {
  final String activityId;
  GetAllActivityRequested({required this.activityId});
}

class GetAllQuestionRequested extends HomeEvent {
  final String activityId;
  GetAllQuestionRequested({required this.activityId});
}
