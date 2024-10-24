import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';

// Event to trigger data loading in the DashboardBloc
abstract class DashboardEvent {}

class LoadDashboardData extends DashboardEvent {}


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardLoading()) {
    // Registering the event handler for LoadDashboardEvent
    on<LoadDashboardData>((event, emit) async {
      // Emit the loading state
      emit(DashboardLoading());
      await Future.delayed(Duration(seconds: 2)); // Simulating network delay

      // Mock data for demonstration
      List<bool> quizzes = [true, false, true]; // Replace with real data
      int weeklyProgress = 20; // Replace with real data
      int monthlyProgress = 100; // Replace with real data
      int yearlyProgress = 800; // Replace with real data
      List<Activity> report = [
        Activity(name: "1", status: "Completed", screenTime: "2 Min"),
        Activity(name: "2", status: "In Progress", screenTime: "1 Min"),
        Activity(name: "3", status: "Pending", screenTime: "0 Min"),
      ];

      // Emit the loaded state with the fetched data
      emit(DashboardLoaded(
        quizzes: quizzes,
        weeklyProgress: weeklyProgress,
        monthlyProgress: monthlyProgress,
        yearlyProgress: yearlyProgress,
        report: report,
      ));
    });
  }
}
