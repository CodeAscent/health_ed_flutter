import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/dashboard_service.dart';
import '../models/dashboard_models.dart';
import 'dashboard_state.dart';

// Event to trigger data loading in the DashboardBloc
abstract class DashboardEvent {}

class LoadDashboardData extends DashboardEvent {}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {

  DashboardBloc() : super(DashboardLoading()) {
    // Registering the event handler for LoadDashboardEvent
    on<LoadDashboardData>((event, emit) async {
      try {
        emit(DashboardLoading());
        final response = await DashboardService.getDashboardData();
        emit(DashboardLoaded(dashboardData: response.data));
      } catch (e) {
        emit(DashboardError(errorMessage: e.toString()));
      }
    });
  }
}
