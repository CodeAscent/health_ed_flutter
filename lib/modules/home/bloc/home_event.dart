import 'package:health_ed_flutter/modules/home/model/request/FeedbackRequest.dart';
import 'package:health_ed_flutter/modules/home/model/request/ReportRequest.dart';
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

class SubmitInstructionAcknowledgementRequest extends HomeEvent {
  final AcknowledgementRequest acknowledgementRequest;
  SubmitInstructionAcknowledgementRequest(
      {required this.acknowledgementRequest});
}

class GetReportRequested extends HomeEvent {
  final ReportRequest reportRequest;
  GetReportRequested({required this.reportRequest});
}

class GetInvoiceRequested extends HomeEvent {
  GetInvoiceRequested();
}

// Corrected version
class SubmitFeedbackRequest extends HomeEvent {
  final FeedbackRequest feedbackRequest;

  SubmitFeedbackRequest({required this.feedbackRequest});
}
