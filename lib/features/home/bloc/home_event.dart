import 'package:meta/meta.dart';

import '../model/request/AcknowledgementRequest.dart';

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

class SubmitAcknowledgementRequest extends HomeEvent {
  final AcknowledgementRequest acknowledgementRequest;
  SubmitAcknowledgementRequest({required this.acknowledgementRequest});
}
