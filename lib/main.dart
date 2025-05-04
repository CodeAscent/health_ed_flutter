import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/modules/home/events/dashboard_events.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/core/theme/app_theme.dart';
import 'package:health_ed_flutter/modules/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/modules/auth/repository/auth_repository.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/splash_screen.dart';
import 'package:health_ed_flutter/modules/home/bloc/ActivityBlock.dart';
import 'package:health_ed_flutter/modules/home/bloc/ActivityInstructionsCubit.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:toastification/toastification.dart';
import 'modules/activity/bloc/DragEvent.dart';
import 'modules/home/bloc/QuizBloc.dart';
import 'modules/home/bloc/QuizEvent.dart';
import 'modules/home/bloc/VideoScreenBloc.dart';
import 'modules/home/bloc/dashboard_bloc.dart';
import 'modules/home/repository/home_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.initialize(); // Initialize local storage

  // Initialize the dashboard refresh event
  Get.put(Rx<DashboardRefreshEvent>(DashboardRefreshEvent()),
      tag: 'dashboard_refresh');

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc(AuthRepository()),
      ),
      BlocProvider(
        create: (context) => HomeBloc(HomeRepository()),
      ),
      BlocProvider<DashboardBloc>(
        create: (context) => DashboardBloc()..add(LoadDashboardData()),
      ),
      BlocProvider(create: (_) => ActivityCubit()),
      BlocProvider(create: (_) => ActivityInstructionsCubit()),
      BlocProvider(create: (_) => ScreenBloc()),
      BlocProvider(create: (_) => DragBloc()),
      BlocProvider(create: (context) => QuizBloc()..add(LoadQuizData())),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        theme: AppTheme.lightTheme(),
        title: 'Health Ed Tech',
        home: SplashScreen(),
      ),
    );
  }
}
