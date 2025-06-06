import 'package:flutter/foundation.dart';
import 'package:health_ed_flutter/modules/home/model/request/FeedbackRequest.dart';
import 'package:health_ed_flutter/modules/home/model/response/GetAllDaysResponse.dart';
import 'package:health_ed_flutter/modules/home/model/response/ReportResponse.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllActivity.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResActivityInstructions.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResFeedback.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResUserAcknowledgement.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class AllDaysLoading extends HomeState {}

class AllActivityLoading extends HomeState {}

class ActivityInstructionLoading extends HomeState {}

class ActivityQuestionLoading extends HomeState {}

class SubmitAcknowledgeLoading extends HomeState {}

class SubmitFeedbackLoading extends HomeState {}

class reportLoading extends HomeState {}

class InvoiceLoading extends HomeState {}

class GetReportFailure extends HomeState {
  final String message;
  GetReportFailure({required this.message});
}

class GetInvoiceFailure extends HomeState {
  final String message;
  GetInvoiceFailure({required this.message});
}

class GetReportSuccess extends HomeState {
  final ReportResponse reportResponse;
  GetReportSuccess({required this.reportResponse});
}

class GetInvoiceSuccess extends HomeState {
  final ReportResponse reportResponse;
  GetInvoiceSuccess({required this.reportResponse});
}

class GetAllDayFailure extends HomeState {
  final String message;
  GetAllDayFailure({required this.message});
}

class GetAllDaySuccess extends HomeState {
  final GetAllDaysResponse getAllDaysResponse;
  GetAllDaySuccess({required this.getAllDaysResponse});
}

class GetActivityInstructionFailure extends HomeState {
  final String message;
  GetActivityInstructionFailure({required this.message});
}

class GetActivityInstructionSuccess extends HomeState {
  final ResActivityInstructions resActivityInstructions;
  GetActivityInstructionSuccess({required this.resActivityInstructions});
}

class GetAllActivityFailure extends HomeState {
  final String message;
  GetAllActivityFailure({required this.message});
}

class GetAllActivitySuccess extends HomeState {
  final ResAllActivity resAllActivity;
  GetAllActivitySuccess({required this.resAllActivity});
}

class GetAllQuestionFailure extends HomeState {
  final String message;
  GetAllQuestionFailure({required this.message});
}

class GetAllQuestionSuccess extends HomeState {
  final ResAllQuestion resAllQuestion;
  GetAllQuestionSuccess({required this.resAllQuestion});
}

class GetSubmitAcknowledgeResponse extends HomeState {
  final ResUserAcknowledgement resUserAcknowledgement;
  GetSubmitAcknowledgeResponse({required this.resUserAcknowledgement});
}

class GetSubmitAcknowledgeResponseFailure extends HomeState {
  final String message;
  GetSubmitAcknowledgeResponseFailure({required this.message});
}

class GetSubmitFeedBackResponseFailure extends HomeState {
  final String message;
  GetSubmitFeedBackResponseFailure({required this.message});
}

class GetSubmitFeedbackResponse extends HomeState {
  final ResFeedback resFeedback;
  GetSubmitFeedbackResponse({required this.resFeedback});
}
