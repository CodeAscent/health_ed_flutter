import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_state.dart';
import 'package:health_ed_flutter/modules/home/repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc(this.homeRepository) : super(HomeInitial()) {
    on<GetAllDayRequested>(_getAllDays);
    on<GetActivityInstructionRequested>(_getActivityInstruction);
    on<GetAllActivityRequested>(_getAllActivity);
    on<GetAllQuestionRequested>(_getAllQuestion);
    on<SubmitAcknowledgementRequest>(_sendAcknowledgementRequest);
    on<SubmitFeedbackRequest>(_submitFeedBackRequest);
    on<GetReportRequested>(_getReport);
    on<GetInvoiceRequested>(_getInvoice);
  }

  Future<void> _getAllDays(
      GetAllDayRequested event, Emitter<HomeState> emit) async {
    emit(AllDaysLoading());
    try {
      final response = await homeRepository.getAllDays();
      emit(GetAllDaySuccess(getAllDaysResponse: response));
    } catch (error) {
      emit(GetAllDayFailure(message: error.toString()));
    }
  }

  Future<void> _getActivityInstruction(
      GetActivityInstructionRequested event, Emitter<HomeState> emit) async {
    emit(ActivityInstructionLoading());
    try {
      final response =
          await homeRepository.getActivityInstruction(event.activityId);
      emit(GetActivityInstructionSuccess(resActivityInstructions: response));
    } catch (error) {
      emit(GetActivityInstructionFailure(message: error.toString()));
    }
  }

  Future<void> _getAllActivity(
      GetAllActivityRequested event, Emitter<HomeState> emit) async {
    emit(AllActivityLoading());
    try {
      final response = await homeRepository.getAllActivity(event.activityId);
      emit(GetAllActivitySuccess(resAllActivity: response));
    } catch (error) {
      emit(GetAllActivityFailure(message: error.toString()));
    }
  }

  Future<void> _getAllQuestion(
      GetAllQuestionRequested event, Emitter<HomeState> emit) async {
    emit(ActivityQuestionLoading());
    try {
      final response = await homeRepository.getAllQuestion(event.activityId);
      emit(GetAllQuestionSuccess(resAllQuestion: response));
    } catch (error) {
      emit(GetAllQuestionFailure(message: error.toString()));
    }
  }

  Future<void> _sendAcknowledgementRequest(
      SubmitAcknowledgementRequest event, Emitter<HomeState> emit) async {
    emit(SubmitAcknowledgeLoading());
    try {
      final response = await homeRepository
          .submitAcknowledgement(event.acknowledgementRequest);
      emit(GetSubmitAcknowledgeResponse(resUserAcknowledgement: response));
    } catch (error) {
      emit(GetSubmitAcknowledgeResponseFailure(message: error.toString()));
    }
  }

  Future<void> _submitFeedBackRequest(
      SubmitFeedbackRequest event, Emitter<HomeState> emit) async {
    emit(SubmitFeedbackLoading());
    try {
      final response =
          await homeRepository.submitFeedback(event.feedbackRequest);
      emit(GetSubmitFeedbackResponse(resFeedback: response));
    } catch (error) {
      emit(GetSubmitFeedBackResponseFailure(message: error.toString()));
    }
  }

  Future<void> _getReport(
      GetReportRequested event, Emitter<HomeState> emit) async {
    emit(reportLoading());
    try {
      final response = await homeRepository.getReport(event.reportRequest);

      emit(GetReportSuccess(reportResponse: response));
      print("GetReportSuccess");
    } catch (error) {
      emit(GetReportFailure(message: error.toString()));
    }
  }

  Future<void> _getInvoice(
      GetInvoiceRequested event, Emitter<HomeState> emit) async {
    emit(InvoiceLoading());
    try {
      final response = await homeRepository.getInvoice();
      emit(GetInvoiceSuccess(reportResponse: response));
    } catch (error) {
      emit(GetInvoiceFailure(message: error.toString()));
    }
  }
}
