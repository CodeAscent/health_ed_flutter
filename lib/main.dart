import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/core/theme/app_theme.dart';
import 'package:health_ed_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/features/auth/repository/auth_repository.dart';
import 'package:health_ed_flutter/features/auth/views/screens/splash_screen.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.initialize(); // Initialize local storage

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc(AuthRepository()),
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
        home: const SplashScreen(),
      ),
    );
  }
}
