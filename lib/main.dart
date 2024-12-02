import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/core/theme/app_theme.dart';
import 'package:health_ed_flutter/features/activity/views/DragDropScreen.dart';
import 'package:health_ed_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/features/auth/repository/auth_repository.dart';
import 'package:health_ed_flutter/features/auth/views/screens/login_screen.dart';
import 'package:health_ed_flutter/features/auth/views/screens/onboarding_screen.dart';
import 'package:health_ed_flutter/features/auth/views/screens/question_screen.dart';
import 'package:health_ed_flutter/features/auth/views/screens/signup_screen.dart';
import 'package:health_ed_flutter/features/auth/views/screens/splash_screen.dart';
import 'package:health_ed_flutter/features/auth/views/screens/verify_otp_screen.dart';
import 'package:health_ed_flutter/features/home/bloc/ActivityBlock.dart';
import 'package:health_ed_flutter/features/home/bloc/ActivityInstructionsCubit.dart';
import 'package:health_ed_flutter/features/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/features/home/views/screens/all_quizzes_screen.dart';
import 'package:toastification/toastification.dart';

import 'features/activity/bloc/DragEvent.dart';
import 'features/activity/views/MatchScreen.dart';
import 'features/activity/views/PictureDescriptionScreen.dart';
import 'features/activity/views/VideoDescriptionScreen.dart';
import 'features/auth/views/screens/assessment_screen.dart';
import 'features/home/bloc/QuizBloc.dart';
import 'features/home/bloc/QuizEvent.dart';
import 'features/home/bloc/VideoScreenBloc.dart';
import 'features/home/bloc/dashboard_bloc.dart';
import 'features/home/repository/home_repository.dart';
import 'features/home/views/screens/activity_Instructions_screen.dart';
import 'features/home/views/screens/activity_video_understanding_screen.dart';
import 'features/home/views/screens/all_activity_screen.dart';
import 'features/home/views/screens/blog_details_screen.dart';
import 'features/home/views/screens/blog_list_screen.dart';
import 'features/home/views/screens/home_screen.dart';
import 'features/navigation/views/screens/MainScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.initialize(); // Initialize local storage

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc(AuthRepository()),
      ),
      BlocProvider<DashboardBloc>(
        create: (context) => DashboardBloc()..add(LoadDashboardData()),
      ),
      BlocProvider(create: (_) => ActivityCubit()),
      BlocProvider(create: (_) => ActivityInstructionsCubit()),
      BlocProvider(create: (_) => ScreenBloc()),
      BlocProvider(create: (_) => DragBloc()),
      BlocProvider(create: (context) => QuizBloc()..add(LoadQuizData()),
      ),


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
        home:  SplashScreen(),
      ),
    );
  }
}
