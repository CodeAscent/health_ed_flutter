import 'package:flutter/foundation.dart';
import 'package:health_ed_flutter/features/home/model/response/GetAllDaysResponse.dart';
import 'package:health_ed_flutter/features/home/model/response/ResAllActivity.dart';
import 'package:health_ed_flutter/features/home/model/response/ResActivityInstructions.dart';

@immutable
abstract class HomeState {}


class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class AllDaysLoading extends HomeState {}

class AllActivityLoading extends HomeState {}

class ActivityInstructionLoading extends HomeState {}

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
