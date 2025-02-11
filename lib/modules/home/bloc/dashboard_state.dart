import 'package:equatable/equatable.dart';
import '../models/dashboard_models.dart';

// Abstract class for DashboardState
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

// Initial state when the dashboard is loading for the first time
class DashboardInitial extends DashboardState {}

// State when the dashboard is loading data
class DashboardLoading extends DashboardState {}

// State when dashboard data is successfully loaded
class DashboardLoaded extends DashboardState {
  final DashboardData dashboardData;

  const DashboardLoaded({required this.dashboardData});

  @override
  List<Object> get props => [dashboardData];
}

// State when there is an error loading the dashboard
class DashboardError extends DashboardState {
  final String errorMessage;

  const DashboardError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// Dummy activity class for the weekly report
class Activity extends Equatable {
  final String name;
  final String status;
  final String screenTime;

  Activity({
    required this.name,
    required this.status,
    required this.screenTime,
  });

  @override
  List<Object> get props => [name, status, screenTime];
}
